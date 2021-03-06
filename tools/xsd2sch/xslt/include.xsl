<?xml version="1.0"?>

<!-- INCLUDE  macro substitutions the xs:include, xs:redefine and xs:import elements -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

<xsl:template match="/">
	<schemas>	
		<xs:schema>
			<xsl:copy-of select="xs:schema/@* | xs:schema/namespace::node()" />
			<xsl:apply-templates select="xs:schema/*" />
		</xs:schema>
	</schemas>
</xsl:template>

<!-- When we find an import statement, just copy the whole schema in at that location.-->
<!-- If there are multiple imports, this is taken care of by the FLATTEN stage,
	however we do catch multiple imports in the same schema document, a minor case.
-->
<xsl:template match="xs:import[@schemaLocation]
	[not(preceding-sibling::xs:import/@schemaLocation=current()/@schemaLocation)]">
	<xsl:comment>Import Schema: <xsl:value-of select="@schemaLocation"/></xsl:comment>
	<xsl:variable name="documentSchema" select="document(@schemaLocation)"/>
	<xsl:choose>
	   
	   <!-- Reported PH
	      Recursive imports need to be coped with.
	      This is for immediate recursion.
	      
	      TODO: cope with indirect recursion. Probably need to pass a parameter containing
	      call stack of imports/includes.
	      TODO: Protect include the same way 
	   -->
	   <xsl:when test="$documentSchema//xs:import[@schemaLocation = current()/@schemaLocation]">
	      <xsl:comment >Recursive import  of <xsl:value-of select="current()/@schemaLocation"/></xsl:comment>
	   </xsl:when>
	   
	   <!-- Workaround. Cope with one level of indirect recursion: terminate to prevent recursion -->
	   <xsl:when test="$documentSchema//xs:import[@namespace = current()/../@targetNamspace]">
	      <xsl:message terminate="yes">Recursive import  of <xsl:value-of select="current()/../@targetNamespace"/></xsl:message>
	   </xsl:when>
	   
	   <xsl:otherwise>
			<!-- put schemaLocation as an attribute for imported schema is for flatten using -->
			<xs:schema  schemaLocation="{@schemaLocation}">
				<xsl:copy-of select="$documentSchema/xs:schema/@* | $documentSchema/xs:schema/namespace::node()"/>
				<xsl:apply-templates select="$documentSchema/xs:schema/*" />
			</xs:schema>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- When we find an include statement, copy the contents of that schema in at the current
	location. -->	
<!-- There can be multiple includes in each schema. However, if there are multiple includes
	in the same schema this is useless. However we do catch multiple imports in the same 
	schema document, a minor case.
-->	
<!-- Note: An included namespace must have the same target namespace as the parent.
	If the included schema has no namespace, it takes on the namespace of the parent -->	
<xsl:template match="xs:include[@schemaLocation]
	 [not(preceding-sibling::xs:include/@schemaLocation=current()/@schemaLocation)]
	 [not(preceding-sibling::xs:redefine/@schemaLocation=current()/@schemaLocation)]">
	<xsl:comment>Include Schema: <xsl:value-of select="@schemaLocation"/></xsl:comment>
	<xsl:variable name="documentSchema" select="document(@schemaLocation)"/>
	<xsl:apply-templates select="$documentSchema/xs:schema/*"/>
</xsl:template>


<!-- When we find an redefine statement, copy the contents of the redefine element into the current
location, then the contents of the schema, ignoring any elements with the same name() and @name -->
<!-- TODO: There is a problem here. If we are redefining an declaration of the immediately defined
  schema it is OK. But it that schema in turn has imports which are overridden, id doesn't work.
  The simplest way to fix this is for the subsequent flatten stage to remove declarations of the 
  same type and name as an uncle or great-uncle.
  -->	 
<xsl:template match="xs:redefine[@schemaLocation]
	 [not(preceding-sibling::xs:include/@schemaLocation=current()/@schemaLocation)]
	 [not(preceding-sibling::xs:redefine/@schemaLocation=current()/@schemaLocation)]">
	<xsl:comment>Redefine Schema: <xsl:value-of select="@schemaLocation"/></xsl:comment>
	<xsl:variable name="documentSchema" select="document(@schemaLocation)"/>
	<xsl:apply-templates />
	<xsl:for-each select="$documentSchema/xs:schema/*">
	    <xsl:variable name="componentName" select="name()"/>
	    <xsl:variable name="componentId" select="@name" />
	    <xsl:if test=" not( current()/*[name()=$componentName][@name=$componentId]) " >
	       <xsl:apply-templates select="." />
	    </xsl:if>
	</xsl:for-each> 
</xsl:template>
				

				
<xsl:template match="*[not(self::xs:import or self::xs:include or self::xs:schema)]">
	<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>


