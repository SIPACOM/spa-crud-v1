package dev.yracnet.crud.generator;

import dev.yracnet.crud.spi.CrudConfig;
import dev.yracnet.crud.spi.CrudProcess;
import dev.yracnet.crud.spi.CrudUtil;

public class JPACrud {

	public static void main(String[] args) {
		String path = "/mnt/D/work/dev/CORE-13/laika/";
		String app = "laika";
		String mod = "app";
		CrudConfig crud = new CrudConfig(path, app, mod);
		crud.addJPAModel("laika-app-impl/src/main/design/app.jpa");
		crud.setPackageBase("dev.laika.app");
		//CrudUtil.addRemovePrefix("Rpt");
		CrudUtil.addRemovePrefix("Lka");
		crud.include("LkaParam");
		//crud.exclude("RptBase");
		//crud.include("RptParametro");
		//crud.include("RptValor");
		//crud.exclude("RptRecurso");
		//crud.include("RptReporte");
		//crud.include("RptCarpeta");
		//crud.exclude("*");
		//crud.searchJPAModel("reporteJPADiagram.jpa");
		crud.setTemplate("spa");
//		crud.addXSLT("serv.xsl");
//		crud.addXSLT("dto.xsl");
		crud.addXSLT("parser.xsl");
		crud.addXSLT("impl.xsl");
//		crud.addXSLT("ctrl.xsl");
//		crud.addXSLT("view.xsl");
//		crud.addXSLT("part.xsl");
//		crud.addXSLT("rest.xsl");
//		crud.addXSLT("conf.xsl");
		crud.setForceOverwriter(true);
		CrudProcess process = new CrudProcess();
		process.process(crud);
	}
}
