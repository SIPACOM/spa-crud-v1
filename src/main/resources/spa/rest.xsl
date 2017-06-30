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
			<x:file name="RestConfig.java" dir="{j:packagePath($packageBase)}" layer="rest">			
				import java.util.HashSet;
				import java.util.Set;
				import javax.ws.rs.ApplicationPath;
				import javax.ws.rs.core.Application;

				@ApplicationPath("rest")
				public class RestConfig extends Application {

				private static final Set&lt;Class&lt;?&gt;&gt; classSet = new HashSet();

				static {
				<xsl:for-each select="jpa:entity-mappings/jpa:entity">
					<xsl:if test="j:generate('REST', current())">
						classSet.add(<xsl:value-of select="j:className(@class)"/>Rest.class);
					</xsl:if>
					<xsl:if test="j:generate('REST-ABS', current())">
						classSet.add(<xsl:value-of select="j:className(@class)"/>Rest.class);
					</xsl:if>
				</xsl:for-each>
				}

				@Override
				public Set&lt;Class&lt;?&gt;&gt; getClasses() {
				return classSet;
				}

				}			
			</x:file>
		</x:files>
	</xsl:template>
	<xsl:template match="jpa:entity[j:process(@class, $include, $exclude)]">
		<xsl:variable name="name" select="j:className(@class)"/>
		<xsl:variable name="var" select="j:varName($name)"/>
		<xsl:variable name="typeList" select="j:varType($name, 'List')"/>
		<xsl:variable name="id" select="@id"/>
		<xsl:variable name="superClassId" select="@superclassId"/>
		<xsl:variable name="entityChildren"  select="../jpa:entity[@superclassId = $id]"/>
		<xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>
		<xsl:if test="j:generate('REST', current())">
			<x:file name="{$name}Rest.java" dir="{j:packagePath($packageBase)}" layer="rest">
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
				import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$name"/>Ftr;
				import java.util.List;
				import javax.ejb.EJB;
				import javax.ws.rs.Consumes;
				import javax.ws.rs.GET;
				import javax.ws.rs.POST;
				import javax.ws.rs.Path;
				import javax.ws.rs.Produces;
				import javax.ws.rs.core.MediaType;
				import bo.union.lang.ServiceException;
				@Path("<xsl:value-of select="$var"/>")
				@Consumes(MediaType.APPLICATION_JSON)
				@Produces(MediaType.APPLICATION_JSON)
				public class <xsl:value-of select="$name"/>Rest {

				@EJB
				private <xsl:value-of select="$name"/>Serv serv;

				@GET
				@Path("info")
				public String info() throws ServiceException {
				return "Info Service: " + this + " by " + serv;
				}

				@POST
				@Path("filter")
				public <xsl:value-of select="$typeList"/> filter<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/>Ftr filter) throws ServiceException {
				return serv.filter<xsl:value-of select="$name"/>(filter);
				}
				@POST
				@Path("create")
				public <xsl:value-of select="$name"/> create<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException {
				return serv.create<xsl:value-of select="$name"/>(value);
				}
				@POST
				@Path("update")
				public <xsl:value-of select="$name"/> update<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException {
				return serv.update<xsl:value-of select="$name"/>(value);
				}
				@POST
				@Path("remove")
				public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException {
				return serv.remove<xsl:value-of select="$name"/>(value);
				}
				}
			</x:file>
		</xsl:if>
		<xsl:if test="j:generate('REST-ABS', current())">
			<x:file name="{$name}Rest.java" dir="{j:packagePath($packageBase)}" layer="rest">
				import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
				<xsl:for-each select="$entityChildren">
					<xsl:variable name="nameChild" select="j:className(@class)"/>
					import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$nameChild"/>;
					import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$nameChild"/>Ftr;
				</xsl:for-each>
				import java.util.List;
				import javax.ejb.EJB;
				import javax.ws.rs.Consumes;
				import javax.ws.rs.GET;
				import javax.ws.rs.POST;
				import javax.ws.rs.Path;
				import javax.ws.rs.Produces;
				import javax.ws.rs.core.MediaType;
				import bo.union.lang.ServiceException;
				@Path("<xsl:value-of select="$var"/>")
				@Consumes(MediaType.APPLICATION_JSON)
				@Produces(MediaType.APPLICATION_JSON)
				public class <xsl:value-of select="$name"/>Rest {

				@EJB
				private <xsl:value-of select="$name"/>Serv serv;

				@GET
				@Path("info")
				public String info() throws ServiceException {
				return "Info Service: " + this + " by " + serv;
				}

				<xsl:for-each select="$entityChildren">
					<xsl:variable name="nameChild" select="j:className(@class)"/>
					<xsl:variable name="varChild" select="j:varName($nameChild)"/>
					<xsl:variable name="typeChild" select="j:varType($nameChild, 'List')"/>
					@POST
					@Path("filter/<xsl:value-of select="$varChild"/>")
					public <xsl:value-of select="$typeChild"/> filter<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/>Ftr filter) throws ServiceException{
					return serv.filter<xsl:value-of select="$nameChild"/>(filter);
					}
					@POST
					@Path("create/<xsl:value-of select="$varChild"/>")
					public <xsl:value-of select="$nameChild"/> create<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/> value) throws ServiceException{
					return serv.create<xsl:value-of select="$nameChild"/>(value);
					}
					@POST
					@Path("update/<xsl:value-of select="$varChild"/>")
					public <xsl:value-of select="$nameChild"/> update<xsl:value-of select="$nameChild"/>(<xsl:value-of select="$nameChild"/> value) throws ServiceException{
					return serv.update<xsl:value-of select="$nameChild"/>(value);
					}
				</xsl:for-each>
				@POST
				@Path("remove")
				public <xsl:value-of select="$name"/> remove<xsl:value-of select="$name"/>(<xsl:value-of select="$name"/> value) throws ServiceException{
				return serv.remove<xsl:value-of select="$name"/>(value);
				}
				}
			</x:file>
		</xsl:if>
		<x:file name="{$name}Wrap.java" dir="{j:packagePath($packageBase, 'wrapper')}" layer="rest" ignore="true">
			import java.io.Serializable;
			import java.util.List;
			import javax.xml.bind.annotation.XmlAccessType;
			import javax.xml.bind.annotation.XmlAccessorType;
			import javax.xml.bind.annotation.XmlRootElement;
			import javax.xml.bind.annotation.XmlElement;
			import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
			import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$name"/>Ftr;
			@XmlRootElement
			@XmlAccessorType(XmlAccessType.NONE)
			public class <xsl:value-of select="$name"/>Wrap  implements Serializable {

			private static final long serialVersionUID = 1L;
			@XmlElement
			private <xsl:value-of select="$name"/> value;
			@XmlElement
			private <xsl:value-of select="$name"/>Ftr filter;
			@XmlElement
			private <xsl:value-of select="$typeList"/> valueList;
			public <xsl:value-of select="$name"/> getValue(){
			return value;
			}
			public void setValue(<xsl:value-of select="$name"/> _value){
			value = _value;
			}
			public <xsl:value-of select="$name"/>Ftr getFilter(){
			return filter;
			}
			public void setFilter(<xsl:value-of select="$name"/>Ftr _filter){
			filter = _filter;
			}
			public <xsl:value-of select="$typeList"/> getValueList(){
			return valueList;
			}
			public void setValueList(<xsl:value-of select="$typeList"/> _valueList){
			valueList = _valueList;
			}
			}
		</x:file>
	</xsl:template>
	
	<xsl:template match="text()"/>
</xsl:stylesheet>
