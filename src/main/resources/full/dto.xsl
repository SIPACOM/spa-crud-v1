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
	<xsl:param name="packageLib">dev.yracnet.crud</xsl:param>
	<xsl:param name="project">tangram-seg</xsl:param>
	<xsl:param name="path">/opt/out/</xsl:param>
	<xsl:param name="app">tangram</xsl:param>
	<xsl:param name="mod">seg</xsl:param>
	<xsl:param name="include"/>
	<xsl:param name="exclude"/>
	<xsl:key name="_embeddable" match="/jpa:entity-mappings/jpa:embeddable" use="@id" />
 
	<xsl:template match="/">
		<x:files>
			<xsl:apply-templates/>
		</x:files>
	</xsl:template>
	<xsl:template match="jpa:mapped-superclass[j:process(@class, $include, $exclude)]">
		<xsl:call-template name="data"/>
		<xsl:call-template name="filter"/>
	</xsl:template>
	<xsl:template match="jpa:entity[j:process(@class, $include, $exclude)]">
		<xsl:call-template name="data"/>
		<xsl:call-template name="filter"/>
	</xsl:template>
	<xsl:template match="jpa:embeddable[j:process(@class, $include, $exclude)]">
		<xsl:call-template name="data"/>
	</xsl:template>
	
	<xsl:template match="text()"/>
	
	<xsl:template name="data">
		<xsl:variable name="name" select="j:className(@class)"/>
		<xsl:variable name="var" select="j:varName($name)"/>
		<xsl:variable name="superClassId" select="@superclassId"/>
		<xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>
		<x:file name="{$name}.java" dir="{j:packagePath($packageBase,'data')}" layer="serv">
			import java.util.Date;
			import java.io.Serializable;
			import javax.xml.bind.annotation.XmlAccessType;
			import javax.xml.bind.annotation.XmlAccessorType;
			import javax.xml.bind.annotation.XmlRootElement;
			import javax.xml.bind.annotation.XmlElement;
			import <xsl:value-of select="$packageLib"/>.lang.ValidationException;
			import <xsl:value-of select="$packageLib"/>.model.PoliceBase;
			@XmlRootElement
			@XmlAccessorType(XmlAccessType.NONE)
			public class <xsl:value-of select="j:classExtend($name, $superClass)"/>  implements Serializable {

			private static final long serialVersionUID = 1L;
			<xsl:for-each select="jpa:attributes/*[j:process(@name)]">
				<xsl:variable name="type" select="j:varType(@attribute-type, null, ./jpa:enumerated, name(.))"/>
				<xsl:variable name="attr" select="j:varName(@name)"/>		
				@XmlElement<xsl:if test="@attribute-type = 'java.util.Date' or @attribute-type = 'Date'">(type=Date.class)</xsl:if>
				private <xsl:value-of select="$type"/> 
				<xsl:value-of select="$attr"/>;
			</xsl:for-each>	
			<xsl:variable name="embedded" select="key('_embeddable', @connected-class-id)" />
			<xsl:for-each select="jpa:attributes/*[j:process(@name)]">
				<xsl:variable name="type" select="j:varType(@attribute-type, null, ./jpa:enumerated, name(.))"/>
				<xsl:variable name="attr" select="j:varName(@name)"/>		
				public <xsl:value-of select="$type"/> get<xsl:value-of select="j:accName(@name)"/>(){
				return <xsl:value-of select="$attr"/>;
				}
				public void set<xsl:value-of select="j:accName(@name)"/>(<xsl:value-of select="$type"/> value){
				<xsl:value-of select="$attr"/> = value;
				}
			</xsl:for-each>
			public void validateForSelected(ValidationException validate) {
			<xsl:for-each select="jpa:attributes/jpa:id">
				validate.isNullOrEmpty(<xsl:value-of select="j:varName(@name)"/>, "<xsl:value-of select="j:varName(@name)"/>");
			</xsl:for-each>
			//validate(validate);
			}	
			public void validateForCreated(ValidationException validate) {
			<xsl:for-each select="jpa:attributes/jpa:id">
				validate.isNotNull(<xsl:value-of select="j:varName(@name)"/>, "<xsl:value-of select="j:varName(@name)"/>");
			</xsl:for-each>
			validate(validate);
			}
			public void validateForUpdated(ValidationException validate) {
			<xsl:for-each select="jpa:attributes/jpa:id">
				validate.isNullOrEmpty(<xsl:value-of select="j:varName(@name)"/>, "<xsl:value-of select="j:varName(@name)"/>");
			</xsl:for-each>
			validate(validate);
			}
			public void validate(ValidationException validate) {
			<xsl:for-each select="jpa:attributes/*[j:process(@name)]">
				<xsl:variable name="type" select="j:varType(@attribute-type, null, ./jpa:enumerated)"/>
				<xsl:variable name="attr" select="j:varName(@name)"/>		
				<xsl:variable name="column" select="./jpa:column"/>
				
				<xsl:choose>
					<xsl:when test="name(.) = 'jpa:id'">
					</xsl:when>
					<xsl:when test="@attribute-type = 'String'">
						<xsl:if test="$column/@nullable='true'">//</xsl:if>validate.isNullOrNotTextOrLength(<xsl:value-of select="$attr"/>, <xsl:value-of select="j:eval($column/@min, 3)"/>, <xsl:value-of select="j:eval($column/@length, $column/@max, 50)"/>, "<xsl:value-of select="j:literal($attr)"/>");
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$column/@nullable='true'">//</xsl:if>validate.isNullOrEmpty(<xsl:value-of select="$attr"/>, "<xsl:value-of select="j:literal($attr)"/>");
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			}
			}
		</x:file>
		
	</xsl:template>
	<xsl:template name="filter">
		<xsl:variable name="name" select="j:className(@class)"/>
		<xsl:variable name="var" select="j:varName($name)"/>
		<xsl:variable name="superClassId" select="@superclassId"/>
		<xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>
		<x:file name="{$name}Ftr.java" dir="{j:packagePath($packageBase,'data')}" layer="serv">
			import java.util.Date;
			import java.io.Serializable;
			import <xsl:value-of select="$packageLib"/>.lang.ValidationException;
			import <xsl:value-of select="$packageLib"/>.model.FilterElement;
			import <xsl:value-of select="$packageLib"/>.model.FilterValue;
			import <xsl:value-of select="$packageLib"/>.model.FilterBase;
			import javax.xml.bind.annotation.XmlAccessType;
			import javax.xml.bind.annotation.XmlAccessorType;
			import javax.xml.bind.annotation.XmlRootElement;
			@XmlRootElement
			@XmlAccessorType(XmlAccessType.PROPERTY)
			public class <xsl:value-of select="$name"/>Ftr extends FilterBase implements Serializable {

			private static final long serialVersionUID = 1L;
			<xsl:for-each select="jpa:attributes/jpa:basic[j:process(@name)]">
				<xsl:variable name="type" select="j:varType(@attribute-type, 'FilterValue')"/>
				<xsl:variable name="attr" select="j:varName(@name)"/>		
				@FilterElement
				private <xsl:value-of select="$type"/> 
				<xsl:value-of select="$attr"/>;
			</xsl:for-each>
	
			<xsl:for-each select="jpa:attributes/jpa:basic[j:process(@name)]">
				<xsl:variable name="type" select="j:varType(@attribute-type, 'FilterValue')"/>
				<xsl:variable name="attr" select="j:varName(@name)"/>		
				public <xsl:value-of select="$type"/> get<xsl:value-of select="j:accName(@name)"/>(){
				return <xsl:value-of select="$attr"/>;
				}
				public void set<xsl:value-of select="j:accName(@name)"/>(<xsl:value-of select="$type"/> value){
				<xsl:value-of select="$attr"/> = value;
				}
			</xsl:for-each>
			public void validateForList(ValidationException validate) throws ValidationException {
			<xsl:for-each select="jpa:attributes/jpa:basic[j:process(@name)]">
				<xsl:variable name="attr" select="j:varName(@name)"/>		
				//validate.isNullOrEmpty(<xsl:value-of select="$attr"/>, "<xsl:value-of select="j:literal($attr)"/>");
			</xsl:for-each>
			}
			}
		</x:file>
	</xsl:template>
	
</xsl:stylesheet>
