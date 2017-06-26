package dev.yracnet.crud.generator;

import dev.yracnet.crud.spi.CrudConfig;
import dev.yracnet.crud.spi.CrudProcess;

public class JPACrud {

	public static void main(String[] args) {
		String path = "/work/dev/CORE-13/manager/";
		String app = "manager";
		String mod = "report";
		CrudConfig crud = new CrudConfig(path, app, mod);
		crud.addJPAModel("manager-report-impl/src/main/java/bo/com/bancounion/manager/jpamodel/reporteJPADiagram.jpa");
		crud.setPackageBase("bo.com.bancounion.manager.report");
		//crud.exclude("RptParametro");
		//crud.exclude("RptRecurso");
		//crud.include("RptReporte");
		//crud.include("RptCarpeta");
		//crud.exclude("*");
		//crud.searchJPAModel("reporteJPADiagram.jpa");
		crud.setTemplate("spa");
		//crud.addXSLT("part.xsl");
		//crud.addXSLT("view.xsl");
		//crud.addXSLT("ctrl.xsl");
		//crud.addXSLT("rest.xsl");
		crud.addXSLT("serv.xsl");
		//crud.addXSLT("parser.xsl");
		//crud.addXSLT("impl.xsl");
		//crud.addXSLT("conf.xsl");
		crud.setForceOverwriter(true);
		CrudProcess process = new CrudProcess();
		process.process(crud);
	}
}
