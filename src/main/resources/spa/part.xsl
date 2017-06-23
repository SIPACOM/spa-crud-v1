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
		<x:file name="new.html" dir="{$var}" layer="part">
			<div>
				<xsl:attribute name="uni-grid">{cols:[2,4]}</xsl:attribute>
				<xsl:for-each select="jpa:attributes">
					<xsl:apply-templates mode="form"/>
				</xsl:for-each>	
			</div>
		</x:file>
		<x:file name="edit.html" dir="{$var}" layer="part">
			<div>
				<xsl:attribute name="uni-grid">{cols:[2,4]}</xsl:attribute>
				<xsl:for-each select="jpa:attributes">
					<xsl:apply-templates mode="form"/>
				</xsl:for-each>	
			</div>
		</x:file>
		<x:file name="info.html" dir="{$var}" layer="part">
			<div>
				<xsl:attribute name="uni-grid">{cols:[2,4]}</xsl:attribute>
				<xsl:for-each select="jpa:attributes">
					<xsl:apply-templates mode="form"/>
				</xsl:for-each>	
			</div>
		</x:file>
		<x:file name="filter.html" dir="{$var}" layer="part">		
			<div>
				<xsl:attribute name="uni-grid">{type:'table'}</xsl:attribute>
				<xsl:for-each select="jpa:attributes">
					<xsl:apply-templates mode="filter"/>
				</xsl:for-each>	
			</div>
		</x:file>
		<x:file name="table.html" dir="{$var}" layer="part">
			<table uni-table="">
				<tr>
					<xsl:for-each select="jpa:attributes/*">
						<th i18n="{@name}">
							<xsl:value-of select="j:literal(@name)"/>
						</th>
					</xsl:for-each>
				</tr>
				<tr ng-repeat="row in _list" ng-click="_select(row)">
					<xsl:for-each select="jpa:attributes/*">
						<td>{{row.<xsl:value-of select="@name"/>}}</td>
					</xsl:for-each>
				</tr>
			</table>
		</x:file>
	</xsl:template>
	
	<xsl:template mode="view" match="jpa:id|jpa:basic|jpa:one-to-many|jpa:many-to-many">
		<label i18n="{@name}"><xsl:value-of select="j:literal(@name)"/></label><input uni-input="" ng-value="_filter.{@name}" readonly="true"/>
	</xsl:template>	
	<xsl:template mode="form" match="jpa:id|jpa:basic|jpa:one-to-many|jpa:many-to-many">
		<label i18n="{@name}"><xsl:value-of select="j:literal(@name)"/></label><input uni-input="" ng-model="_value.{@name}"/>
	</xsl:template>
	<xsl:template mode="filter" match="jpa:id|jpa:basic|jpa:one-to-many|jpa:many-to-many">
		<label i18n="{@name}"><xsl:value-of select="j:literal(@name)"/></label><input uni-filter="" ng-model="_filter.{@name}"/>
	</xsl:template>	
	<xsl:template match="text()"/>
</xsl:stylesheet>
