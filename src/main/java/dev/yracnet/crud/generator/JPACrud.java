package dev.yracnet.crud.generator;

import dev.yracnet.crud.spi.CrudConfig;
import dev.yracnet.crud.spi.CrudProcess;
import dev.yracnet.crud.spi.CrudUtil;

public class JPACrud {

	public static void main(String[] args) {
		String path = "/mnt/D/work/dev/CORE-14/manager/";
		String app = "manager";
		String mod = "report";
		CrudConfig crud = new CrudConfig(path, app, mod);
		crud.addJPAModel("manager-report-impl/src/main/designer/report-v1.jpa");
		crud.setPackageBase("bo.com.bancounion.manager.report");
		CrudUtil.addRemovePrefix("Rpt");
		crud.include("RptTask");
		crud.setTemplate("spa");
//		crud.addXSLT("serv.xsl");
		crud.addXSLT("dto.xsl");
//		crud.addXSLT("mapper.xsl");
//		crud.addXSLT("impl.xsl");
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
