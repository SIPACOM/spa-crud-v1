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
	<xsl:variable name="and"><![CDATA[&&]]></xsl:variable>
	<xsl:template match="/">
		<x:files>
			<xsl:apply-templates/>
		</x:files>
	</xsl:template>
	<xsl:template match="jpa:entity[j:process(@class, $include, $exclude)]">
		<xsl:variable name="name" select="j:className(@class)"/>		
		<xsl:variable name="var" select="j:varName($name)"/>
		<x:file name="{$var}.html" dir="." layer="view">		
			<div ng-controller="{$mod}${$var}">
				<div ng-include="view.inbox">
					Load Inbox
				</div>
				<div ng-if="panel.if('create')" ng-include="view.create">
					Load Create
				</div>
				<div ng-if="panel.if('update')" ng-include="view.update">
					Load Update
				</div>
				<div ng-if="panel.if('remove')" ng-include="view.remove">
					Load Remove
				</div>
				<div ng-if="panel.if('info')" ng-include="view.info">
					Load Info
				</div>
				<div ng-if="panel.if('police')" ng-include="view.police">
					Load Audit
				</div>
			</div>			
		</x:file>
		<x:file name="{$var}/inbox.html" dir="." layer="view">		
			<div uni-pager="" 
								config="data.filter.$config"
								click-apply="filter.apply()" 
								click-clear="filter.clear()">
				<div ng-include="part.filter" ng-replace="context">
					Load Filter Part
				</div>
				<header>
					<div uni-action="">
						<button ng-click="action.open('create')">Nuevo</button>
						<button ng-disabled="!table.isOneSelect()" 
														ng-click="action.open('update')">Editar</button>
						<button ng-disabled="!table.isOneSelect()" 
														ng-click="action.open('info')">Datos</button>
						<button ng-disabled="!table.isOneSelect()"
														ng-click="action.open('remove')">Eliminar</button>
						<button ng-disabled="!table.isMoreSelect()"
														uni-confirm="remove"
														ng-click="action.remove()">Eliminar</button>													
					</div>
				</header>
			</div>
			<div ng-include="part.table" ng-replace="context">
				Load Table Part
			</div>
		</x:file>
		<x:file name="{$var}/create.html" dir="." layer="view">		
			<div>
				<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'primary'}</xsl:attribute>
				<header i18n="new,{$var}">Nuevo <xsl:value-of select="$name"/></header>
				<form name="filterNew" uni-validator="">
					<div ng-include="part.form" ng-replace="context">
						Load Form Part
					</div>
				</form>
				<footer>
					<button uni-badge="" uni-confirm="create">
						<xsl:attribute name="ng-click">filterNew.$validate() _AND_ action.create()</xsl:attribute>
						Guardar
					</button>
					<button uni-badge="" uni-confirm="cancel">
						<xsl:attribute name="ng-click">action.cancel('create')</xsl:attribute>
						Cancelar
					</button>
				</footer>
			</div>
		</x:file>
		<x:file name="{$var}/update.html" dir="." layer="view">
			<div>
				<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'success'}</xsl:attribute>
				<header i18n="edit,{$var}">
					Editar <xsl:value-of select="$name"/>
					<xsl:for-each select="jpa:attributes/jpa:id">
						<b>#{{data.select.<xsl:value-of select="@name"/>}} </b>
					</xsl:for-each>
				</header>
				<form name="filterEdit" uni-validator="">
					<div ng-include="part.form" ng-replace="context">
						Load Form Part
					</div>
				</form>
				<footer>
					<button uni-badge="" uni-confirm="update">
						<xsl:attribute name="ng-click">filterEdit.$validate() _AND_ action.update()</xsl:attribute>
						Actualizar
					</button>
					<button uni-badge="" uni-confirm="cancel">
						<xsl:attribute name="ng-click">action.cancel('update')</xsl:attribute>
						Cancelar
					</button>
				</footer>
			</div>
		</x:file>
		<x:file name="{$var}/remove.html" dir="." layer="view">		
			<div>
				<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'danger'}</xsl:attribute>
				<header i18n="info,{$var}">
					Datos <xsl:value-of select="$name"/>
					<xsl:for-each select="jpa:attributes/jpa:id">
						<b>#{{data.select.<xsl:value-of select="@name"/>}} </b>
					</xsl:for-each>
				</header>
				<div ng-include="part.info" ng-replace="context">
					Load Info Part
				</div>
				<footer>
					<button uni-badge=""
													uni-confirm="remove"
													ng-click="action.remove()">Eliminar</button>
					<button uni-badge="">
						<xsl:attribute name="ng-click">action.cancel('remove')</xsl:attribute>
						Cancelar
					</button>
				</footer>
			</div>
		</x:file>
		<x:file name="{$var}/info.html" dir="." layer="view">
			<div>
				<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'success'}</xsl:attribute>
				<header i18n="info,{$var}">
					Datos <xsl:value-of select="$name"/>
					<xsl:for-each select="jpa:attributes/jpa:id">
						<b>#{{data.select.<xsl:value-of select="@name"/>}} </b>
					</xsl:for-each>
				</header>
				<div ng-include="part.info" ng-replace="context">
					Load Info Part
				</div>
				<footer>
					<button uni-badge="">
						<xsl:attribute name="ng-click">action.cancel('info')</xsl:attribute>
						Cancelar
					</button>
				</footer>
			</div>
		</x:file>
		<x:file name="{$var}/police.html" dir="." layer="view">
			<div>
				<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'success'}</xsl:attribute>
				<header i18n="info,{$var}">
					Datos <xsl:value-of select="$name"/>
					<xsl:for-each select="jpa:attributes/jpa:id">
						<b>#{{data.select.<xsl:value-of select="@name"/>}} </b>
					</xsl:for-each>
				</header>
				<div ng-include="part.police" ng-replace="context">
					Load Police Part
				</div>
				<footer>
					<button uni-badge="">
						<xsl:attribute name="ng-click">action.cancel('info')</xsl:attribute>
						Cancelar
					</button>
				</footer>
			</div>
		</x:file>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
