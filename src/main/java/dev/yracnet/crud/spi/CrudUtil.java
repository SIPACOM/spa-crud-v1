/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.yracnet.crud.spi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.xml.dtm.ref.DTMNodeIterator;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 *
 * @author wyujra
 */
public class CrudUtil {

	private static final List<String> prefixList = new ArrayList();

	static {
		prefixList.add("Seg");
		prefixList.add("Par");
		prefixList.add("Xxx");
	}

	public static void addRemovePrefix(String prefix) {
		prefixList.add(prefix);
	}

	public static String removePrefix(String name) {
		if (name != null) {
			for (String prefix : prefixList) {
				if (name.matches("^" + prefix + "[A-Z].*")) {
					name = name.replace(prefix, "");
					break;
				}
			}
		}
		return name;
	}

	public static String className(String name) {
		return removePrefix(name);
	}

	public static String className(String name, String sufix) {
		return removePrefix(name) + sufix;
	}

	public static String varName(String name) {
		name = removePrefix(name);
		return name.toLowerCase().charAt(0) + name.substring(1);
	}

	public static String accName(String name) {
		name = removePrefix(name);
		return name.toUpperCase().charAt(0) + name.substring(1);
	}

	public static String varType(String name) {
		return varType(name, null, null);
	}

	public static String varType(String name, String template) {
		return varType(name, template, null);
	}

	public static String varType(String name, String template, String enumType) {
		if (name == null || name.isEmpty()) {
			name = "String";
		}
		if ("int".equals(name)) {
			name = "Integer";
		} else if ("java.util.Date".equals(name)) {
			name = "Date";
		} else if ("long".equals(name)) {
			name = "Long";
		} else if ("float".equals(name)) {
			name = "Float";
		} else if ("double".equals(name)) {
			name = "Double";
		} else if ("char".equals(name)) {
			name = "Character";
		}
		if (template != null && !template.isEmpty()) {
			if (name.contains(".")) {
				name = "String";
			}
			name = template + "<" + name + ">";
		} else if (enumType != null && !enumType.isEmpty()) {
			name = "CodeString";
		}
		return name + " ";
	}

	public static String template(String name) {
		return "<" + name + ">";
	}

	public static String packagePath(String _pack, String sub) {
		return (_pack + "." + sub).replace(".", "/");
	}

	public static String packagePath(String _pack) {
		return _pack.replace(".", "/");
	}

	public static String classExtend(String name, String other) {
		name = removePrefix(name);
		other = removePrefix(other);
		if (other != null && !other.isEmpty()) {
			name = name + " extends " + other;
		} else {
			name = name + " extends PoliceBase ";
		}
		return name;
	}

	public static String literal(String name) {
		name = translate(name);
		name = name.replaceAll("([A-Z][a-z]+)", " $1")
										.replaceAll("([A-Z][A-Z]+)", " $1")
										.replaceAll("([^A-Za-z ]+)", " $1")
										.trim();
		return name.toUpperCase().charAt(0) + name.substring(1);
	}

	public static boolean process(String name) {
		return process(name, new ArrayList(), new ArrayList());
	}

	public static boolean process(String name, List include) {
		return process(name, include, new ArrayList());
	}

	public static boolean process(String name, List includeList, List excludeList) {
		System.out.println("==========generate=====================" + name + " - " + includeList + " - " + excludeList);
		if (name == null || name.endsWith("List")) {
			return false;
		}
		boolean all = includeList.isEmpty() && excludeList.isEmpty();
		//System.out.println("all: " + name + " in " + all);
		if (all) {
			return true;
		}
		boolean exclude = excludeList.contains(name);
		//System.out.println("exclude: " + name + " in " + excludeList + " = " + exclude);
		if (exclude) {
			return false;
		}
		boolean include = includeList.contains(name);
		//System.out.println("include: " + name + " in " + includeList + " = " + include);
		if (include) {
			return true;
		}
		boolean resp = false;//(all || (include && !exclude));
		//System.out.println("-->" + resp);
		return resp;
	}

	public static String eval(String val1, String val2, String val3) {
		val1 = eval(val1, val2);
		return eval(val1, val3);
	}

	public static String eval(String val1, String val2) {
		return val1 == null || val1.isEmpty() ? val2 : val1;
	}

	public static String upper(String val) {
		return val == null ? null : val.toUpperCase();
	}

	public static String lower(String val) {
		return val == null ? null : val.toLowerCase();
	}

	public static String log(String a) {
		System.out.println("LOG=>" + a);
		return "";
	}

	public static boolean compare(String a, String b) {
		System.out.println("=>" + a + "==" + b);
		if (a != null && b != null) {
			return a.equals(b);
		}
		return false;
	}

	public static boolean showUI(String name) {
		if (name != null) {
			System.out.println("--->" + name);
			return !name.endsWith("List") && !name.endsWith("Ref");
		}
		return false;
	}

	public static boolean generate(String name, Object dom) {
		if (name == null) {
			System.out.println("NO SUPORT-->" + name + " : " + dom);
			return false;
		}
		Element elem = null;
		if (dom instanceof DTMNodeIterator) {
			DTMNodeIterator a = (DTMNodeIterator) dom;
			elem = (Element) a.getRoot();
		}
		if (elem == null) {
			System.out.println("NO SUPORT-->" + name + " : " + dom);
			return false;
		}
		NodeList idList = elem.getElementsByTagNameNS("http://java.sun.com/xml/ns/persistence/orm", "id");
		String _class = elem.getAttribute("class");
		String _abs = elem.getAttribute("abs");
		String _superclassId = elem.getAttribute("superclassId");
		System.out.println("===============================" + name);
		System.out.println("class: " + _class);
		System.out.println("superclassId: " + _superclassId);
		System.out.println("abs: " + _abs);
		switch (name) {
			case "IMPL-ABS":
			case "SERV-ABS":
			case "REST-ABS":
				return idList.getLength() == 0 && "true".equals(_abs);
			case "IMPL":
			case "SERV":
			case "REST":
				return idList.getLength() != 0 || (_superclassId.isEmpty() && "false".equals(_abs));
			case "LOCAL":
				return "false".equals(_abs);
		}
		return false;
	}

	private static String translate(String name) {
		return translateMap.containsKey(name) ? translateMap.get(name) : name;
	}
	private static final Map<String, String> translateMap = new HashMap<>();

	static {
		translateMap.put("name", "nombre");
		translateMap.put("description", "descripcion");
		translateMap.put("value", "valor");
		translateMap.put("type", "tipo");
		translateMap.put("status", "estado");
	}
}
