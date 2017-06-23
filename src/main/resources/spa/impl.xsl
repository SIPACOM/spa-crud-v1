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
			<x:file name="Mapper.java" dir="{j:packagePath($packageBase)}" layer="impl">
				import java.util.List;
				import java.util.ArrayList;
				import <xsl:value-of select="$packageBase"/>.data.*;
				import <xsl:value-of select="$packageBase"/>.entity.*;
				public final class Mapper {
				<xsl:for-each select="jpa:entity-mappings/jpa:entity|jpa:entity-mappings/jpa:mapped-superclass">
					<xsl:variable name="name" select="j:className(@class)"/>
					public static void pass<xsl:value-of select="@class"/>(<xsl:value-of select="$name"/> from, <xsl:value-of select="@class"/> to){
					<xsl:for-each select="jpa:attributes/*">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					}
					public static void pass<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> from, <xsl:value-of select="$name"/> to){
					<xsl:for-each select="jpa:attributes/*">
						<xsl:variable name="name" select="j:accName(@name)"/>
						//to.set<xsl:value-of select="$name"/>(from.get<xsl:value-of select="$name"/>());
					</xsl:for-each>
					}
				</xsl:for-each>
				<xsl:for-each select="jpa:entity-mappings/jpa:entity">
					<xsl:variable name="name" select="j:className(@class)"/>
					public static <xsl:value-of select="$name"/> to<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> from){
					<xsl:value-of select="$name"/> to = new <xsl:value-of select="$name"/>();
					pass<xsl:value-of select="$name"/>(from, to);
					return to;
					}
					public static <xsl:value-of select="@class"/> to<xsl:value-of select="@class"/>(<xsl:value-of select="$name"/> from){
					<xsl:value-of select="@class"/> to = new <xsl:value-of select="@class"/>();
					pass<xsl:value-of select="@class"/>(from, to);
					return to;
					}
					<xsl:variable name="typeA" select="j:varType(@class, 'List')"/>
					<xsl:variable name="typeB" select="j:varType($name, 'List')"/>
					public static <xsl:value-of select="$typeA"/> to<xsl:value-of select="@class"/>List(<xsl:value-of select="$typeB"/> fromList){
					<xsl:value-of select="$typeA"/> toList = new ArrayList();
					fromList.forEach(from -> {
					<xsl:value-of select="@class"/> to = to<xsl:value-of select="@class"/>(from);
					toList.add(to);
					});
					return toList;
					}
					public static <xsl:value-of select="$typeB"/> to<xsl:value-of select="$name"/>List(<xsl:value-of select="$typeA"/> fromList){
					<xsl:value-of select="$typeB"/> toList = new ArrayList();
					fromList.forEach(from -> {
					<xsl:value-of select="$name"/> to = to<xsl:value-of select="$name"/>(from);
					toList.add(to);
					});
					return toList;
					}
				</xsl:for-each>
				}
			</x:file>
			<xsl:apply-templates/>
		</x:files>
	</xsl:template>
	<xsl:template match="jpa:entity[j:process(@class, $include, $exclude)]">
		<xsl:variable name="name" select="j:className(@class)"/>
		<xsl:variable name="var" select="j:varName($name)"/>
		<xsl:variable name="superClassId" select="@superclassId"/>
		<xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>
		
		
		<x:file name="{$name}Impl.java" dir="{j:packagePath($packageBase)}" layer="impl">
			import java.util.List;
			import java.util.ArrayList;
			import javax.ejb.Local;
			import javax.ejb.Stateless;
			import javax.ejb.TransactionManagement;
			import javax.ejb.TransactionManagementType;
			import javax.persistence.EntityManager;
			import javax.persistence.PersistenceContext;
			import bo.union.persist.qfilter.QFilter;
			import bo.union.lang.ServiceException;
			import bo.union.lang.ValidationException;
			import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
			import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$name"/>Ftr;
			import <xsl:value-of select="$packageBase"/>.entity.<xsl:value-of select="@class"/>;
			@Stateless
			@Local(<xsl:value-of select="$name"/>Serv.class)
			@TransactionManagement(TransactionManagementType.CONTAINER)
			public class <xsl:value-of select="$name"/>Impl implements  <xsl:value-of select="$name"/>Serv{
			@PersistenceContext(unitName = "store-<xsl:value-of select="$mod"/>")
			private EntityManager em;
			<xsl:variable name="type" select="j:varType($name, 'List')"/>
			@Override
			public <xsl:value-of select="$type"/> filter<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/>Ftr filter) throws ServiceException{
			List<xsl:value-of select="j:template(@class)"/> fromList = QFilter.filter(em, <xsl:value-of select="@class"/>.class, filter);
			<xsl:value-of select="$type"/> toList = new ArrayList();
			fromList.stream().forEach(from -> {
			<xsl:value-of select="$name"/> to = Mapper.to<xsl:value-of select="$name"/>(from);
			toList.add(to);
			});
			return toList;
			}
			@Override
			public <xsl:value-of select="$name"/> create<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
			ValidationException validate = new ValidationException("Registro <xsl:value-of select="j:literal($name)"/>");
			validate.isNull(value, "<xsl:value-of select="j:literal($name)"/>");
			validate.throwException();
			value.validateNew(validate);
			validate.throwException();
			<xsl:value-of select="@class"/> entity = Mapper.to<xsl:value-of select="@class"/>(value);
			em.persist(entity);
			Mapper.pass<xsl:value-of select="$name"/>(entity, value);
			return value;
			}
			@Override
			public <xsl:value-of select="$name"/> update<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
			ValidationException validate = new ValidationException("Actualizar <xsl:value-of select="j:literal($name)"/>");
			validate.isNull(value, "<xsl:value-of select="j:literal($name)"/>");
			validate.throwException();
			value.validateEdit(validate);
			validate.throwException();
			<xsl:value-of select="@class"/> entity = Mapper.to<xsl:value-of select="@class"/>(value);
			em.persist(entity);
			Mapper.pass<xsl:value-of select="$name"/>(entity, value);
			return value;
			}
			@Override
			public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
			ValidationException validate = new ValidationException("Eliminar <xsl:value-of select="j:literal($name)"/>");
			validate.isNull(value, "<xsl:value-of select="j:literal($name)"/>");
			validate.throwException();
			validate.isNullOrEmpty(value.getId<xsl:value-of select="$name"/>(), "Id");
			validate.throwException();
			<xsl:value-of select="@class"/> entity = em.find(<xsl:value-of select="@class"/>.class, value.getId<xsl:value-of select="$name"/>());
			em.remove(entity);
			Mapper.pass<xsl:value-of select="$name"/>(entity, value);
			return value;
			}
			}
		</x:file>
	</xsl:template>
	
	<xsl:template match="text()"/>
</xsl:stylesheet>
