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
  <xsl:variable name="entityChildren"  select="../jpa:entity[@superclassId = $id]"/>
  <xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>		
  <xsl:if test="j:generate('LOCAL', current() )">
   <x:file name="{$name}Local.java" dir="{j:packagePath($packageBase)}/local" layer="local">
    import java.util.List;
    import javax.ejb.LocalBean;
    import javax.ejb.Stateless;
    import javax.persistence.EntityManager;
    import javax.persistence.PersistenceContext;
    import bo.union.persist.qfilter.QFilter;
    import bo.union.lang.ServiceException;
    import bo.union.lang.ValidationException;
    import bo.union.comp.filter.MapFilter;
    import <xsl:value-of select="$packageBase"/>.entity.<xsl:value-of select="@class"/>;
    @Stateless
    @LocalBean
    public class <xsl:value-of select="$name"/>Local {
    @PersistenceContext(unitName = "store-<xsl:value-of select="$mod"/>")
    private EntityManager em;
    <xsl:variable name="type" select="j:varType(@class, 'List')"/>
    public <xsl:value-of select="$type"/> filter<xsl:value-of select="$name"/>(MapFilter filter) throws ServiceException{
    return QFilter.filter(em, <xsl:value-of select="@class"/>.class, filter);
    }
    public <xsl:value-of select="@class"/> create<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> value) throws ServiceException{
    ValidationException validate = new ValidationException("Registro <xsl:value-of select="$name"/>");
    validateCreate<xsl:value-of select="$name"/>(value, validate);
    em.persist(value);
    return value;
    }
    public <xsl:value-of select="@class"/> update<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> entity) throws ServiceException{
    ValidationException validate = new ValidationException("Actualizar <xsl:value-of select="$name"/>");
    validateUpdate<xsl:value-of select="$name"/>(entity, validate);
    em.merge(entity);
    return entity;
    }
    public <xsl:value-of select="@class"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> entity) throws ServiceException{
    ValidationException validate = new ValidationException("Eliminar <xsl:value-of select="$name"/>");
    validateRemove<xsl:value-of select="$name"/>(entity, validate);
    em.remove(entity);
    return entity;
    }
    public void validateCreate<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> entity, ValidationException validate) throws ServiceException{
    validate.isNull(entity, "<xsl:value-of select="j:literal($name)"/>");
    validate.throwException();
    <xsl:for-each select="jpa:attributes/jpa:id">
     validate.isNotNull(entity.get<xsl:value-of select="j:accName(@name)"/>(), "<xsl:value-of select="j:varName(@name)"/>");
    </xsl:for-each>
    validate(entity, validate);
    validate.throwException();
    }
    public void validateUpdate<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> entity, ValidationException validate) throws ServiceException{
    validate.isNull(entity, "<xsl:value-of select="j:literal($name)"/>");
    validate.throwException();
    <xsl:for-each select="jpa:attributes/jpa:id">
     validate.isNullOrEmpty(entity.get<xsl:value-of select="j:accName(@name)"/>(), "<xsl:value-of select="j:varName(@name)"/>");
    </xsl:for-each>
    validate(entity, validate);
    validate.throwException();
    }
    public void validateRemove<xsl:value-of select="$name"/>(<xsl:value-of select="@class"/> value, ValidationException validate) throws ServiceException{
    validate.isNull(value, "<xsl:value-of select="j:literal($name)"/>");
    validate.throwException();
    validate.isNullOrEmpty(value.getId<xsl:value-of select="$name"/>(), "id<xsl:value-of select="$name"/>");
    validate.throwException();
    }
    
    public void validate(<xsl:value-of select="@class"/> entity, ValidationException validate) throws ValidationException {
    <xsl:for-each select="jpa:attributes/*[j:process(@name)]">
     <xsl:variable name="type" select="j:varType(@attribute-type, null, ./jpa:enumerated)"/>
     <xsl:variable name="attr" select="j:varName(@name)"/>		
     <xsl:variable name="column" select="./jpa:column"/>
     <xsl:if test="$column/@nullable='false'">
      <xsl:choose>
       <xsl:when test="name(.) = 'jpa:id'">
       </xsl:when>
       <xsl:when test="@attribute-type = 'String'">
        validate.isNullOrNotTextOrLength(entity.get<xsl:value-of select="j:accName($attr)"/>(), <xsl:value-of select="j:eval($column/@min, 3)"/>, <xsl:value-of select="j:eval($column/@length, $column/@max, 50)"/>, "<xsl:value-of select="j:literal($attr)"/>");
       </xsl:when>
       <xsl:otherwise>
        validate.isNullOrEmpty(entity.get<xsl:value-of select="j:accName($attr)"/>(), "<xsl:value-of select="j:literal($attr)"/>");
       </xsl:otherwise>
      </xsl:choose>
     </xsl:if>
    </xsl:for-each>
    }
    }
   </x:file>
  </xsl:if>
 </xsl:template>
 <xsl:template match="text()"/>
</xsl:stylesheet>
