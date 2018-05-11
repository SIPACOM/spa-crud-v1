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
		<xsl:variable name="id" select="@id"/>
		<xsl:variable name="superClassId" select="@superclassId"/>
		<xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>
		<xsl:variable name="entityChildren"  select="../jpa:entity[@superclassId = $id]"/>
		<xsl:if test="j:generate('SERV', current())">
			<x:file name="{$name}Serv.java" dir="{j:packagePath($packageBase)}" layer="serv">
				import java.util.List;
				import bo.union.lang.ServiceException;
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
				import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$name"/>Ftr;
				/**
				*Interface Used to interact with the [CODE]<xsl:value-of select="$name"/>[/CODE] object.
				*
				*[P]An instance of [CODE]<xsl:value-of select="$name"/>Serv[/CODE] (as an EJB service or another container) is associated with a persistence and independent transaction context. From this instance you can create / modify / delete or list persistent instances of the [CODE]<xsl:value-of select="$name"/>[/CODE] object in the service.[/P]
				*
				*[P]House one of the services responds to a functional and non-functional requirement of the user-history.[/P]
				*
				* @see QueryFilter
				* @see ServiceException
				* @see ValidateException
				* 
				* @since union-api
				*
				*/
				public interface <xsl:value-of select="$name"/>Serv {
				<xsl:variable name="type" select="j:varType($name, 'List')"/>
				/**
				* Search instances of the [CODE]<xsl:value-of select="$name"/>[/CODE] class.
				* 
				* [P]Search and return instances of the [CODE]<xsl:value-of select="$name"/>[/CODE] object filtered by the criteria declared in the [CODE]<xsl:value-of select="$name"/>Ftr[/CODE] parameter.[/P]
				*
				* @param filter Instance of [CODE]<xsl:value-of select="$name"/>Ftr[/CODE] that implements [CODE]FilterObject[/CODE] with values.
				* @return Collections of [CODE]<xsl:value-of select="$name"/>[/CODE] Objects.
				* @throws ServiceException When the method applies integrity and process controls.
				*/
				public <xsl:value-of select="$type"/> filter<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/>Ftr filter) throws ServiceException;
				/**
				* Insert the [CODE]<xsl:value-of select="$name"/>[/CODE] in the internal storage of the service.
				*
				* [P] Returns another instance of the [CODE]<xsl:value-of select="$name"/>[/CODE] object with complementary values. [/P]
				*
				* @param value Instance of [CODE]<xsl:value-of select="$name"/>[/CODE] with values.
				* @return other instance of [CODE]<xsl:value-of select="$name"/>[/CODE] with complementary values.
				* @throws ServiceException When the method applies integrity and process controls.
				*/
				public <xsl:value-of select="$name"/> create<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException;
				/**
				* Update the [CODE]<xsl:value-of select="$name"/>[/CODE] in the internal storage of the service.
				*
				* [P] Returns another instance of the [CODE]<xsl:value-of select="$name"/>[/CODE] object with complementary values. [/P]
				*
				* @param value Instance of [CODE]<xsl:value-of select="$name"/>[/CODE] with values.
				* @return other instance of [CODE]<xsl:value-of select="$name"/>[/CODE] with complementary values.
				* @throws ServiceException When the method applies integrity and process controls.
				*/
				public <xsl:value-of select="$name"/> update<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException;
				/**
				* Removes the [CODE]<xsl:value-of select="$name"/>[/CODE] in the internal storage of the service.
				*
				* [P] Returns another instance of the [CODE]<xsl:value-of select="$name"/>[/CODE] object with complementary values. [/P]
				*
				* @param value Instance of [CODE]<xsl:value-of select="$name"/>[/CODE] with values.
				* @return other instance of [CODE]<xsl:value-of select="$name"/>[/CODE] with complementary values.
				* @throws ServiceException When the method applies integrity and process controls.
				*/
				public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException;
				}
			</x:file>
		</xsl:if>
		<xsl:if test="j:generate('SERV-ABS', current())">
			<x:file name="{$name}Serv.java" dir="{j:packagePath($packageBase)}" layer="serv">
				import java.util.List;
				import bo.union.lang.ServiceException;
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
				import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$name"/>Ftr;
				<xsl:for-each select="$entityChildren">
					<xsl:variable name="nameChild" select="j:className(@class)"/>
					import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$nameChild"/>;
					import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$nameChild"/>Ftr;
				</xsl:for-each>
				public interface <xsl:value-of select="$name"/>Serv {
				<xsl:for-each select="$entityChildren">
					<xsl:variable name="nameChild" select="j:className(@class)"/>
					<xsl:variable name="typeChild" select="j:varType($nameChild, 'List')"/>
					public <xsl:value-of select="$typeChild"/> filter<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/>Ftr filter) throws ServiceException;
					public <xsl:value-of select="$nameChild"/> create<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/> value) throws ServiceException;
					public <xsl:value-of select="$nameChild"/> update<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/> value) throws ServiceException;
				</xsl:for-each>
				public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException;
				}
			</x:file>
		</xsl:if>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
