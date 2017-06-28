/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.yracnet.crud.spi;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author wyujra
 */
public class CrudUtil {

	public static String removePrefix(String name) {
		return name == null ? null : name.replace("Rpt", "").replace("rpt", "");
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
		}
		return name;
	}

	public static String literal(String name) {
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

}
