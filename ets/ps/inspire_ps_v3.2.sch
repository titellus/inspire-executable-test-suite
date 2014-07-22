<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <!-- Define all namespaces to use -->
  <ns uri="urn:x-inspire:specification:gmlas:ProtectedSites:3.0" prefix="ps"/>
  <ns uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
  
  
  
  
  <!-- Define all global variables that may be required 
    in more than one tests. -->
  <let name="datePattern" value="'[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}'"/>
  
  <!-- Load remote resources needed for testing.
  Document could be retrieved by HTTP or in local filesystem.
  -->
  <let name="designationTypeCategoryRegistry" value="document('../../resources/registries/designationtypecategory.xml')"/>
  
  <let name="designationsRegistry" value="document('../../resources/registries/designations.xml')"/>
  
  
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
      Invalid schema element denomination 
      '<value-of select="$featureId"/>'.
    </diagnostic>
    
    <diagnostic id="ir-ps-as-ps-A11-report-en" 
      xml:lang="en">
      <value-of select="$numberOfNames"/>
      element denomination(s) found.
    </diagnostic>
    <diagnostic id="ir-ps-as-ps-A11-report-fr" 
      xml:lang="fr">
      <value-of select="$numberOfNames"/>
      nom(s) identifié(s).
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
    <!-- A rule is applied to a context (ie. an element in the XML
    document to be tested).-->
    <rule context="ps:ProtectedSite">
      
      
      <!-- Let allows to define variables that could be
      used later in the tests or diagnostic. -->
      <let name="featureId" value="@gml:id"/>
      <let name="hasAtLeastOneName" value="count(ps:siteName) &gt; 0"/>
      
      <!-- 
        one-or-more XSL function could not be use for that because
        it will trigger an engine error.
        
        eg.
        <let name="oneOrMoreNames" value="one-or-more(ps:siteName)"/>
        
        Severity: error
        Description: An empty sequence is not allowed as the first argument of one-or-more()
      -->
      
      <!-- The test -->
      <!--<report test="$numberOfNames &gt; 0" diagnostics="ir-ps-as-ps-A11-report-en ir-ps-as-ps-A11-report-fr" flag="info"/>-->
      <assert test="$hasAtLeastOneName" diagnostics="ir-ps-as-ps-A11-failure-en ir-ps-as-ps-A11-failure-fr"/>
    </rule>
  </pattern>
  
  
  <diagnostics>
    <diagnostic id="ir-ps-as-ps-A12-failure-en" 
      xml:lang="en">
      <value-of select="$designationTypeValue"/> (
      <value-of select="$designationTypeCode"/>)
      was not found in <value-of select="$variableForVocabularyIdentifier"/> registry. 
      <!--
        NOTE: This is commented out because it requires lots of memory to be stored for 
        each failures.
        
        Allowed values are:
      <value-of select="string-join($variableForRegistry//value/@id, ', ')"/>-->.
    </diagnostic>
  </diagnostics>
  
  
  <!-- 
  HOW-TO: Use an abstract pattern when a test is similar but the context may vary.
  In that example, the pattern will check a codelist value based on a registry.
  Both the codelist value to check and the registry are parameters for the context.
  
  To make a pattern abstract, use the abstract and id attributes:
  ```
  <pattern abstract="true" id="codeListPattern">
  ```
  
  To call an abstract pattern, instantiate a pattern with an is-a attribute:
  ```
  <pattern is-a="codeListPattern">
  ```
  
  Pattern parameters does not need to be defined in the abstract pattern and
  can be set using;
  ```
  <pattern is-a="codeListPattern">
    <param name="vocabularyIdentifier" value="'http://dd.eionet.europa.eu/vocabulary/cdda/designationtypecategory/view'"/>
    <param name="registry" value="$designationTypeCategoryRegistry"/>
  ```
  
  Parameters are accessible like variables.
  
  To propagate parameters to diagnostics a variable needs to be defined. The variable 
  name could not start with the parameter name.
  ```
   <let name="variableForVocabularyIdentifier" value="$vocabularyIdentifier"/>
  ```
  
  -->
  
  <pattern abstract="true" id="codeListPattern">
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
    <rule context="ps:DesignationType[ps:designationScheme/@codeSpace = vocabularyIdentifier]">
      <let name="variableForVocabularyIdentifier" value="$vocabularyIdentifier"/>
      <let name="variableForRegistry" value="registry"/>
      <let name="designationTypeValue" value="ps:designation/text()"/>
      <let name="designationTypeCode" value="ps:designation/@codeSpace"/>
      <let name="isExistingInRegistry" value="count($registry/value[@id = $designationTypeCode]) &gt; 0"/>
      
      <assert test="$isExistingInRegistry" diagnostics="ir-ps-as-ps-A12-failure-en"/>
    </rule>
  </pattern>
  
  <pattern  is-a="codeListPattern">
    <title>Designation type category codelist check</title>
    <param name="vocabularyIdentifier" value="'http://dd.eionet.europa.eu/vocabulary/cdda/designationtypecategory/view'"/>
    <param name="registry" value="$designationTypeCategoryRegistry"/>
  </pattern>
  
  <pattern is-a="codeListPattern">
    <title>Designations codelist check</title>
    <param name="vocabularyIdentifier" value="'http://dd.eionet.europa.eu/vocabulary/cdda/designations/view'"/>
    <param name="registry" value="$designationsRegistry"/>
  </pattern>
  
  <!-- TODO : all codelists ? -->
  
  
  
  
  
  
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
  
  
  
  <!-- Phase could be used to define a set of tests. -->
  <phase id="A.1">
    <p>
      <span class="title">Application Schema Conformance Class</span>
      <span class="conformance">http://inspire.ec.europa.eu/conformance-class/ir/ps/as/ps</span>
    </p>
    <active pattern="A.1.1"/><!--
    <active pattern="A.1.2-a"/>
    <active pattern="A.1.2-b"/>-->
  </phase>
  
  
  
  <phase id="A.2">
    <p>
      <span class="title">Reference Systems Conformance Class</span>
      <span class="conformance">http://inspire.ec.europa.eu/conformance-class/ir/ps/rs</span>
    </p>
    <active pattern="A.2.1"/>
    <active pattern="A.2.4"/>
  </phase>
</schema>