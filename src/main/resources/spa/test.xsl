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
		
		
		<x:file name="{$name}Test.java" dir="{j:packagePath($packageBase)}" layer="test">
			

			import bo.union.lang.ServiceException;
			import com.mycompany.laika.lib.SPATest;
			import <xsl:value-of select="$packageBase"/>.data.<xsl:value-of select="$name"/>;
			import <xsl:value-of select="$packageBase"/>.filter.<xsl:value-of select="$name"/>Ftr;
			import java.util.List;
			import javax.ejb.EJB;
			import org.jboss.arquillian.container.test.api.Deployment;
			import org.jboss.arquillian.junit.Arquillian;
			import org.jboss.arquillian.junit.InSequence;
			import org.jboss.shrinkwrap.api.spec.WebArchive;
			import static org.junit.Assert.assertTrue;
			import org.junit.Test;
			import org.junit.runner.RunWith;
			
			
			@RunWith(Arquillian.class)
			public class <xsl:value-of select="$name"/>Test {


			@Deployment
			public static WebArchive createDeployment() {
			WebArchive war = SPATest.createSPADeploy("<xsl:value-of select="$app"/>-<xsl:value-of select="$mod"/>.war", "SERV-TEST");
			System.out.println("--->" + war);
			return war;
			}			
			@EJB
			private <xsl:value-of select="$name"/>Serv serv;
			
			@Test
			@InSequence(0)
			public void assertCreate<xsl:value-of select="$name"/>() throws ServiceException {
			<xsl:value-of select="$name"/> value = new <xsl:value-of select="$name"/>();
			<xsl:value-of select="$name"/> other = serv.create<xsl:value-of select="$name"/>(value);
			assertTrue(other != null);
			assertTrue(other.getId<xsl:value-of select="$name"/>() != null);
			}
			
			@Test
			@InSequence(1)
			public void assertFilter<xsl:value-of select="$name"/>() throws ServiceException {
			<xsl:value-of select="$name"/>Ftr filter = new <xsl:value-of select="$name"/>Ftr();
			List&lt;<xsl:value-of select="$name"/>&gt; assertList = serv.filter<xsl:value-of select="$name"/>(filter);
			assertTrue(assertList != null);
			assertTrue(assertList.size() == 1);
			}
			
			@Test
			@InSequence(2)
			public void assertUpdate<xsl:value-of select="$name"/>() throws ServiceException {
			<xsl:value-of select="$name"/> value = new <xsl:value-of select="$name"/>();
			value.setId<xsl:value-of select="$name"/>(1L);
			<xsl:value-of select="$name"/> other = serv.update<xsl:value-of select="$name"/>(value);
			System.out.println("-****************-->" + value);
			System.out.println("-****************-->" + other);
			assertTrue(other != null);
			}
			
			@Test
			@InSequence(3)
			public void assertRemove<xsl:value-of select="$name"/>() throws ServiceException {
			<xsl:value-of select="$name"/> value = new <xsl:value-of select="$name"/>();
			value.setId<xsl:value-of select="$name"/>(1L);
			<xsl:value-of select="$name"/> other = serv.remove<xsl:value-of select="$name"/>(value);
			System.out.println("-****************-->" + value);
			System.out.println("-****************-->" + other);
			assertTrue(other != null);
			}

			}
		</x:file>		
		
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
