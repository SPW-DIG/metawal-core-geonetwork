package org.fao.geonet.monitor.webapp;

import com.yammer.metrics.core.HealthCheck;
import com.yammer.metrics.core.HealthCheckRegistry;
import jeeves.utils.Xml;
import org.hibernate.exception.ExceptionUtils;
import org.jdom.Element;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

/**
 * An HTTP servlet which runs the health checks registered with a given {@link com.yammer.metrics.core.HealthCheckRegistry}
 * and prints the results as a {@code text/plain} entity. Only responds to {@code GET} requests.
 * <p/>
 * If the servlet context has an attribute named
 * {@code com.yammer.metrics.reporting.HealthCheckServlet.registry} which is a
 * {@link com.yammer.metrics.core.HealthCheckRegistry} instance, {@link org.fao.geonet.monitor.webapp.GeonetworkHealthCheckForDummiesServlet} will use it instead of
 * {@link com.yammer.metrics.HealthChecks}.
 */
public class GeonetworkHealthCheckForDummiesServlet extends HttpServlet {
    private static final long serialVersionUID = 5367584489771010404L;
    /**
     * The attribute name of the {@link com.yammer.metrics.core.HealthCheckRegistry} instance in the servlet context.
     */
    public static final String REGISTRY_ATTRIBUTE_KEY = "REGISTRY_ATTRIBUTE_KEY";
    private static final String CONTENT_TYPE = "application/json";

    private transient HealthCheckRegistry registry;

    @Override
    public void init(ServletConfig config) throws ServletException {
        String registryAttribute = config.getInitParameter(REGISTRY_ATTRIBUTE_KEY);
        registry = (HealthCheckRegistry) config.getServletContext().getAttribute(registryAttribute );
        if(registry == null) {
            throw new IllegalStateException("Expected a HealthCheckRegistery to be registered in the ServletContext attributes but there was none");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp) throws ServletException, IOException {
        final Map<String, HealthCheck.Result> results = registry.runHealthChecks();
        resp.setContentType(CONTENT_TYPE);
        resp.setHeader("Cache-Control", "must-revalidate,no-cache,no-store");
        final PrintWriter writer = resp.getWriter();
        String responseForDummies = "KO";
        Element report = new Element("report");
        if (results.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_OK);
            responseForDummies = "OK";
        } else {
            if (isAllHealthy(results)) {
                resp.setStatus(HttpServletResponse.SC_OK);
                responseForDummies = "OK";
            } else {
                resp.setStatus(HttpServletResponse.SC_OK);
            }
        }
        writer.println(responseForDummies);
        writer.close();
    }

    private static boolean isAllHealthy(Map<String, HealthCheck.Result> results) {
        for (HealthCheck.Result result : results.values()) {
            if (!result.isHealthy()) {
                return false;
            }
        }
        return true;
    }
}