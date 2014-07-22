<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <!-- Define all namespaces to use -->
  <ns uri="urn:x-inspire:specification:gmlas:ProtectedSites:3.0" prefix="ps"/>
  <ns uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
  
  
  
  <!-- Define all global variables that may be required 
    in more than one tests. -->
  <let name="datePattern" value="'[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}'"/>
  
  
  <diagnostics>
    <diagnostic id="ir-ps-as-ps-A24-failure-en" 
      xml:lang="en">
      '<value-of select="$dateValue"/>'
      does not match pattern (<value-of select="$datePattern"/>) for date in feature 
      '<value-of select="$featureId"/>'
    </diagnostic>
  </diagnostics>
  
  
  <pattern id="A.2.4">
    <title>A.2.4 Temporal reference system test</title>
    <p>
      a) Purpose: Verify whether date and time values are given as specified in Commission Regulation No
      1089/2010.
      b) Reference: Art.11(1) of Commission Regulation 1089/2010
      c) Test Method: Check whether:
       the Gregorian calendar is used as a reference system for date values;
       the Universal Time Coordinated (UTC) or the local time including the time zone as an offset
      from UTC are used as a reference system for time values.
      NOTE Further technical information is given in Section 6 of this document.
    </p>
    <rule context="ps:*[ends-with(name(), 'Date')]">
      <let name="featureId" value="ancestor::ps:ProtectedSite/@gml:id"/>
      <let name="dateValue" value="text()"/>
      
      <let name="isMathingDatePattern" 
        value="matches($dateValue, $datePattern)"/>
      
      <assert test="$isMathingDatePattern" diagnostics="ir-ps-as-ps-A24-failure-en"/>
    </rule>
  </pattern>
  
</schema>