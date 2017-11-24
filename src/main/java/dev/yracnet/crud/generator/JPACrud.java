package dev.yracnet.crud.generator;

import dev.yracnet.crud.spi.CrudConfig;
import dev.yracnet.crud.spi.CrudProcess;
import dev.yracnet.crud.spi.CrudUtil;

public class JPACrud {

	public static void main(String[] args) {
		String path = "/work/dev/CORE-00/laika/";
		String app = "laika";
		String mod = "tenancy";
		CrudConfig crud = new CrudConfig(path, app, mod);
		crud.addJPAModel("laika-tenancy-impl/src/main/java/design/admin.jpa");
		crud.setPackageLib("bo.union");
		crud.setPackageBase("bo.laika.tenancy");
		CrudUtil.addRemovePrefix("Trk");
		CrudUtil.addRemovePrefix("Trx");
		CrudUtil.addRemovePrefix("Tx");
		CrudUtil.addRemovePrefix("Tcy");
		CrudUtil.addRemovePrefix("Iso");
		crud.include("TcyConfig");
		crud.include("TcyTenancy");
		crud.include("TcyTenancy");
		//crud.include("TxTransaccion");
		crud.setTemplate("spa");
//		crud.addXSLT("serv.xsl");
//		crud.addXSLT("dto.xsl");
//		crud.addXSLT("mapper.xsl");
//		crud.addXSLT("impl.xsl");
//		crud.addXSLT("ctrl.xsl");
		crud.addXSLT("view.xsl");
//		crud.addXSLT("part.xsl");
//		crud.addXSLT("test.xsl");
//		crud.addXSLT("rest.xsl");
//		crud.addXSLT("conf.xsl");
		crud.setForceOverwriter(true);
		crud.setTemploral(false);
		CrudProcess process = new CrudProcess();
		process.process(crud);
	}
}
