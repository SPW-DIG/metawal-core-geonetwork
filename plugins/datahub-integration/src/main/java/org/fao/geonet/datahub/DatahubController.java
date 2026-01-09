package org.fao.geonet.datahub;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.zip.GZIPOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpHeaders;
import org.fao.geonet.NodeInfo;
import org.fao.geonet.domain.Source;
import org.fao.geonet.domain.SourceType;
import static org.fao.geonet.kernel.schema.SchemaPlugin.LOGGER_NAME;
import org.fao.geonet.repository.SourceRepository;
import org.fao.geonet.utils.Log;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.RedirectView;

// FIXME: unit tests missing for this class!

/**
 * Controller for handling requests for client application.
 * <p/>
 * To add a new app:
 * <ul>
 *     <li>Build the app in pom.xml</li>
 *     <li>Add the app name in the request mapping</li>
 *     <li>Register it in the config-security-mapping.xml.</li>
 * </ul>
 */
@RequestMapping(value = {
    "/{geonetworkPath:[a-zA-Z0-9_\\-]+}/{app:datahub|metadata-editor}",
    "/{geonetworkPath:[a-zA-Z0-9_\\-]+}/{locale:[a-z]{2,3}}/{app:datahub|metadata-editor}"
})
@Controller
public class DatahubController {
    public static final String INDEX_PATH = "index.html";
    public static final String DEFAULT_CONFIGURATION_FILE_PATH = "assets/configuration/default.toml";

    @Autowired
    SourceRepository sourceRepository;

    @GetMapping("/status")
    public ResponseEntity<String> getDatahubStatus(@PathVariable String app) throws IOException {
        File configFile = FileUtils.getFileFromJar(String.format("%s/%s", app, DEFAULT_CONFIGURATION_FILE_PATH));
        String defaultConfig = FileUtils.readFromInputStream(new FileInputStream(configFile));
        JSONObject body = new JSONObject();
        body.put("defaultConfig", defaultConfig);

        File packageJsonFile = FileUtils.getFileFromJar(String.format("%s/package.json", app));
        String packageJsonContent = FileUtils.readFromInputStream(new FileInputStream(packageJsonFile));
        JSONObject packageJson = new JSONObject(packageJsonContent);
        body.put("datahubVersion", packageJson.getString("version"));

        return ResponseEntity
            .ok()
            .contentType(MediaType.APPLICATION_JSON)
            .body(body.toString());
    }

    @GetMapping
    public RedirectView redirectDatahub(@PathVariable String app, HttpServletRequest request) {
        String uri = request.getRequestURI();
        if (!uri.endsWith("/")) {
            uri += "/";
        }
        return new RedirectView(uri + INDEX_PATH);
    }

    @RequestMapping("/**")
    public void handleDatahubWithFilepath(@PathVariable String app, HttpServletRequest request, HttpServletResponse response) throws IOException {
        handleDatahubRequest(request, response, app);
    }

    void handleDatahubRequest(HttpServletRequest request, HttpServletResponse response, String app)
        throws IOException {
        String portalName = getPortalName(request);
        if (!isPortalDatahubEnabled(portalName)) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File actualFile = getRequestedFile(request, app);
        if (!actualFile.exists()) {
            actualFile = getFallbackFile(app);
            disableCacheForIndex(response);
        }

        setResponseHeaders(response, actualFile);
        writeResponseContent(request, response, actualFile, portalName, app);
    }

    private String getPortalName(HttpServletRequest request) {
        String reqPath = request.getPathInfo();
        String[] parts = reqPath.split("/");
        return FilenameUtils.getName(parts[1]);
    }

    private boolean isPortalDatahubEnabled(String portalName) {
        if (NodeInfo.DEFAULT_NODE.equals(portalName)) {
            return true;
        } else if (sourceRepository.existsByUuidAndType(portalName, SourceType.subportal)) {
            return Objects.requireNonNull(sourceRepository.findOneByUuid(portalName)).getDatahubEnabled();
        }
        return false;
    }

