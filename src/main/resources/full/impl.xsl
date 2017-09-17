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
		<xsl:variable name="entityChildren"  select="../jpa:entity[@superclassId = $id]"/>
		<xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>		
		<xsl:if test="j:generate('LOCAL', current() )">
			<x:file name="{$name}Local.java" dir="{j:packagePath($packageBase)}/internal" layer="impl">
				import java.util.List;
				import java.util.ArrayList;
				import javax.ejb.LocalBean;
				import javax.ejb.Stateless;
				import javax.persistence.EntityManager;
				import javax.persistence.PersistenceContext;
				import <xsl:value-of select="$packageLib"/>.persist.FilterProcess;
				import <xsl:value-of select="$packageLib"/>.lang.ServiceException;
				import <xsl:value-of select="$packageLib"/>.lang.ValidationException;
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>Ftr;
				import <xsl:value-of select="$packageBase"/>.entity.<xsl:value-of select="@class"/>;
				import static <xsl:value-of select="$packageBase"/>.mapper.<xsl:value-of select="$name"/>Mapper.*;
				@Stateless
				@LocalBean
				public class <xsl:value-of select="$name"/>Local {
				@PersistenceContext(unitName = "store-<xsl:value-of select="$mod"/>")
				private EntityManager em;
				<xsl:variable name="type" select="j:varType($name, 'List')"/>
				public <xsl:value-of select="$type"/> filter<xsl:value-of select="$name"/>(final <xsl:value-of select="$name"/>Ftr filter, final ValidationException validate) throws ServiceException{
				filter.validateForList(validate);
				validate.throwException();
				List<xsl:value-of select="j:template(@class)"/> fromList = FilterProcess.getInstance().filter(em, <xsl:value-of select="@class"/>.class, filter);
				<xsl:value-of select="$type"/> toList = new ArrayList();
				mapperTo<xsl:value-of select="$name"/>ModelList(fromList, toList);
				return toList;
				}
				public <xsl:value-of select="$name"/> refresh<xsl:value-of select="$name"/>(final <xsl:value-of select="$name"/> value, final ValidationException validate) throws ServiceException{
				validate.isNull(value, "Refresh <xsl:value-of select="j:literal($name)"/>");
				validate.throwException();
				value.validateForSelected(validate);
				validate.throwException();
				<xsl:value-of select="@class"/> entity = em.find(<xsl:value-of select="@class"/>.class, value.getId<xsl:value-of select="$name"/>());
				mapperTo<xsl:value-of select="$name"/>Model(entity, value);
				mapperTo<xsl:value-of select="$name"/>Submodel(entity, value);
				return value;
				}
				public <xsl:value-of select="$name"/> create<xsl:value-of select="$name"/>(final <xsl:value-of select="$name"/> value, final ValidationException validate) throws ServiceException{
				value.validateForCreated(validate);
				validate.throwException();
				<xsl:value-of select="@class"/> entity = mapperTo<xsl:value-of select="$name"/>Entity(value);
				em.persist(entity);
				return mapperTo<xsl:value-of select="$name"/>Model(entity);
				}
				public <xsl:value-of select="$name"/> update<xsl:value-of select="$name"/>(final <xsl:value-of select="$name"/> value, final ValidationException validate) throws ServiceException{
				value.validateForUpdated(validate);
				validate.throwException();
				<xsl:value-of select="@class"/> entity = em.getReference(<xsl:value-of select="@class"/>.class, value.getId<xsl:value-of select="$name"/>());
				mapperTo<xsl:value-of select="$name"/>Entity(value, entity);
				em.merge(entity);
				return mapperTo<xsl:value-of select="$name"/>Model(entity);
				}
				public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(final <xsl:value-of select="$name"/> value, final ValidationException validate) throws ServiceException{
				value.validateForSelected(validate);
				validate.throwException();
				<xsl:value-of select="@class"/> entity = em.find(<xsl:value-of select="@class"/>.class, value.getId<xsl:value-of select="$name"/>());
				em.remove(entity);
				return mapperTo<xsl:value-of select="$name"/>Model(entity);
				}
				}
			</x:file>
		</xsl:if>
		<xsl:if test="j:generate('IMPL', current())">
			<x:file name="{$name}Impl.java" dir="{j:packagePath($packageBase)}" layer="impl">
				import java.util.List;
				import javax.ejb.EJB;
				import javax.ejb.Local;
				import javax.ejb.Stateless;
				import javax.ejb.TransactionManagement;
				import javax.ejb.TransactionManagementType;
				import <xsl:value-of select="$packageLib"/>.lang.ServiceException;
				import <xsl:value-of select="$packageLib"/>.lang.ValidationException;
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>Ftr;
				import <xsl:value-of select="$packageBase"/>.internal.<xsl:value-of select="$name"/>Local;
				@Stateless
				@Local(<xsl:value-of select="$name"/>Serv.class)
				@TransactionManagement(TransactionManagementType.CONTAINER)
				public class <xsl:value-of select="$name"/>Impl implements  <xsl:value-of select="$name"/>Serv{
				@EJB
				private <xsl:value-of select="$name"/>Local local;
				<xsl:variable name="type" select="j:varType($name, 'List')"/>
				@Override
				public <xsl:value-of select="$type"/> filter<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/>Ftr filter) throws ServiceException{
				ValidationException validate = new ValidationException("Listado <xsl:value-of select="j:literal($name)"/>");
				validate.isNull(filter, "Filter <xsl:value-of select="j:literal($name)"/>");
				validate.throwException();
				return local.filter<xsl:value-of select="$name"/>(filter, validate);
				}
				@Override
				public <xsl:value-of select="$name"/> create<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
				ValidationException validate = new ValidationException("Registro <xsl:value-of select="j:literal($name)"/>");
				validate.isNull(value, "Object <xsl:value-of select="j:literal($name)"/>");
				validate.throwException();
				return local.create<xsl:value-of select="$name"/>(value, validate);
				}
				@Override
				public <xsl:value-of select="$name"/> refresh<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
				ValidationException validate = new ValidationException("Registro <xsl:value-of select="j:literal($name)"/>");
				validate.isNull(value, "Object <xsl:value-of select="j:literal($name)"/>");
				validate.throwException();
				return local.refresh<xsl:value-of select="$name"/>(value, validate);
				}
				@Override
				public <xsl:value-of select="$name"/> update<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
				ValidationException validate = new ValidationException("Actualizar <xsl:value-of select="j:literal($name)"/>");
				validate.isNull(value, "Object <xsl:value-of select="j:literal($name)"/>");
				validate.throwException();
				return local.update<xsl:value-of select="$name"/>(value, validate);
				}
				@Override
				public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
				ValidationException validate = new ValidationException("Eliminar <xsl:value-of select="j:literal($name)"/>");
				validate.isNull(value, "Object <xsl:value-of select="j:literal($name)"/>");
				validate.throwException();
				return local.remove<xsl:value-of select="$name"/>(value, validate);
				}
				}
			</x:file>		
		</xsl:if>
		<xsl:if test="j:generate('IMPL-ABS', current())">
			<x:file name="{$name}Impl.java" dir="{j:packagePath($packageBase)}" layer="impl">
				import java.util.List;
				import javax.ejb.EJB;
				import javax.ejb.Local;
				import javax.ejb.Stateless;
				import javax.ejb.TransactionManagement;
				import javax.ejb.TransactionManagementType;
				import <xsl:value-of select="$packageLib"/>.lang.ServiceException;
				import <xsl:value-of select="$packageLib"/>.lang.ValidationException;
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>Ftr;
				import <xsl:value-of select="$packageBase"/>.entity.<xsl:value-of select="@class"/>;
				<xsl:for-each select="$entityChildren">
					<xsl:variable name="nameChild" select="j:className(@class)"/>
					import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$nameChild"/>;
					import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$nameChild"/>Ftr;
					import <xsl:value-of select="$packageBase"/>.internal.<xsl:value-of select="$nameChild"/>Local;
				</xsl:for-each>
				@Stateless
				@Local(<xsl:value-of select="$name"/>Serv.class)
				@TransactionManagement(TransactionManagementType.CONTAINER)
				public class <xsl:value-of select="$name"/>Impl implements  <xsl:value-of select="$name"/>Serv{
				<xsl:for-each select="$entityChildren">
					<xsl:variable name="nameChild" select="j:className(@class)"/>
					<xsl:variable name="varChild" select="j:varName($nameChild)"/>
					@EJB
					private <xsl:value-of select="$nameChild"/>Local <xsl:value-of select="$varChild"/>;
				</xsl:for-each>
				<xsl:for-each select="$entityChildren">
					<xsl:variable name="nameChild" select="j:className(@class)"/>
					<xsl:variable name="varChild" select="j:varName($nameChild)"/>
					<xsl:variable name="typeChild" select="j:varType($nameChild, 'List')"/>
					@Override
					public <xsl:value-of select="$typeChild"/> filter<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/>Ftr filter) throws ServiceException{
					ValidationException validate = new ValidationException("Listado <xsl:value-of select="j:literal($nameChild)"/>");
					return <xsl:value-of select="$varChild"/>.filter<xsl:value-of select="$nameChild"/>(filter, validate);
					}
					@Override
					public <xsl:value-of select="$nameChild"/> create<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/> value) throws ServiceException{
					ValidationException validate = new ValidationException("Registro <xsl:value-of select="j:literal($nameChild)"/>");
					return <xsl:value-of select="$varChild"/>.create<xsl:value-of select="$nameChild"/>(value, validate);
					}
					@Override
					public <xsl:value-of select="$nameChild"/> update<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/> value) throws ServiceException{
					ValidationException validate = new ValidationException("Actualizar <xsl:value-of select="j:literal($nameChild)"/>");
					return <xsl:value-of select="$varChild"/>.update<xsl:value-of select="$nameChild"/>(value, validate);
					}
				</xsl:for-each>
				@Override
				public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
				ValidationException validate = new ValidationException("Eliminar <xsl:value-of select="j:literal($name)"/>");
				validate.isNull(value, "<xsl:value-of select="j:literal($name)"/>");
				validate.throwException();
				validate.isNullOrEmpty(value.getId<xsl:value-of select="$name"/>(), "Id");
				validate.throwException();
				<xsl:for-each select="$entityChildren">
					<xsl:variable name="nameChild" select="j:className(@class)"/>
					<xsl:variable name="varChild" select="j:varName($nameChild)"/>
					if (value instanceof <xsl:value-of select="$nameChild"/>){
					return <xsl:value-of select="$varChild"/>.remove<xsl:value-of select="$nameChild"/>((<xsl:value-of select="$nameChild"/>)value, validate);
					} else 
				</xsl:for-each>
				{
				validate.addMessage("Valor no soportado");
				validate.throwException();
				}
				}

				}
			</x:file>		
		</xsl:if>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
