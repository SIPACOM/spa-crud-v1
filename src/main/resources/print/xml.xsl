<xsl:stylesheet version="2.0" 
																xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
																xmlns:x="http://github.com/yracnet/xml/crud"
																xmlns="http://www.w3.org/1999/xhtml"> 
	<xsl:output method="xml" 
													encoding="utf-8" 
													indent="yes"
													media-type="text/html"/>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>	
	<xsl:template match="file">
		<xsl:apply-templates/>
	</xsl:template>	
</xsl:stylesheet>
