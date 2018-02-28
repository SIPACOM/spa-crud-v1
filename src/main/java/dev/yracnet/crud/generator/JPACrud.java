package dev.yracnet.crud.generator;

import dev.yracnet.crud.spi.CrudConfig;
import dev.yracnet.crud.spi.CrudProcess;
import dev.yracnet.crud.spi.CrudUtil;

public class JPACrud {

	public static void main(String[] args) {
		//String path = "/work/dev/XXX-CORE/";
		//String path = "/work/dev/XXX-CORE/app/app-generado";
		//String path = "/media/sipaco/Spaco101/Users/sipaco/Desktop/CORE/Proyectos/sample/app/app-generado";
		//crud.addJPAModel("laika-app-impl/src/main/java/design/v01.jpa");
		//crud.setPackageLib("dev.laika.app");
		//crud.setPackageBase("dev.laika.app");
		//crud.addJPAModel("/v01.jpa");
		//// ************************PARA LA NUEVA ESQUEMA ********************************************************
		//String path = "/mnt/D/work/dev/XXX-CORE/app/app-manager/";
		//CrudConfig crud = new CrudConfig(path, "app-manager", "laika", "prueba");
		//crud.addJPAModel("app-manager-local/src/main/java/dev/laika/demo/app/manager/design/v01.jpa");
		//crud.setPackageLib("bo.union");
		//crud.setPackageBase("dev.laika.demo.app.manager");
		//CrudUtil.addRemovePrefix("Lka");
		String path = "/mnt/D/work/CORE-03/i16d/i16d-manager/";
		CrudConfig crud = new CrudConfig(path, "i16d-manager", "laika", "i16d");
		crud.addJPAModel("i16d-manager-impl/src/main/java/design/v01.jpa");
		crud.setPackageLib("bo.union");
		crud.setPackageBase("bo.union.platform.i16d.manager");
		CrudUtil.addRemovePrefix("I16d");
		//crud.include("I16dGrupo");
		crud.include("I16dValor");
		crud.include("I16dValorProceso");
		crud.include("I16dTipoArchivo");
		crud.include("I16dArchivoConfig");
		crud.include("I16dArchivoMapeo");
		crud.include("I16dError");
		crud.setTemplate("spa_v2");
		//crud.addXSLT("serv.xsl");
		//crud.addXSLT("dto.xsl");
		//crud.addXSLT("mapper.xsl");
		//crud.addXSLT("local.xsl");
		//crud.addXSLT("impl.xsl");
		crud.addXSLT("ctrl.xsl");
		//crud.addXSLT("view.xsl");
		//crud.addXSLT("part.xsl");
		//crud.addXSLT("test.xsl");
		//crud.addXSLT("rest.xsl");
		//crud.addXSLT("conf.xsl");
		crud.setForceOverwriter(true);
		crud.setTemploral(false);
		CrudProcess process = new CrudProcess();
		process.process(crud);
	}
}
