<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <!-- Define all namespaces to use -->
  <ns uri="urn:x-inspire:specification:gmlas:ProtectedSites:3.0" prefix="ps"/>
  <ns uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
  
  
  
  <diagnostics>
    <diagnostic id="ir-ps-as-ps-A21-failure-en" 
      xml:lang="en">
      '<value-of select="$srsName"/>'
      was not found in the list of valid SRS in feature 
      '<value-of select="$featureId"/>'.
    </diagnostic>
  </diagnostics>
  
  <pattern id="A.2.1">
    <title>A.2.1 Datum test</title>
    <p>
      a) Purpose: Verify whether each instance of a spatial object type is given with reference to one of the
      (geodetic) datums specified in the target specification.
      c) Reference: Annex II Section 1.2 of Commission Regulation No 1089/2010
      b) Test Method: Check whether each instance of a spatial object type specified in the application
      schema(s) in section 5 has been expressed using:
       the European Terrestrial Reference System 1989 (ETRS89) within its geographical scope; or
       the International Terrestrial Reference System (ITRS) for areas beyond the ETRS89
      geographical scope; or
       other geodetic coordinate reference systems compliant with the ITRS. Compliant with the
      ITRS means that the system definition is based on the definition of ITRS and there is a well-
      established and described relationship between both systems, according to the EN ISO
      19111.
      NOTE Further technical information is given in Section 6 of this document.
    </p>
    <let name="listOfValidSrs" value="('urn:ogc:def:crs:EPSG::4258', 'urn:ogc:def:crs:EPSG::4326')"/>
    <rule context="ps:geometry/gml:*">
      <!-- Get a reference for the current feature tested. 
      It's nice to have this reference in reporting failure
      so user could easily find the features to be fixed.
      -->
      <let name="featureId" value="ancestor::ps:ProtectedSite/@gml:id"/>
      
      <let name="srsName" value="@srsName"/>
      <let name="isValidSrs" value="exists($listOfValidSrs[. = $srsName])"/>
      <!-- Could be also written using $listOfValidSrs = $srsName -->
      
      <assert test="$isValidSrs" diagnostics="ir-ps-as-ps-A21-failure-en"/>
    </rule>
  </pattern>
</schema>