package dev.yracnet.crud.generator;

import dev.yracnet.crud.spi.CrudConfig;
import dev.yracnet.crud.spi.CrudProcess;
import dev.yracnet.crud.spi.CrudUtil;

public class JPACrud {

	public static void main(String[] args) {
		String path = "/mnt/D/work/dev/CORE-02/platform/i16d/i16d-manager/";
		CrudConfig crud = new CrudConfig(path, "i16d-manager", "laika", "i16d");
		crud.addJPAModel("i16d-manager-local/src/main/java/design/v01.jpa");
		crud.setPackageLib("bo.union");
		crud.setPackageBase("bo.union.platform.i16d.manager");
		CrudUtil.addRemovePrefix("I16d");
		//crud.include("I16dGrupo");
		crud.include("I16dValor");
		//crud.include("I16dValorCredential");
		//crud.include("I16dValorProceso");
		//crud.include("I16dTipoArchivo");
		//crud.include("I16dArchivoConfig");
		//crud.include("I16dArchivoMapeo");
		//crud.include("I16dError");
		crud.setTemplate("spa_v2");
		//crud.addXSLT("serv.xsl");
		//crud.addXSLT("dto.xsl");
		//crud.addXSLT("mapper.xsl");
		//crud.addXSLT("local.xsl");
		crud.addXSLT("impl.xsl");
		//crud.addXSLT("ctrl.xsl");
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