    private File getRequestedFile(HttpServletRequest request, String app) {
        String reqPath = request.getPathInfo();
        String appPath = String.format("/%s/", app);
        String filePath = Stream.of(reqPath.split(appPath)).skip(1).collect(Collectors.joining("/"));
        filePath = FilenameUtils.normalize(filePath);
        try {
            return FileUtils.getFileFromJar(appPath + filePath);
        } catch (IOException e) {
            return new File(appPath + INDEX_PATH);// return file doesn't exist in jar => go back to main menu
        }
    }

    private File getFallbackFile(String app) {
        try {
            return FileUtils.getFileFromJar(INDEX_PATH);
        } catch (IOException e) {
            Log.error(LOGGER_NAME, e.getMessage());
            return new File(String.format("/%s/%s", app, INDEX_PATH));
        }
    }

    private void disableCacheForIndex(HttpServletResponse response) {
        response.setHeader(HttpHeaders.CACHE_CONTROL, "no-cache");
        response.setHeader(HttpHeaders.PRAGMA, "no-cache");
        response.setHeader(HttpHeaders.EXPIRES, "0");
    }

    private void setResponseHeaders(HttpServletResponse response, File actualFile) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        String extension = actualFile.getName().toLowerCase();
        String contentType = extension.equals("js") ? "text/javascript; charset=UTF-8"
            : Files.probeContentType(actualFile.toPath());
        response.setContentType(contentType);
    }

    void writeResponseContent(HttpServletRequest request, HttpServletResponse response, File actualFile,
                              String portalName, String app) throws IOException {
        InputStream inStream = actualFile.getName().equals("default.toml") ? readConfiguration(request.getContextPath(), portalName)
            : new FileInputStream(actualFile);
        OutputStream outStream = response.getOutputStream();

        if (request.getHeader(HttpHeaders.ACCEPT_ENCODING).contains("gzip")) {
            response.setHeader(HttpHeaders.CONTENT_ENCODING, "gzip");
            outStream = new GZIPOutputStream(outStream);
        }

        if (actualFile.getName().equals("index.html")) {
            // rewrite the base-href attribute to make app routing work
            String baseHref = String.format("%s/%s/%s/", request.getContextPath(), portalName, app);
            String content = IOUtils
                .toString(inStream, StandardCharsets.UTF_8)
                .replaceAll("<base href=\".*\">", "<base href=\"" + baseHref + "\">");
            outStream.write(content.getBytes());
        } else {
            IOUtils.copy(inStream, outStream);
        }

        outStream.close();
    }

    InputStream readConfiguration(String contextPath, String portalName) throws IOException {
        String configuration = getPortalConfiguration(portalName);
        configuration = configuration.replaceAll("\ngeonetwork4_api_url\\s?=.+", "\n")
            .replace("[global]",
                String.format("[global]\ngeonetwork4_api_url = \"%s/%s/api\"", contextPath, portalName));
        return new ByteArrayInputStream(configuration.getBytes());
    }

    private String getPortalConfiguration(String portalName) throws IOException {
        Source portal = Objects.requireNonNull(sourceRepository.findByType(SourceType.portal, null)).get(0);
        if (isNotDefaultPortal(portalName)) {
            portal = sourceRepository.findOneByUuid(portalName);
        }

        // 1. read for subportal
        if (datahubConfigurationExist(portal)) {
            return portal.getDatahubConfiguration();
        }
        // 2. fallback: read from main portal
        else if (isNotDefaultPortal(portalName)) {
            return this.getPortalConfiguration(NodeInfo.DEFAULT_NODE);
        }
        // 3. fallback: read from default.toml file in resource
        else {
            // TODO: Could we have different default configurations for different apps?
            File defaultConfig = FileUtils.getFileFromJar("/datahub/" + DEFAULT_CONFIGURATION_FILE_PATH);
            return FileUtils.readFromInputStream(new FileInputStream(defaultConfig));
        }
    }

    private boolean isNotDefaultPortal(String portalName) {
        return !portalName.equals(NodeInfo.DEFAULT_NODE);
    }

    private boolean datahubConfigurationExist(Source portal) {
        return portal != null
            && portal.getDatahubConfiguration() != null
            && !portal.getDatahubConfiguration().isEmpty();
    }
}
