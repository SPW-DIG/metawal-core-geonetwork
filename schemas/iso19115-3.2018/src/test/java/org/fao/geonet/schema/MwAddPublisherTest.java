/*
 * Copyright (C) 2001-2026 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */
package org.fao.geonet.schema;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.assertThat;
import static org.xmlunit.matchers.EvaluateXPathMatcher.hasXPath;

import org.fao.geonet.schema.iso19115_3_2018.ISO19115_3_2018SchemaPlugin;
import org.fao.geonet.schemas.XslProcessTest;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.Test;

public class MwAddPublisherTest extends XslProcessTest {

    public MwAddPublisherTest() {
        super();
        this.setXslFilename("process/mw-add-publisher.xsl");
        this.setXmlFilename("metadata.xml");
        this.setNs(ISO19115_3_2018SchemaPlugin.allNamespaces);
    }


    @Test
    public void testAddPublisherDoesNothingIfNoCustodian() throws Exception {
        Element inputElement = Xml.loadFile(xmlFile);
        String inputString = Xml.getString(inputElement);
        assertThat(inputString, hasXPath(
            "count(/mdb:MD_Metadata/mdb:identificationInfo/*/mri:pointOfContact" +
                "[cit:CI_Responsibility/cit:role/*/@codeListValue = 'publisher'])",
            equalTo("0")).withNamespaceContext(ns));

        Element firstResult = Xml.transform(inputElement, xslFile);
        String firstResultString = Xml.getString(firstResult);

        assertThat(firstResultString, hasXPath(
            "count(/mdb:MD_Metadata/mdb:identificationInfo/*/mri:pointOfContact" +
                "[cit:CI_Responsibility/cit:role/*/@codeListValue = 'publisher'])",
            equalTo("0")).withNamespaceContext(ns));
    }

    @Test
    public void testAddPublisherFromSpwCustodian() throws Exception {
        Element inputElement = Xml.loadFile(testClass.getClassLoader().getResource("mw-constraints-ccby.xml"));
        String inputString = Xml.getString(inputElement);
        assertThat(inputString, hasXPath(
            "count(/mdb:MD_Metadata/mdb:identificationInfo/*/mri:pointOfContact" +
                "[cit:CI_Responsibility/cit:role/*/@codeListValue = 'publisher'])",
            equalTo("0")).withNamespaceContext(ns));

        Element firstResult = Xml.transform(inputElement, xslFile);
        String firstResultString = Xml.getString(firstResult);

        assertThat(firstResultString, hasXPath(
            "count(/mdb:MD_Metadata/mdb:identificationInfo/*/mri:pointOfContact" +
                "[cit:CI_Responsibility/cit:role/*/@codeListValue = 'publisher'])",
            equalTo("1")).withNamespaceContext(ns));
        assertThat(firstResultString, hasXPath(
            "/mdb:MD_Metadata/mdb:identificationInfo/*/mri:pointOfContact" +
                "[cit:CI_Responsibility/cit:role/*/@codeListValue = 'publisher']" +
                "/cit:CI_Responsibility/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString",
            equalTo("SPW - Agriculture, Ressources naturelles et Environnement")).withNamespaceContext(ns));
        assertThat(firstResultString, hasXPath(
            "/mdb:MD_Metadata/mdb:identificationInfo/*/mri:pointOfContact" +
                "[cit:CI_Responsibility/cit:role/*/@codeListValue = 'publisher']" +
                "/cit:CI_Responsibility/cit:party/cit:CI_Organisation/cit:contactInfo/cit:CI_Contact" +
                "/cit:address/cit:CI_Address/cit:electronicMailAddress/gco:CharacterString",
            equalTo("natura2000@spw.wallonie.be")).withNamespaceContext(ns));

        Element secondResult = Xml.transform(firstResult, xslFile);
        String secondResultString = Xml.getString(secondResult);
        assertThat(secondResultString, hasXPath(
            "count(/mdb:MD_Metadata/mdb:identificationInfo/*/mri:pointOfContact" +
                "[cit:CI_Responsibility/cit:role/*/@codeListValue = 'publisher'])",
            equalTo("1")).withNamespaceContext(ns));
    }
}
