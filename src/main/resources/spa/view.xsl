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
									config="wrap.filter.$config"
									click-apply="event.apply()" 
									click-clear="event.clear()">
					<div uni-part="part.filter">
						<xsl:attribute name="replace">{_filter: 'wrap.filter'}</xsl:attribute>
					</div>
				</div>
				<div uni-action="">
					<button ng-click="modal.open('new')">Nuevo</button>
					<button ng-disabled="event.disabled()" 
													ng-click="modal.open('edit')">Editar</button>
					<button ng-disabled="event.disabled()" 
													ng-click="modal.open('info')">Datos</button>
					<button ng-disabled="event.disabled()"
													ng-click="modal.open('delete')">Eliminar</button>
					<button ng-disabled="event.disabled()"
													uni-confirm="remove"
													ng-click="action.remove()">Eliminar</button>
				</div>
				<div uni-part="part.table">
					<xsl:attribute name="replace">{_list: 'wrap.list', _select: 'event.select', _selected: 'event.selected'}</xsl:attribute>
				</div>
				<div ng-show="modal.show('new')">
					<xsl:attribute name="uni-panel">{type:'modal', size:'lg'}</xsl:attribute>
					<header i18n="new,{$var}">Nuevo <xsl:value-of select="$name"/></header>
					<form name="f1" uni-validator="">
						<div uni-part="part.new">
							<xsl:attribute name="replace">{_value: 'wrap.value'}</xsl:attribute>
						</div>
					</form>
					<footer>
						<button uni-badge="" uni-confirm="create">
							<xsl:attribute name="ng-click">f1.$validate() _AND_ action.create()</xsl:attribute>
							Guardar
						</button>
						<button uni-badge="" uni-confirm="cancel">
							<xsl:attribute name="ng-click">action.cancel('new')</xsl:attribute>
							Cancelar
						</button>
					</footer>
				</div>
				<div ng-show="modal.show('edit')">
					<xsl:attribute name="uni-panel">{type:'modal', size:'lg'}</xsl:attribute>
					<header i18n="edit,{$var}">Editar <xsl:value-of select="$name"/></header>
					<form name="f2" uni-validator="">
						<div uni-part="part.edit">
							<xsl:attribute name="replace">{_value: 'wrap.select'}</xsl:attribute>
						</div>
					</form>
					<footer>
						<button uni-badge="" uni-confirm="update">
							<xsl:attribute name="ng-click">f2.$validate() _AND_ action.update()</xsl:attribute>
							Actualizar
						</button>
						<button uni-badge="" uni-confirm="cancel">
							<xsl:attribute name="ng-click">action.cancel('edit')</xsl:attribute>
							Cancelar
						</button>
					</footer>
				</div>
				<div ng-show="modal.show('info')">
					<xsl:attribute name="uni-panel">{type:'modal', size:'lg'}</xsl:attribute>
					<header i18n="info,{$var}">Datos <xsl:value-of select="$name"/></header>
					<div uni-part="part.info">
						<xsl:attribute name="replace">{_value: 'wrap.select'}</xsl:attribute>
					</div>
					<footer>
						<button uni-badge="">
							<xsl:attribute name="ng-click">action.cancel('info')</xsl:attribute>
							Cancelar
						</button>
					</footer>
				</div>
				<div ng-show="modal.show('delete')">
					<xsl:attribute name="uni-panel">{type:'modal', size:'lg'}</xsl:attribute>
					<header i18n="info,{$var}">Datos <xsl:value-of select="$name"/></header>
					<div uni-part="part.info">
						<xsl:attribute name="replace">{_value: 'wrap.select'}</xsl:attribute>
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
