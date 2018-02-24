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
			<x:file name="module.xml" dir="union" layer="web-inf">		
				<module version="1.0.0">
					<name>
						<xsl:value-of select="j:upper($app)"/>::<xsl:value-of select="j:upper($mod)"/>
					</name>
					<xsl:for-each select="jpa:entity-mappings/jpa:entity">
						<xsl:variable name="name" select="j:className(@class)"/>		
						<xsl:variable name="var" select="j:varName($name)"/>
						<view>
							<id><xsl:value-of select="$var"/></id>
							<page>/view/<xsl:value-of select="$var"/>.html</page>
							<java><xsl:value-of select="$packageBase"/>.<xsl:value-of select="$name"/>Rest.java</java>
							<ctrl>/ctrl/<xsl:value-of select="$var"/>.js</ctrl>
						</view>
					</xsl:for-each>
					<menu type="GROUP" id="0">
						<label><xsl:value-of select="j:upper($mod)"/>::<xsl:value-of select="j:upper($mod)"/></label>
						<xsl:for-each select="jpa:entity-mappings/jpa:entity[j:process(@class, $include, $exclude)]">
							<xsl:variable name="i" select="position()"/>
							<xsl:variable name="name" select="j:className(@class)"/>		
							<xsl:variable name="var" select="j:varName($name)"/>
							<menu type="LINK" mode="TAB" id="{$i}">
								<label><xsl:value-of select="$name"/></label>
								<viewId><xsl:value-of select="$var"/></viewId>
							</menu>
						</xsl:for-each>
					</menu>
				</module>
			</x:file>
			<xsl:apply-templates/>
		</x:files>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
