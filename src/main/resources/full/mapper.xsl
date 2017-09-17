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
			<xsl:for-each select="jpa:entity-mappings/jpa:entity[j:process(@class, $include, $exclude)]|jpa:entity-mappings/jpa:mapped-superclass[j:process(@class, $include, $exclude)]">
				<xsl:variable name="name" select="j:className(@class)"/>
				<x:file name="{$name}Mapper.java" dir="{j:packagePath($packageBase)}/mapper" layer="impl">
					import java.util.List;
					import java.util.ArrayList;
					import <xsl:value-of select="$packageLib"/>.mapper.PoliceMapper;
					
					<xsl:call-template name="importClass">
						<xsl:with-param name="classFrom" select="@class"/>
					</xsl:call-template>
					<xsl:for-each select="jpa:attributes/jpa:embedded">
						<xsl:variable name="embedded" select="key('_embeddable', @connected-class-id)" />
						<xsl:call-template name="importClass">
							<xsl:with-param name="classFrom" select="$embedded/@class"/>
						</xsl:call-template>
					</xsl:for-each>
					public final class <xsl:value-of select="$name"/>Mapper extends PoliceMapper {
					
					
					//Basic Return
					public static <xsl:value-of select="@class"/> mapperTo<xsl:value-of select="$name"/>Entity(<xsl:value-of select="$name"/> from){
					<xsl:value-of select="@class"/> to = new <xsl:value-of select="@class"/>();
					mapperTo<xsl:value-of select="$name"/>Entity(from, to);
					return to;
					}
					public static <xsl:value-of select="$name"/> mapperTo<xsl:value-of select="$name"/>Model(<xsl:value-of select="@class"/> from){
					<xsl:value-of select="$name"/> to = new <xsl:value-of select="$name"/>();
					mapperTo<xsl:value-of select="$name"/>Model(from, to);
					return to;
					}
					
					//List Return
					public static List &lt;<xsl:value-of select="@class"/>&gt; mapperTo<xsl:value-of select="$name"/>EntityList(List &lt;<xsl:value-of select="$name"/>&gt; fromList){
					List &lt;<xsl:value-of select="@class"/>&gt; toList = new ArrayList();
					mapperTo<xsl:value-of select="$name"/>EntityList(fromList, toList);
					return toList;
					}
					public static List &lt;<xsl:value-of select="$name"/>&gt; mapperTo<xsl:value-of select="@name"/>ModelList(List &lt;<xsl:value-of select="@class"/>&gt; fromList){
					List &lt;<xsl:value-of select="$name"/>&gt; toList = new ArrayList();
					mapperTo<xsl:value-of select="$name"/>ModelList(fromList, toList);
					return toList;
					}
					
					//List
					public static void mapperTo<xsl:value-of select="$name"/>EntityList(List &lt;<xsl:value-of select="$name"/>&gt; fromList, List &lt;<xsl:value-of select="@class"/>&gt; toList){
					fromList.forEach(from -> {
					<xsl:value-of select="@class"/> to = mapperTo<xsl:value-of select="$name"/>Entity(from);
					toList.add(to);
					});
					}
					public static void mapperTo<xsl:value-of select="$name"/>ModelList(List &lt;<xsl:value-of select="@class"/>&gt; fromList, List &lt;<xsl:value-of select="$name"/>&gt; toList){
					fromList.forEach(from -> {
					<xsl:value-of select="$name"/> to = mapperTo<xsl:value-of select="$name"/>Model(from);
					toList.add(to);
					});
					}
					
					//Basic
					public static void mapperTo<xsl:value-of select="$name"/>Entity(<xsl:value-of select="$name"/> from, <xsl:value-of select="@class"/> to){
					<xsl:call-template name="mapperBasicAttribute">
						<xsl:with-param name="attributes" select="jpa:attributes"/>
						<xsl:with-param name="policeEntity" select="true()"/>
					</xsl:call-template>
					}
					public static void mapperTo<xsl:value-of select="$name"/>Model(<xsl:value-of select="@class"/> from, <xsl:value-of select="$name"/> to){
					<xsl:call-template name="mapperBasicAttribute">
						<xsl:with-param name="attributes" select="jpa:attributes"/>
						<xsl:with-param name="policeModel" select="true()"/>
					</xsl:call-template>
					}
					
					//Object
					public static void mapperTo<xsl:value-of select="$name"/>Subentity(<xsl:value-of select="$name"/> from, <xsl:value-of select="@class"/> to){
					<xsl:call-template name="mapperObjectAttribute">
						<xsl:with-param name="attributes" select="jpa:attributes"/>
					</xsl:call-template>
					}
					public static void mapperTo<xsl:value-of select="$name"/>Submodel(<xsl:value-of select="@class"/> from, <xsl:value-of select="$name"/> to){
					<xsl:call-template name="mapperObjectAttribute">
						<xsl:with-param name="attributes" select="jpa:attributes"/>
					</xsl:call-template>
					}
					<!--
					<xsl:for-each select="jpa:attributes/jpa:embedded">
						<xsl:variable name="embedded" select="key('_embeddable', @connected-class-id)" />
						<xsl:variable name="name" select="j:accName($embedded/@class)"/>
						public static void mapperTo<xsl:value-of select="$name"/>Entity(<xsl:value-of select="$name"/> from, <xsl:value-of select="$embedded/@class"/> to){
						<xsl:call-template name="mapperAttribute">
							<xsl:with-param name="attributes" select="$embedded/jpa:attributes"/>
							<xsl:with-param name="acc" select="false()"/>
						</xsl:call-template>
						}
						public static void mapperTo<xsl:value-of select="$name"/>Model(<xsl:value-of select="$embedded/@class"/> from, <xsl:value-of select="$name"/> to){
						<xsl:call-template name="mapperAttribute">
							<xsl:with-param name="attributes" select="$embedded/jpa:attributes"/>
							<xsl:with-param name="acc" select="true()"/>
						</xsl:call-template>
						}
					</xsl:for-each>
					<xsl:call-template name="methodMapperTo">
						<xsl:with-param name="classFrom" select="@class"/>
					</xsl:call-template>
					<xsl:for-each select="jpa:attributes/jpa:embedded">
						<xsl:variable name="embedded" select="key('_embeddable', @connected-class-id)" />
						<xsl:call-template name="methodMapperTo">
							<xsl:with-param name="classFrom" select="$embedded/@class"/>
						</xsl:call-template>
					</xsl:for-each>
					-->
					}
				</x:file>
			</xsl:for-each>
		</x:files>
	</xsl:template>
	
	<xsl:template name="mapperBasicAttribute">		
		<xsl:param name="attributes" select="jpa:attributes"/>
		<xsl:param name="policeEntity" select="false()"/>
		<xsl:param name="policeModel" select="false()"/>
		<xsl:for-each select="$attributes/jpa:id">
			<xsl:variable name="name" select="j:accName(@name)"/>
			to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
		</xsl:for-each>
		<xsl:for-each select="$attributes/jpa:basic">
			<xsl:variable name="name" select="j:accName(@name)"/>
			to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
		</xsl:for-each>
		<xsl:if test="$policeModel = true()">
			mapperToPoliceModel(from, to);
		</xsl:if>
		<xsl:if test="$policeEntity = true()">
			mapperToPoliceEntity(from, to);
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="mapperObjectAttribute">		
		<xsl:param name="attributes" select="jpa:attributes"/>
		<xsl:for-each select="$attributes/jpa:one-to-many">
			<xsl:variable name="name" select="j:accName(@name)"/>
			//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
		</xsl:for-each>
		<xsl:for-each select="$attributes/jpa:many-to-many">
			<xsl:variable name="name" select="j:accName(@name)"/>
			//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
		</xsl:for-each>
		<!--
		<xsl:for-each select="$attributes/jpa:embedded">
			<xsl:variable name="embedded" select="key('_embeddable', @connected-class-id)" />
			<xsl:variable name="name" select="j:accName(@name)"/>
			<xsl:if test="$acc = false()">
				<xsl:variable name="type" select="$embedded/@class"/>
				<xsl:value-of select="$type"/> _<xsl:value-of select="@name"/> = mapperTo<xsl:value-of select="$type"/>( from.get<xsl:value-of select="$name"/>() );
				to.set<xsl:value-of select="$name"/>( _<xsl:value-of select="@name"/> );
			</xsl:if>
			<xsl:if test="$acc = true()">
				<xsl:variable name="type" select="j:accName($embedded/@class)"/>
				<xsl:value-of select="$type"/> _<xsl:value-of select="@name"/> = mapperTo<xsl:value-of select="$type"/>( from.get<xsl:value-of select="$name"/>() );
				to.set<xsl:value-of select="$name"/>( _<xsl:value-of select="@name"/> );
			</xsl:if>
		</xsl:for-each>
		-->
	</xsl:template>
	
	
	
	
	<xsl:template name="importClass">		
		<xsl:param name="classFrom" select="@class"/>
		<xsl:variable name="classTo" select="j:accName($classFrom)"/>		
		import <xsl:value-of select="$packageBase"/>.entity.<xsl:value-of select="$classFrom"/>;
		import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$classTo"/>;
	</xsl:template>
	
	
	
	
	
	<xsl:template name="methodMapperTo">		
		<xsl:param name="classFrom" select="@class"/>
		<xsl:variable name="classTo" select="j:accName($classFrom)"/>		
		<xsl:variable name="listFrom" select="j:varType($classFrom, 'List')"/>
		<xsl:variable name="listTo" select="j:varType($classTo, 'List')"/>
		<xsl:call-template name="_methodMapperTo">
			<xsl:with-param name="classFrom" select="$classFrom"/>
			<xsl:with-param name="classTo" select="$classTo"/>
			<xsl:with-param name="listFrom" select="$listFrom"/>
			<xsl:with-param name="listTo" select="$listTo"/>
		</xsl:call-template>
		<xsl:call-template name="_methodMapperTo">
			<xsl:with-param name="classFrom" select="$classTo"/>
			<xsl:with-param name="classTo" select="$classFrom"/>
			<xsl:with-param name="listFrom" select="$listTo"/>
			<xsl:with-param name="listTo" select="$listFrom"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="_methodMapperTo">		
		<xsl:param name="classFrom"/>
		<xsl:param name="classTo"/>		
		<xsl:param name="listFrom"/>
		<xsl:param name="listTo"/>
		
		public static <xsl:value-of select="$listFrom"/> mapperTo<xsl:value-of select="$classFrom"/>List(<xsl:value-of select="$listTo"/> fromList){
		<xsl:value-of select="$listFrom"/> toList = new ArrayList();
		fromList.forEach(from -> {
		<xsl:value-of select="$classFrom"/> to = mapperTo<xsl:value-of select="$classFrom"/>(from);
		toList.add(to);
		});
		return toList;
		}
		public static <xsl:value-of select="$classTo"/> mapperTo<xsl:value-of select="$classTo"/>(<xsl:value-of select="$classFrom"/> from){
		if (from == null) {
		return null;
		}
		<xsl:value-of select="$classTo"/> to = new <xsl:value-of select="$classTo"/>();
		mapperTo<xsl:value-of select="$classTo"/>(from, to);
		return to;
		}
	</xsl:template>
	
	<xsl:template match="text()"/>
</xsl:stylesheet>
