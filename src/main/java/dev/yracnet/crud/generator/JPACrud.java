package dev.yracnet.crud.generator;

import dev.yracnet.crud.spi.CrudConfig;
import dev.yracnet.crud.spi.CrudProcess;
import dev.yracnet.crud.spi.CrudUtil;

public class JPACrud {

	public static void main(String[] args) {
		//String path = "/work/dev/XXX-CORE/";
		//String path = "/work/dev/XXX-CORE/app/app-generado";
		String path = "/media/sipaco/Spaco101/Users/sipaco/Desktop/CORE/Proyectos/sample/app/app-generado";
		//String app = "laika";
		//String mod = "app";
		String app = "app";
		String mod = "manager";
		CrudConfig crud = new CrudConfig(path, "app-manager", app, mod);
		//crud.addJPAModel("laika-app-impl/src/main/java/design/v01.jpa");
		//crud.setPackageLib("dev.laika.app");
		//crud.setPackageBase("dev.laika.app");
		crud.addJPAModel("/v01.jpa");
		crud.setPackageLib("bo.union");
		crud.setPackageBase("dev.laika.demo.app.manager");
		CrudUtil.addRemovePrefix("Lka");
		crud.include("LkaParam");
		crud.setTemplate("spa_v2");
		crud.addXSLT("serv.xsl");
		crud.addXSLT("dto.xsl");
		crud.addXSLT("mapper.xsl");
		crud.addXSLT("local.xsl");
		crud.addXSLT("impl.xsl");
		crud.addXSLT("ctrl.xsl");
		crud.addXSLT("view.xsl");
		crud.addXSLT("part.xsl");
		crud.addXSLT("test.xsl");
		crud.addXSLT("rest.xsl");
		crud.addXSLT("conf.xsl");
		crud.setForceOverwriter(true);
		crud.setTemploral(false);
		CrudProcess process = new CrudProcess();
		process.process(crud);
	}
}
