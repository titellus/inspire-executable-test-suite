<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <!-- Define all namespaces to use -->
  <ns uri="urn:x-inspire:specification:gmlas:ProtectedSites:3.0" prefix="ps"/>
  <ns uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
  
  <let name="designationTypeCategoryRegistry" value="document('../../resources/registries/designationtypecategory.xml')"/>
  
  <diagnostics>
    <diagnostic id="ir-ps-as-ps-A12-failure-en" 
      xml:lang="en">
      <value-of select="$designationTypeValue"/> (
      <value-of select="$designationTypeCode"/>)
      was not found in registry.
    </diagnostic>
  </diagnostics>
  
  
  <pattern>
    <title>Value type test</title>
    <p>
      a) Purpose: Verification whether all attributes or association roles use the corresponding value types
      specified in the application schema(s).
      b) Reference: Art. 3, Art.4, Art.6(1), Art.6(4), Art.6(5) and Art.9(1)of Commission Regulation No
      1089/2010.
      c) Test Method: Examine whether the value type of each provided attribute or association role adheres
      to the corresponding value type specified in the target specification.
      NOTE 1 This test comprises testing the value types of INSPIRE identifiers, 
      the value types of attributes and association roles 
      that should be taken from enumeration and code lists, and the coverage domains.
      NOTE 2 Further technical information is in the Feature catalogue and UML diagram of the application
      schema(s) in section 5.2.
    </p>
    
    <!-- Rule for designation type category -->
    <rule context="ps:DesignationType[ps:designationScheme/@codeSpace = 'http://dd.eionet.europa.eu/vocabulary/cdda/designationtypecategory/view']">
     <let name="designationTypeValue" value="ps:designation/text()"/>
      <let name="designationTypeCode" value="ps:designation/@codeSpace"/>
      <let name="isExistingInRegistry" value="count($designationTypeCategoryRegistry//containeditems/value[@id = $designationTypeCode]) &gt; 0"/>
      
      <assert test="$isExistingInRegistry" diagnostics="ir-ps-as-ps-A12-failure-en"/>
    </rule>
  </pattern>
  
</schema>