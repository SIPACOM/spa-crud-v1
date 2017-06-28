<xsl:stylesheet version="2.0" 
																xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
																xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
																xmlns:java="http://jcp.org/en/jsr/detail?id=270" 
																xmlns:xs="http://www.w3.org/2001/XMLSchema" 
																xmlns:jpa="http://java.sun.com/xml/ns/persistence/orm"
																xmlns:x="http://github.com/yracnet/xml/crud"
																xmlns="http://www.w3.org/1999/xhtml"
																xmlns:j="dev.yracnet.crud.spi.CrudUtil">
	<xsl:param name="packageBase">dev.yracnet.crud</xsl:param>
	<xsl:param name="project">tangram-seg</xsl:param>
	<xsl:param name="path">/opt/out/</xsl:param>
	<xsl:param name="app">tangram</xsl:param>
	<xsl:param name="mod">seg</xsl:param>
	<xsl:param name="include"/>
	<xsl:param name="exclude"/>
 
	<xsl:template match="/">
		<x:files>
			<xsl:apply-templates/>
		</x:files>
	</xsl:template>
	<xsl:template match="jpa:entity[j:process(@class, $include, $exclude)]">
		
		<xsl:variable name="name" select="j:className(@class)"/>
		<xsl:variable name="var" select="j:varName($name)"/>
		<xsl:variable name="superClassId" select="@superclassId"/>
		<xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>
		<x:file name="{$name}Serv.java" dir="{j:packagePath($packageBase)}" layer="serv">
			import java.util.List;
			import bo.union.lang.ServiceException;
			import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
			//import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>Ftr;
			import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$name"/>Ftr;
			public interface <xsl:value-of select="$name"/>Serv {
			<xsl:variable name="type" select="j:varType($name, 'List')"/>
			public <xsl:value-of select="$type"/> filter<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/>Ftr filter) throws ServiceException;
			public <xsl:value-of select="$name"/> create<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException;
			public <xsl:value-of select="$name"/> update<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException;
			public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException;
			}
		</x:file>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
