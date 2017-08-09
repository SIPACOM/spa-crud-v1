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
			/*Implementacion Base*/
			__app.controller("<xsl:value-of select="$mod"/>$<xsl:value-of select="$var"/>", function ($scope, $http) {
			var paramValue = new ParamHandler($http, [
			'status:GLOBAL:STATUS',
			'type:GLOBAL:TYPE'
			]);
			$scope.param = paramValue.internal();
			$scope.part = new PartHandler('<xsl:value-of select="$mod"/>', '<xsl:value-of select="$var"/>');
			var <xsl:value-of select="$var"/>Serv = new ServHandler('<xsl:value-of select="$mod"/>', '<xsl:value-of select="$var"/>');
			var <xsl:value-of select="$var"/>Data = $scope.data = {
			filter: {},
			list: [],
			current: undefined,
			parent: undefined
			};
			var <xsl:value-of select="$var"/>Panel = $scope.panel = new PanelHandler();
			var <xsl:value-of select="$var"/>Filter = $scope.filter = {
			apply: function () {
			console.log('filter--->', <xsl:value-of select="$var"/>Data.filter, '-->', <xsl:value-of select="$var"/>Serv.filter);
			var call = $http.post(<xsl:value-of select="$var"/>Serv.filter, <xsl:value-of select="$var"/>Data.filter);
			call.success(function (data) {
			<xsl:value-of select="$var"/>Data.list = data;
			});
			call.error(function () {
			<xsl:value-of select="$var"/>Data.list = [];
			});
			},
			clear: function () {
			<xsl:value-of select="$var"/>Data.list = [];
			<xsl:value-of select="$var"/>Data.filter = {};
			}
			};

			var <xsl:value-of select="$var"/>List = $scope.table = {
			select: function (value) {
			if (<xsl:value-of select="$var"/>Data.current &amp;&amp; <xsl:value-of select="$var"/>Data.current.id<xsl:value-of select="$name"/> === value.id<xsl:value-of select="$name"/>) {
			<xsl:value-of select="$var"/>Data.current = undefined;
			} else {
			<xsl:value-of select="$var"/>Data.current = angular.copy(value, {});
			}
			},
			selected: function (value) {
			return <xsl:value-of select="$var"/>Data.current &amp;&amp; <xsl:value-of select="$var"/>Data.current.id<xsl:value-of select="$name"/> === value.id<xsl:value-of select="$name"/>;
			},
			isOneSelect: function () {
			return <xsl:value-of select="$var"/>Data.current &amp;&amp; true;
			},
			isMoreSelect: function () {
			return <xsl:value-of select="$var"/>Data.current &amp;&amp; true;
			}
			};
			var <xsl:value-of select="$var"/>Action = $scope.action = {
			open: function (name) {
			if (name === 'create') {
			<xsl:value-of select="$var"/>Data.current = angular.copy(value, {});
			}
			<xsl:value-of select="$var"/>Panel.open(name);
			},
			cancel: function (name) {
			console.log('cancel--->', <xsl:value-of select="$var"/>Data.current || <xsl:value-of select="$var"/>Data.current);
			<xsl:value-of select="$var"/>Data.current = undefined;
			<xsl:value-of select="$var"/>Panel.close(name);
			},
			create: function () {
			console.log('create--->', <xsl:value-of select="$var"/>Data.current, '-->', <xsl:value-of select="$var"/>Serv.create);
			var call = $http.post(<xsl:value-of select="$var"/>Serv.create, <xsl:value-of select="$var"/>Data.current);
			call.success(function () {
			<xsl:value-of select="$var"/>Data.current = {};
			<xsl:value-of select="$var"/>Filter.apply();
			<xsl:value-of select="$var"/>Panel.close('create');
			});
			},
			update: function () {
			console.log('update--->', <xsl:value-of select="$var"/>Data.current, '-->', <xsl:value-of select="$var"/>Serv.update);
			var call = $http.post(<xsl:value-of select="$var"/>Serv.update, <xsl:value-of select="$var"/>Data.current);
			call.success(function () {
			<xsl:value-of select="$var"/>Data.current = undefined;
			<xsl:value-of select="$var"/>Filter.apply();
			<xsl:value-of select="$var"/>Panel.close('update');
			});
			},
			remove: function () {
			console.log('remove--->', <xsl:value-of select="$var"/>Data.current, '-->', <xsl:value-of select="$var"/>Serv.remove);
			var call = $http.post(<xsl:value-of select="$var"/>Serv.remove, <xsl:value-of select="$var"/>Data.current);
			call.success(function () {
			<xsl:value-of select="$var"/>Data.current = undefined;
			<xsl:value-of select="$var"/>Filter.apply();
			<xsl:value-of select="$var"/>Panel.close('delete');
			});
			}
			};
			});
		</x:file>
		<x:file name="{$var}_handler.js" dir="." layer="ctrl">
			/*Implementacion Handler*/
			__app.controller("<xsl:value-of select="$mod"/>$<xsl:value-of select="$var"/>", function ($scope, $http) {
			var paramValue = new ParamHandler($http, [
			'status:GLOBAL:STATUS',
			'type:GLOBAL:TYPE'
			]);
			$scope.param = paramValue.internal();
			$scope.part = new PartHandler('<xsl:value-of select="$mod"/>', '<xsl:value-of select="$var"/>');
			var <xsl:value-of select="$var"/>Panel = $scope.panel = new PanelHandler();
			var <xsl:value-of select="$var"/>Serv = new ServHandler('<xsl:value-of select="$mod"/>', '<xsl:value-of select="$var"/>');
			var <xsl:value-of select="$var"/>Data = new DataHandler('id<xsl:value-of select="$name"/>');
			var <xsl:value-of select="$var"/>Internal = $scope.data = <xsl:value-of select="$var"/>Data.internal();
			var <xsl:value-of select="$var"/>Filter = $scope.filter = new FilterHandler($http, <xsl:value-of select="$var"/>Serv.filter, <xsl:value-of select="$var"/>Data);
			var <xsl:value-of select="$var"/>List = $scope.table = new ListHandler(<xsl:value-of select="$var"/>Data);
			var <xsl:value-of select="$var"/>Action = $scope.action = new ActionHandler($http, <xsl:value-of select="$var"/>Data, <xsl:value-of select="$var"/>Serv, <xsl:value-of select="$var"/>Filter, <xsl:value-of select="$var"/>Panel);
			//Flag DEBUG - REMOVE THIS BLOCK
			<xsl:value-of select="$var"/>Panel.debug = true;
			<xsl:value-of select="$var"/>Serv.debug = true;
			<xsl:value-of select="$var"/>Data.debug = true;
			<xsl:value-of select="$var"/>Filter.debug = true;
			<xsl:value-of select="$var"/>List.debug = true;
			<xsl:value-of select="$var"/>Action.debug = true;
			/**/
			});
		</x:file>
	</xsl:template>
	
	<xsl:template match="text()"/>
</xsl:stylesheet>
