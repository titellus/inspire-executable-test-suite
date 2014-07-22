<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <!-- Define all namespaces to use -->
  <ns uri="urn:x-inspire:specification:gmlas:ProtectedSites:3.0" prefix="ps"/>
  <ns uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
  
  
  
  <!-- Diagnostics are used to define messages in case of 
  errors. Diagnostics may be multilingual using the xml:lang attribute.
  -->
  <diagnostics xmlns="http://purl.oclc.org/dsdl/schematron">
    
    <!-- A diagnostic could refer to pattern variables to 
    make message more readable. -->
    <diagnostic id="ir-ps-as-ps-A11-failure-en" 
      xml:lang="en">
      Invalid schema element denomination for feature with identifier 
      '<value-of select="$featureId"/>'.
    </diagnostic>
    <diagnostic id="ir-ps-as-ps-A11-failure-fr" 
      xml:lang="fr">
      Dénomination incorrecte pour l'entité ayant l'identifiant 
      '<value-of select="$featureId"/>'.
    </diagnostic>
  </diagnostics>
  
  
  
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
      
      <assert test="$hasAtLeastOneName" diagnostics="ir-ps-as-ps-A11-failure-en ir-ps-as-ps-A11-failure-fr"/>
    </rule>
  </pattern>
</schema>