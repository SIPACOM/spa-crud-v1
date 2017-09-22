package dev.yracnet.crud.generator;

import dev.yracnet.crud.spi.CrudConfig;
import dev.yracnet.crud.spi.CrudProcess;
import dev.yracnet.crud.spi.CrudUtil;

public class JPACrud {

	public static void main(String[] args) {
		String path = "/work/dev/CORE-15/extra/";
		String app = "laika";
		String mod = "mod";
		CrudConfig crud = new CrudConfig(path, app, mod);
		crud.addJPAModel("laika-mod-impl/src/main/java/model/v0.jpa");
		//crud.setPackageLib("bo.gob.minsalud");
		//crud.setPackageBase("bo.gob.minsalud.param");
		CrudUtil.addRemovePrefix("Tmp");
		//crud.include("RptParam");
		//crud.include("RptData");
		//crud.include("RptOutput");
		//crud.include("ParDomain");
		//crud.include("ParParam");
		crud.include("TmpClient");
		crud.include("TmpAccount");
		crud.setTemplate("spa");
//		crud.addXSLT("serv.xsl");
//		crud.addXSLT("dto.xsl");
//		crud.addXSLT("mapper.xsl");
//		crud.addXSLT("impl.xsl");
//		crud.addXSLT("ctrl.xsl");
//		crud.addXSLT("view.xsl");
//		crud.addXSLT("part.xsl");
		crud.addXSLT("test.xsl");
//		crud.addXSLT("rest.xsl");
//		crud.addXSLT("conf.xsl");
		crud.setForceOverwriter(true);
		crud.setTemploral(false);
		CrudProcess process = new CrudProcess();
		process.process(crud);
	}
}
