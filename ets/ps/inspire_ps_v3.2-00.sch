<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <!-- Define all namespaces to use -->
  <ns uri="urn:x-inspire:specification:gmlas:ProtectedSites:3.0" prefix="ps"/>
  <ns uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
  
  <!-- A pattern define a set of rules. -->
  <pattern id="A.1.1">
    <title>A.1.1 Schema element denomination test</title>
    <p>
      a) Purpose: Verification whether each element of the dataset under inspection carries a name
      specified in the target application schema(s).
      b) Reference: Art. 3 and Art.4 of Commission Regulation No 1089/2010
      c) Test Method: Examine whether the corresponding elements of the source schema (spatial object
      types, data types, attributes, association roles, code lists, and enumerations) are mapped to the target
      schema with the correct designation of mnemonic names.
      NOTE Further technical information is in the Feature catalogue and UML diagram of the application
      schema(s) in section 5.2
    </p>
    <rule context="ps:ProtectedSite">
      <!-- Let allows to define variables that could be
      used later in the tests or diagnostic. -->
      <let name="featureId" value="@gml:id"/>
      <let name="hasAtLeastOneName" value="count(ps:siteName) &gt; 0"/>
      
      <assert test="$hasAtLeastOneName">
        At least one name is required. 
        None found for feature with identifier '<value-of select="$featureId"/>'.
      </assert>
    </rule>
  </pattern>
</schema>