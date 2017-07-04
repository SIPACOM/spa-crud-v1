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
			<xsl:for-each select="jpa:entity-mappings/jpa:entity[j:process(@class, $include, $exclude)]|jpa:entity-mappings/jpa:mapped-superclass[j:process(@class, $include, $exclude)]">
				<xsl:variable name="name" select="j:className(@class)"/>
				<x:file name="{$name}Mapper.java" dir="{j:packagePath($packageBase)}/mapper" layer="impl">
					import java.util.List;
					import java.util.ArrayList;
					import bo.union.persist.police.PoliceMapper;
					import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
					import <xsl:value-of select="$packageBase"/>.entity.<xsl:value-of select="@class"/>;
					public final class <xsl:value-of select="$name"/>Mapper extends PoliceMapper {
					
					public static void mapperTo<xsl:value-of select="@class"/>(<xsl:value-of select="$name"/> from, <xsl:value-of select="@class"/> to){
					<xsl:for-each select="jpa:attributes/jpa:id">
						<xsl:variable name="name" select="j:accName(@name)"/>
						to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					<xsl:for-each select="jpa:attributes/jpa:basic">
						<xsl:variable name="name" select="j:accName(@name)"/>
						to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					<xsl:for-each select="jpa:attributes/jpa:one-to-many">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					<xsl:for-each select="jpa:attributes/jpa:many-to-many">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					//mapperToAuditPartial(from, to);
					mapperToAuditFull(from, to);
					}
					public static void mapperTo<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> from, <xsl:value-of select="$name"/> to){
					<xsl:for-each select="jpa:attributes/jpa:id">
						<xsl:variable name="name" select="j:accName(@name)"/>
						to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					<xsl:for-each select="jpa:attributes/jpa:basic">
						<xsl:variable name="name" select="j:accName(@name)"/>
						to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					<xsl:for-each select="jpa:attributes/jpa:one-to-many">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					<xsl:for-each select="jpa:attributes/jpa:many-to-many">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					mapperToPoliceBase(from, to);
					}
					<xsl:variable name="name" select="j:className(@class)"/>
					public static <xsl:value-of select="$name"/> mapperTo<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> from){
					<xsl:value-of select="$name"/> to = new <xsl:value-of select="$name"/>();
					mapperTo<xsl:value-of select="$name"/>(from, to);
					return to;
					}
					public static <xsl:value-of select="@class"/> mapperTo<xsl:value-of select="@class"/>(<xsl:value-of select="$name"/> from){
					<xsl:value-of select="@class"/> to = new <xsl:value-of select="@class"/>();
					mapperTo<xsl:value-of select="@class"/>(from, to);
					return to;
					}
					<xsl:variable name="typeA" select="j:varType(@class, 'List')"/>
					<xsl:variable name="typeB" select="j:varType($name, 'List')"/>
					public static <xsl:value-of select="$typeA"/> mapperTo<xsl:value-of select="@class"/>List(<xsl:value-of select="$typeB"/> fromList){
					<xsl:value-of select="$typeA"/> toList = new ArrayList();
					fromList.stream().forEach(from -> {
					<xsl:value-of select="@class"/> to = mapperTo<xsl:value-of select="@class"/>(from);
					toList.add(to);
					});
					return toList;
					}
					public static <xsl:value-of select="$typeB"/> mapperTo<xsl:value-of select="$name"/>List(<xsl:value-of select="$typeA"/> fromList){
					<xsl:value-of select="$typeB"/> toList = new ArrayList();
					fromList.stream().forEach(from -> {
					<xsl:value-of select="$name"/> to = mapperTo<xsl:value-of select="$name"/>(from);
					toList.add(to);
					});
					return toList;
					}
					}
				</x:file>
			</xsl:for-each>
		</x:files>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
