package org.fao.geonet.api.records;

import java.io.StringReader;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import jeeves.server.context.ServiceContext;
import org.apache.jena.graph.Graph;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.riot.Lang;
import org.apache.jena.riot.RDFDataMgr;
import org.apache.jena.shacl.ShaclValidator;
import org.apache.jena.shacl.Shapes;
import org.apache.jena.shacl.ValidationReport;
import org.apache.jena.shacl.lib.ShLib;
import org.fao.geonet.api.records.formatters.FormatType;
import org.fao.geonet.api.records.formatters.FormatterApi;
import org.fao.geonet.api.records.formatters.FormatterWidth;
import org.fao.geonet.api.records.formatters.cache.Key;
import org.fao.geonet.domain.AbstractMetadata;
import org.fao.geonet.kernel.GeonetworkDataDirectory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ShaclValidationService {

    @Autowired
    GeonetworkDataDirectory dataDirectory;

    public String convertMetadataToRdf(AbstractMetadata metadata, String formatter, ServiceContext context) {
        try {
            Key key = new Key(metadata.getId(), "eng", FormatType.xml, formatter, true, FormatterWidth._100);

            final FormatterApi.FormatMetadata formatMetadata =
                new FormatterApi().new FormatMetadata(context, key, null);
            final byte[] data = formatMetadata.call().data;
            return new String(data, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "Error loading metadata: " + e.getMessage();
        }
    }

    /**
     * Return list of *.ttl files in shacl directory.
     */
    public List<String> getShaclValidationFiles() {
        Path shaclRulesFolder = this.dataDirectory.getConfigDir().resolve("shacl");
        try (Stream<Path> paths = java.nio.file.Files.walk(shaclRulesFolder)) {
            return paths.filter(path -> path.toString().endsWith(".ttl"))
                .map(path -> shaclRulesFolder.relativize(path).toString())
                .collect(Collectors.toList());
        } catch (Exception e) {
            return List.of();
        }
    }

    public String validate(String formatter, AbstractMetadata metadata, String shaclShapes, ServiceContext context) {

        String rdfToValidate = convertMetadataToRdf(metadata, formatter, context);

        Graph shapesGraph;
        Shapes shapes;
        Path shaclPath = this.dataDirectory.getConfigDir().resolve("shacl").resolve(shaclShapes);
        try {
            shapesGraph = RDFDataMgr.loadGraph(shaclPath.toString());
            shapes = Shapes.parse(shapesGraph);
        } catch (Exception e) {
//            fail(String.format(
//                "%s. Checked with %s [%s]. SHACL graph error. Error is: %s",
//                url, checkfile, shaclShapes, e.getMessage()));
            return "Error loading SHACL shapes: " + e.getMessage();
        }

//        Graph dataGraph = RDFDataMgr.loadGraph(rdfToValidate);
        Model model = ModelFactory.createDefaultModel();
        try (StringReader reader = new StringReader(rdfToValidate)) {
            RDFDataMgr.read(model, reader, null, org.apache.jena.riot.Lang.RDFXML);
        } catch (Exception rdfException) {
            System.out.println(rdfException.getMessage());
            System.out.println(rdfToValidate);
            return "Document is not valid RDF/XML: " + rdfException.getMessage();
        }
        ValidationReport report = ShaclValidator.get().validate(shapes, model.getGraph());

        if (!report.conforms()) {
            long count = report.getEntries().stream()
                .filter(e -> e.severity().level().getURI().equals("http://www.w3.org/ns/shacl#Violation"))
                .count();

            ShLib.printReport(report);
            StringWriter   stringWriter = new StringWriter();
            RDFDataMgr.write(System.out, report.getModel(), Lang.TTL);
            RDFDataMgr.write(stringWriter, report.getModel(), Lang.RDFXML);
            return stringWriter.toString();
//            fail(String.format("%s. Checked with %s [%s]. Invalid DCAT-AP document. %d violations found. See report in the test console output.",
//                url, checkfile, shaclShapes, count));
        } else {
            return "Document is valid.";
        }
    }
}
