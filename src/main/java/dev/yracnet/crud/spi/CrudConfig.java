package dev.yracnet.crud.spi;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class CrudConfig {

	private final String path;
	private final String app;
	private final String mod;
	private final String project;
	private final File root;
	private String template = "entel";
	private boolean forceOverwriter = false;
	private boolean temporal = false;
	private String packageBase = "dev.yracnet.entel";
	private String packageLib = "dev.yracnet";
	private final List<String> include = new ArrayList<>();
	private final List<String> exclude = new ArrayList<>();
	private final List<File> jpaModel = new ArrayList<>();
	private final List<File> xsltFile = new ArrayList<>();

	public CrudConfig(String path, String name, String instance, String contextpath) {
		this.path = path;
		this.app = instance;
		this.mod = contextpath;
		this.project = name;
		root = new File(this.path);
	}
/*
	public CrudConfig(String path, String app, String mod) {
		this.path = path;
		this.app = app;
		this.mod = mod;
		this.project = app + "-" + mod;
		this.basePath = this.path + "/" + this.project;
		root = new File(this.basePath);
	}

	public CrudConfig(String path, String project) {
		this.path = path;
		this.app = "";
		this.mod = project;
		this.project = project;
		this.basePath = this.path + "/" + this.project;
		root = new File(this.basePath);
	}
*/
	public String getPath() {
		return path;
	}

	public String getApp() {
		return app;
	}

	public String getMod() {
		return mod;
	}

	public String getProject() {
		return project;
	}

	public void addJPAModel(String jpaName) {
		if (!jpaName.startsWith("file:/")) {
			jpaName = "file://" + path + "/" + jpaName;
		}
		System.out.println("addJPAModel: " + jpaName);
		try {
			//URL url = CrudConfig.class.getResource(jpaName);
			URL url = new URL(jpaName);
			File jpa;
			jpa = new File(url.toURI());
			jpaModel.add(jpa);
		} catch (MalformedURLException | URISyntaxException ex) {
			throw new CrudException("Error al adicionar el archivo JPA: " + jpaName, ex);
		}
	}

	public String getPackageBase() {
		return packageBase;
	}

	public void setPackageBase(String packageBase) {
		this.packageBase = packageBase;
	}

	public String getTemplate() {
		return template;
	}

	public void setTemplate(String template) {
		this.template = template;
	}

	public List<File> getXsltFile() {
		return xsltFile;
	}

	public void addXSLT(String xslName) throws CrudException {
		try {
			if (!xslName.startsWith("/")) {
				xslName = "/" + template + "/" + xslName;
			}
			URL url = CrudConfig.class.getResource(xslName);
			if (url != null) {
				File xsl;
				xsl = new File(url.toURI());
				xsltFile.add(xsl);
			} else {
				throw new CrudException("Archivo XSLT NO EXISTE: " + xslName);
			}
		} catch (URISyntaxException ex) {
			throw new CrudException("Error al adicionar el archivo XSLT: " + xslName, ex);
		}
	}

	public Stream<File> streamXSLT() {
		return xsltFile.stream();
	}

	public Stream<File> streamJPA() {
		return jpaModel.stream();
	}

	public String getRealPath(String layer, String dir, String name) {
		String mask = "$path/$project/error/$name";
		if ("ctrl".endsWith(layer)) {
			mask = "$path/$project-view/src/main/webapp/ctrl/$name";
		} else if ("view".endsWith(layer)) {
			mask = "$path/$project-view/src/main/webapp/view/$name";
		} else if ("conf".endsWith(layer)) {
			mask = "$path/$project-view/src/main/webapp/WEB-INF/$name";
		} else if ("web-inf".endsWith(layer)) {
			mask = "$path/$project-view/src/main/webapp/WEB-INF/$dir/$name";
		} else if ("meta-inf".endsWith(layer)) {
			mask = "$path/$project-impl/src/main/resources/META-INF/$dir/$name";
		} else if ("part".endsWith(layer)) {
			mask = "$path/$project-view/src/main/webapp/part/$dir/$name";
		} else if ("test".endsWith(layer)) {
			mask = "$path/$project-view/src/test/java/$dir/$name";
		} else if ("rest".endsWith(layer)) {
			mask = "$path/$project-view/src/main/java/$dir/$name";
		} else if ("serv".endsWith(layer)) {
			mask = "$path/$project-serv/src/main/java/$dir/$name";
		} else if ("data".endsWith(layer)) {
			mask = "$path/$project-serv/src/main/java/$dir/data/$name";
		} else if ("filter".endsWith(layer)) {
			mask = "$path/$project-serv/src/main/java/$dir/filter/$name";
		} else if ("impl".endsWith(layer)) {
			mask = "$path/$project-impl/src/main/java/$dir/$name";
		} else if ("entity".endsWith(layer)) {
			//mask = "$path/$project-impl/src/main/java/$dir/$name";
			mask = "$path/$project-local/src/main/java/$dir/$name";
		} else if ("local".endsWith(layer)) {
			mask = "$path/$project-local/src/main/java/$dir/$name";
		}
		
		mask = mask.replace("$path", path);
		mask = mask.replace("$project", project);
		mask = mask.replace("$dir", dir);
		if (temporal) {
			mask = mask.replace("$name", "temp/" + name);
		} else {
			mask = mask.replace("$name", name);
		}
		mask = mask.replace("//", "/");
		return mask;
	}

	public File createTempFile(String fileName) {
		File file = new File(root, "/target/" + fileName + ".xml");
		File parent = file.getParentFile();
		if (!parent.exists()) {
			parent.mkdirs();
		}
		return file;
	}

	public void setForceOverwriter(boolean b) {
		forceOverwriter = b;
	}

	public boolean getForceOverwriter() {
		return forceOverwriter;
	}

	public void include(String name) {
		include.add(name);
	}

	public void exclude(String name) {
		exclude.add(name);
	}

	public List<String> getInclude() {
		return include;
	}

	public List<String> getExclude() {
		return exclude;
	}

	public void setTemploral(boolean b) {
		temporal = b;
	}

	public boolean getTemploral() {
		return temporal;
	}

	public String getPackageLib() {
		return packageLib;
	}

	public void setPackageLib(String packageLib) {
		this.packageLib = packageLib;
	}
}