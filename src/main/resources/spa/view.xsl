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
				<div uni-pager="" 
									config="data.filter.$config"
									click-apply="filter.apply()" 
									click-clear="filter.clear()">
					<div uni-part="part.filter">
						<xsl:attribute name="replace">{_filter: 'data.filter'}</xsl:attribute>
					</div>
					<header>
						<div uni-action="">
							<button ng-click="action.open('create')">Nuevo</button>
							<button ng-disabled="!table.isOneSelect()" 
															ng-click="action.open('update')">Editar</button>
							<button ng-disabled="!table.isOneSelect()" 
															ng-click="action.open('info')">Datos</button>
							<button ng-disabled="!table.isOneSelect()"
															ng-click="action.open('delete')">Eliminar</button>
							<button ng-disabled="!table.isMoreSelect()"
															uni-confirm="remove"
															ng-click="action.remove()">Eliminar</button>													
						</div>
					</header>
				</div>
				<div uni-part="part.table">
					<xsl:attribute name="replace">{_list: 'data.list', _toggle: 'table.toggle', _in: 'table.in'}</xsl:attribute>
				</div>
				<div ng-if="panel.show('create')">
					<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'primary'}</xsl:attribute>
					<header i18n="new,{$var}">Nuevo <xsl:value-of select="$name"/></header>
					<form name="filterNew" uni-validator="">
						<div uni-part="part.new">
							<xsl:attribute name="replace">{_value: 'data.current'}</xsl:attribute>
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
				<div ng-if="panel.show('update')">
					<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'success'}</xsl:attribute>
					<header i18n="edit,{$var}">
						Editar <xsl:value-of select="$name"/>
						<xsl:for-each select="jpa:attributes/jpa:id">
							<b>#{{data.select.<xsl:value-of select="@name"/>}} </b>
						</xsl:for-each>
					</header>
					<form name="filterEdit" uni-validator="">
						<div uni-part="part.edit">
							<xsl:attribute name="replace">{_value: 'data.current'}</xsl:attribute>
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
				<div ng-if="panel.show('info')">
					<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'success'}</xsl:attribute>
					<header i18n="info,{$var}">
						Datos <xsl:value-of select="$name"/>
						<xsl:for-each select="jpa:attributes/jpa:id">
							<b>#{{data.select.<xsl:value-of select="@name"/>}} </b>
						</xsl:for-each>
					</header>
					<div uni-part="part.info">
						<xsl:attribute name="replace">{_value: 'data.current'}</xsl:attribute>
					</div>
					<footer>
						<button uni-badge="">
							<xsl:attribute name="ng-click">action.cancel('info')</xsl:attribute>
							Cancelar
						</button>
					</footer>
				</div>
				<div ng-if="panel.show('delete')">
					<xsl:attribute name="uni-panel">{type:'modal', size:'lg', level:'danger'}</xsl:attribute>
					<header i18n="info,{$var}">
						Datos <xsl:value-of select="$name"/>
						<xsl:for-each select="jpa:attributes/jpa:id">
							<b>#{{data.select.<xsl:value-of select="@name"/>}} </b>
						</xsl:for-each>
					</header>
					<div uni-part="part.info">
						<xsl:attribute name="replace">{_value: 'data.current'}</xsl:attribute>
					</div>
					<footer>
						<button uni-badge=""
														uni-confirm="remove"
														ng-click="action.remove()">Eliminar</button>
						<button uni-badge="">
							<xsl:attribute name="ng-click">action.cancel('delete')</xsl:attribute>
							Cancelar
						</button>
					</footer>
				</div>
			</div>			
		</x:file>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
