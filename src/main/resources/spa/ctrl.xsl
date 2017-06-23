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
		<xsl:variable name="typeList" select="j:varType($name, 'List')"/>
		<xsl:variable name="superClassId" select="@superclassId"/>
		<xsl:variable name="superClass" select="../jpa:mapped-superclass[@id = $superClassId]/@class"/>
		<x:file name="{$var}.js" dir="." layer="ctrl">
			__app.controller("<xsl:value-of select="$mod"/>$<xsl:value-of select="$var"/>", function ($scope, $http, $module) {
			const module = new $module('<xsl:value-of select="$var"/>', '<xsl:value-of select="$mod"/>');
			$scope.$param = module.createParam({tipo: 'tipo-parametro'});
			$scope.$part = module.createPart();
	
			var $serv = module.createServ();
			var $wrap = $scope.wrap = {
			filter: {},
			list: [],
			value: {},
			select: undefined,
			parent: undefined
			};
			var $modal = $scope.$modal = module.createModal();
			var $event = $scope.$event = {
			select: function (value) {
			if ($wrap.select &amp;&amp; $wrap.select.id<xsl:value-of select="$name"/> === value.id<xsl:value-of select="$name"/>) {
			$wrap.select = undefined;
			} else {
			$wrap.select = angular.copy(value);
			}
			},
			selected: function (value) {
			return $wrap.select &amp;&amp; $wrap.select.id<xsl:value-of select="$name"/> === value.id<xsl:value-of select="$name"/>;
			},
			disabled: function () {
			return $wrap.select === undefined;
			},
			apply: function () {
			console.log('filter--->', $wrap.filter, '-->', $serv.filter);
			var call = $http.post($serv.filter, $wrap.filter);
			call.success(function (data) {
			$wrap.list = data;
			});
			call.error(function () {
			$wrap.list = [];
			});
			},
			clear: function () {
			$wrap.list = [];
			$wrap.filter = {};
			}
			};
			var $action = $scope.$action = {
			cancel: function (modal) {
			console.log('cancel--->', $wrap.value || $wrap.select);
			$modal.close(modal);
			},
			create: function () {
			console.log('create--->', $wrap.value, '-->', $serv.create);
			var call = $http.post($serv.create, $wrap.value);
			call.success(function () {
			$wrap.value = {};
			$event.apply();
			$modal.close('new');
			});
			},
			update: function () {
			console.log('update--->', $wrap.select, '-->', $serv.update);
			var call = $http.post($serv.update, $wrap.select);
			call.success(function () {
			$wrap.select = undefined;
			$event.apply();
			$modal.close('edit');
			});
			},
			remove: function () {
			console.log('remove--->', $wrap.select, '-->', $serv.remove);
			var call = $http.post($serv.remove, $wrap.select);
			call.success(function () {
			$wrap.select = undefined;
			$event.apply();
			$modal.close('delete');
			});
			}
			};
			});
		</x:file>
	</xsl:template>
	
	<xsl:template match="text()"/>
</xsl:stylesheet>
