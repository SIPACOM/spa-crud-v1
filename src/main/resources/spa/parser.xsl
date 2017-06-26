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
			<!--
			<xsl:variable name="name" select="j:upper($mod)"/>
			<xsl:variable name="class" select="j:sufix($name,'Mapper')"/>
			<x:file name="{$class}.java" dir="{j:packagePath($packageBase)}" layer="impl">
				import java.util.Map;
				import java.util.HashMap;
				public class <xsl:value-of select="$class"/> {
				public static final <xsl:value-of select="$class"/> INSTANCE = new <xsl:value-of select="$class"/>();
				
				private <xsl:value-of select="$class"/>(){
				}
				
				public <xsl:value-of select="$class"/> getInstance(){
				return INSTANCE;
				}
				
				//public &lt;ENT, DTO&gt; Mapper&lt;ENT, DTO&gt; mapper(Class&lt;ENT&gt; entClass, Class&lt;DTO&gt; dtoClass){					
				//}
				
				}
			</x:file>
			-->
			<xsl:for-each select="jpa:entity-mappings/jpa:entity[j:process(@class, $include, $exclude)]">
				<x:file name="{@class}Parser.java" dir="{j:packagePath($packageBase)}/parser" layer="impl">
					<xsl:variable name="name" select="j:className(@class)"/>
					import java.util.List;
					import java.util.ArrayList;
					import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
					import <xsl:value-of select="$packageBase"/>.entity.<xsl:value-of select="@class"/>;
					public final class <xsl:value-of select="@class"/>Parser {
					
					public static void parseFromTo(<xsl:value-of select="$name"/> from, <xsl:value-of select="@class"/> to){
					to.setId<xsl:value-of select="$name"/>(from.getId<xsl:value-of select="$name"/>());
					<xsl:for-each select="jpa:attributes/*">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					}
					public static void parseFromTo(<xsl:value-of select="@class"/> from, <xsl:value-of select="$name"/> to){
					to.setId<xsl:value-of select="$name"/>(from.getId<xsl:value-of select="$name"/>());
					<xsl:for-each select="jpa:attributes/*">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					}
					<xsl:variable name="name" select="j:className(@class)"/>
					public static <xsl:value-of select="$name"/> parseTo<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> from){
					<xsl:value-of select="$name"/> to = new <xsl:value-of select="$name"/>();
					parseFromTo(from, to);
					return to;
					}
					public static <xsl:value-of select="@class"/> parseTo<xsl:value-of select="@class"/>(<xsl:value-of select="$name"/> from){
					<xsl:value-of select="@class"/> to = new <xsl:value-of select="@class"/>();
					parseFromTo(from, to);
					return to;
					}
					<xsl:variable name="typeA" select="j:varType(@class, 'List')"/>
					<xsl:variable name="typeB" select="j:varType($name, 'List')"/>
					public static <xsl:value-of select="$typeA"/> to<xsl:value-of select="@class"/>List(<xsl:value-of select="$typeB"/> fromList){
					<xsl:value-of select="$typeA"/> toList = new ArrayList();
					fromList.stream().forEach(from -> {
					<xsl:value-of select="@class"/> to = parseTo<xsl:value-of select="@class"/>(from);
					toList.add(to);
					});
					return toList;
					}
					public static <xsl:value-of select="$typeB"/> to<xsl:value-of select="$name"/>List(<xsl:value-of select="$typeA"/> fromList){
					<xsl:value-of select="$typeB"/> toList = new ArrayList();
					fromList.stream().forEach(from -> {
					<xsl:value-of select="$name"/> to = parseTo<xsl:value-of select="$name"/>(from);
					toList.add(to);
					});
					return toList;
					}
					}
				</x:file>
				<x:file name="{@class}Mapper.java" dir="{j:packagePath($packageBase)}/mapper" layer="impl" ignore="true">
					<xsl:variable name="name" select="j:className(@class)"/>
					import java.util.List;
					import java.util.ArrayList;
					import bo.union.persist.EntityMapper;
					import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
					import <xsl:value-of select="$packageBase"/>.entity.<xsl:value-of select="@class"/>;
					public class <xsl:value-of select="@class"/>Mapper  extends EntityMapper&lt;<xsl:value-of select="@class"/>&gt; {
					
					@Override
					public &lt;T&gt; void fillObject(T from, <xsl:value-of select="@class"/> to) {
					if (from instanceof <xsl:value-of select="$name"/>) {
					parseFromTo((<xsl:value-of select="$name"/>) from, to);
					} else {
					throw new UnsupportedOperationException("Clase no soportada: " + to);
					}
					}
					
					@Override
					public &lt;T&gt; void fillEntity(<xsl:value-of select="@class"/> from, T to) {
					if (to instanceof <xsl:value-of select="$name"/>) {
					parseFromTo(from, (<xsl:value-of select="$name"/>) to);
					} else {
					throw new UnsupportedOperationException("Clase no soportada: " + to);
					}
					}
					public static void parseFromTo(<xsl:value-of select="$name"/> from, <xsl:value-of select="@class"/> to){
					to.setId<xsl:value-of select="$name"/>(from.getId<xsl:value-of select="$name"/>());
					<xsl:for-each select="jpa:attributes/*">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					}
					public static void parseFromTo(<xsl:value-of select="@class"/> from, <xsl:value-of select="$name"/> to){
					to.setId<xsl:value-of select="$name"/>(from.getId<xsl:value-of select="$name"/>());
					<xsl:for-each select="jpa:attributes/*">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					}
					<xsl:variable name="name" select="j:className(@class)"/>
					public static <xsl:value-of select="$name"/> to<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> from){
					<xsl:value-of select="$name"/> to = new <xsl:value-of select="$name"/>();
					parseFromTo(from, to);
					return to;
					}
					public static <xsl:value-of select="@class"/> to<xsl:value-of select="@class"/>(<xsl:value-of select="$name"/> from){
					<xsl:value-of select="@class"/> to = new <xsl:value-of select="@class"/>();
					parseFromTo(from, to);
					return to;
					}
					<xsl:variable name="typeA" select="j:varType(@class, 'List')"/>
					<xsl:variable name="typeB" select="j:varType($name, 'List')"/>
					public static <xsl:value-of select="$typeA"/> to<xsl:value-of select="@class"/>List(<xsl:value-of select="$typeB"/> fromList){
					<xsl:value-of select="$typeA"/> toList = new ArrayList();
					fromList.stream().forEach(from -> {
					<xsl:value-of select="@class"/> to = to<xsl:value-of select="@class"/>(from);
					toList.add(to);
					});
					return toList;
					}
					public static <xsl:value-of select="$typeB"/> to<xsl:value-of select="$name"/>List(<xsl:value-of select="$typeA"/> fromList){
					<xsl:value-of select="$typeB"/> toList = new ArrayList();
					fromList.stream().forEach(from -> {
					<xsl:value-of select="$name"/> to = to<xsl:value-of select="$name"/>(from);
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
