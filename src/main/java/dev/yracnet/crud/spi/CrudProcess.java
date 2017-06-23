package dev.yracnet.crud.spi;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Map;
import java.util.stream.Stream;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
//import javax.xml.parsers.DocumentBuilderFactory;
//import javax.xml.parsers.DocumentBuilder;
//import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class CrudProcess {

	final static String ENCODING = System.getProperty("encoding", "utf-8");

	public CrudProcess() {
	}

	public void process(CrudConfig crud) {
		crud.streamJPA().forEach(jpa -> {
			process(crud, jpa, crud.streamXSLT());
		});
	}

	private void process(CrudConfig crud, File model, Stream<File> xslt) {
		xslt.forEach(xsl -> {
			process(crud, model, xsl);
		});
	}

	private void process(CrudConfig crud, File model, File xsl) {
		try {
			final TransformerFactory factory = TransformerFactory.newInstance();
			final StreamSource styleSheet = new StreamSource(xsl);
			final Transformer transformer = factory.newTransformer(styleSheet);
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setParameter("packageBase", crud.getPackageBase());
			transformer.setParameter("project", crud.getProject());
			transformer.setParameter("path", crud.getPath());
			transformer.setParameter("app", crud.getApp());
			transformer.setParameter("mod", crud.getMod());
			transformer.setParameter("include", crud.getInclude());
			transformer.setParameter("exclude", crud.getExclude());
			File tempXML = crud.createTempFile(xsl.getName());
			StreamSource inputXml = new StreamSource(new InputStreamReader(new FileInputStream(model)));
			transformer.transform(inputXml, new StreamResult(tempXML));
			processResult(crud, tempXML);
			//inputXml = new StreamSource(new InputStreamReader(new FileInputStream(model)));
			//transformer.transform(inputXml, new StreamResult(System.out));
		} catch (IOException | IllegalArgumentException | TransformerException e) {
			e.printStackTrace();
		}
	}

	private void processResult(CrudConfig crud, File xml) {
		try {
			DocumentBuilder documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			Document document = documentBuilder.parse(xml);
			Element element = document.getDocumentElement();
			NodeList fileList = element.getChildNodes();
			int len = fileList.getLength();
			for (int i = 0; i < len; i++) {
				processResult(crud, fileList.item(i));
			}
		} catch (IOException | ParserConfigurationException | SAXException e) {
			e.printStackTrace();
		}
	}

	private void processResult(CrudConfig crud, Node xml) {
		if (xml.getNodeType() != 1) {
			return;
		}
		Element element = (Element) xml;
		String name = element.getAttribute("name");
		String dir = element.getAttribute("dir");
		String layer = element.getAttribute("layer");
		String realPath = crud.getRealPath(layer, dir, name);
		boolean isCode = name.endsWith(".java") || name.endsWith(".js") || name.endsWith(".css");
		String content = convertToString(xml, isCode);
		if (isCode) {
			if (name.endsWith(".java")) {
				String pack = dir.replace("/", ".");
				content = "package " + pack + ";\n" + content;
			}
			content = content.replaceAll("\n([\\s]+)", "\n").replaceAll("\n\n", "\n").trim();
		}
		try {
			File file = new File(realPath);
			File parent = file.getParentFile();
			if (!parent.exists()) {
				parent.mkdirs();
			}
			if (file.exists() == false) {
				System.out.println("WRITE--->" + realPath);
				Files.write(Paths.get(realPath), content.getBytes(), StandardOpenOption.CREATE);
			} else if (crud.getForceOverwriter() == true) {
				System.out.println("OVER WRITE--->" + realPath);
				file.delete();
				Files.write(Paths.get(realPath), content.getBytes(), StandardOpenOption.CREATE);
			} else {
				System.out.println("WRITE STOP--->" + realPath);
			}
		} catch (IOException e) {
			System.out.println("WRITE ERROR --->: " + realPath + " - <<" + content.replace("\n", "") + ">>");
		}
	}

	private String convertToString(Node doc, boolean isText) {

		InputStream print = CrudConfig.class.getResourceAsStream("/print/xml.xsl");
		if (isText) {
			print = CrudConfig.class.getResourceAsStream("/print/string.xsl");
		}
		StreamSource styleSheet = new StreamSource(print);
		DOMSource input = new DOMSource(doc);
		StringWriter sw = new StringWriter();
		StreamResult output = new StreamResult(sw);
		processXSLT(styleSheet, input, output, null);
		return sw.toString();
	}

	private void processXSLT(Source styleSheet, Source input, Result output, Map<String, Object> params) {
		try {
			final TransformerFactory factory = TransformerFactory.newInstance();
			final Transformer transformer = factory.newTransformer(styleSheet);
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			if (params != null) {
				for (Map.Entry<String, Object> item : params.entrySet()) {
					transformer.setParameter(item.getKey(), item.getValue());
				}
			}
			transformer.transform(input, output);
		} catch (IllegalArgumentException | TransformerException e) {
			throw new CrudException("Error al procesar el XSLT", e);
		}
	}

}
