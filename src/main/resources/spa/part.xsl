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
				<xsl:for-each select="jpa:attributes/jpa:id">
					<xsl:call-template name="filter"/>
				</xsl:for-each>
				<xsl:for-each select="jpa:attributes/jpa:basic">
					<xsl:call-template name="filter"/>
				</xsl:for-each>
			</div>
		</x:file>
		<x:file name="table.html" dir="{$var}" layer="part">
			<table>
				<xsl:attribute name="uni-table">{select: '_select', selected: '_selected'}</xsl:attribute>
				<tr>
					<xsl:for-each select="jpa:attributes/jpa:id">
						<th i18n="{@name}" width="5%">
							<xsl:value-of select="j:literal(@name)"/>
						</th>
					</xsl:for-each>
					<xsl:for-each select="jpa:attributes/jpa:basic">
						<th i18n="{@name}">
							<xsl:value-of select="j:literal(@name)"/>
						</th>
					</xsl:for-each>
				</tr>
				<tr ng-repeat="row in _list">
					<xsl:for-each select="jpa:attributes/jpa:id">
						<td>{{row.<xsl:value-of select="@name"/>}}</td>
					</xsl:for-each>
					<xsl:for-each select="jpa:attributes/jpa:basic">
						<td>{{row.<xsl:value-of select="@name"/>}}</td>
					</xsl:for-each>
				</tr>
			</table>
		</x:file>
	</xsl:template>
	
	<xsl:template name="form" mode="form" match="jpa:basic|jpa:one-to-many|jpa:many-to-many">
		<xsl:choose>
			<xsl:when test="name(.) = 'jpa:basic'">
				<xsl:choose>
					<xsl:when test="jpa:column/@length > 99">
						<br/>
						<xsl:call-template name="label"/>
						<textarea col="10" ng-model="_value.{@name}" maxlength="{jpa:column/@length}">
							<xsl:if test="jpa:column/@nullable='false'">
								<xsl:attribute name="required">true</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="' '"/>
						</textarea>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="label"/>
						<input ng-model="_value.{@name}" maxlength="{jpa:column/@length}">
							<xsl:if test="jpa:column/@nullable='false'">
								<xsl:attribute name="required">true</xsl:attribute>
							</xsl:if>
							<xsl:if test="@attribute-type = 'java.util.Date'">
								<xsl:attribute name="type">date</xsl:attribute>
							</xsl:if>
							<xsl:if test="@attribute-type = 'long'">
								<xsl:attribute name="type">number</xsl:attribute>
							</xsl:if>
						</input>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			<xsl:otherwise>
				_COMMENT_START_
				FIELD: <xsl:value-of select="name(.)"/>
				_COMMENT_END_
				_COMMENT_START_
				<xsl:call-template name="label"/>
				<input ng-model="_value.{@name}">
					<xsl:if test="jpa:column/@nullable='false'">
						<xsl:attribute name="required">true</xsl:attribute>
					</xsl:if>
				</input>
				_COMMENT_END_
			</xsl:otherwise>
		</xsl:choose> 
	</xsl:template>
	
	<xsl:template name="view" mode="view" match="jpa:basic|jpa:one-to-many|jpa:many-to-many">
		<xsl:choose>
			<xsl:when test="name(.) = 'jpa:basic' and jpa:column/@length > 99">
				<xsl:call-template name="label"/>
				<textarea ng-value="_filter.{@name}" readonly="true"></textarea>
			</xsl:when>
			<xsl:when test="name(.) = 'jpa:basic'">
				<xsl:call-template name="label"/>
				<input ng-value="_filter.{@name}" readonly="true"/>
			</xsl:when>
			<xsl:otherwise>
				_COMMENT_START_
				FIELD: <xsl:value-of select="name(.)"/>
				_COMMENT_END_
				_COMMENT_START_
				<xsl:call-template name="label"/>
				<input ng-value="_filter.{@name}" readonly="true"/>
				_COMMENT_END_
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="filter" mode="filter" match="jpa:id|jpa:basic|jpa:one-to-many|jpa:many-to-many">
		<xsl:choose>
			<xsl:when test="name(.) = 'jpa:basic' or name(.) = 'jpa:id'">
				<xsl:call-template name="label"/>
				<input uni-filter="" ng-model="_filter.{@name}"/>
			</xsl:when>
			<xsl:otherwise>
				_COMMENT_START_
				FIELD: <xsl:value-of select="name(.)"/>
				_COMMENT_END_
				_COMMENT_START_
				<xsl:call-template name="label"/>
				<input uni-filter="" ng-model="_filter.{@name}"/>
				_COMMENT_END_
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="label">
		<label i18n="{@name}">
			<xsl:value-of select="j:literal(@name)"/>
		</label>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
