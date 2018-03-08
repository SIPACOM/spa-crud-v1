/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.yracnet.crud.spi.format;

import dev.yracnet.crud.spi.CrudException;
import java.util.HashMap;
import java.util.Map;
import org.eclipse.jdt.core.JavaCore;
import org.eclipse.jdt.core.ToolFactory;
import org.eclipse.jdt.core.formatter.CodeFormatter;
import org.eclipse.jdt.core.formatter.DefaultCodeFormatterConstants;
import org.eclipse.jface.text.Document;
import org.eclipse.jface.text.IDocument;
import org.eclipse.text.edits.TextEdit;
import javax.xml.parsers.DocumentBuilderFactory;

/**
 *
 * @author yrac
 */
public class JFacesFormat implements Format {

	private final CodeFormatter formatterJAVA;
	private org.eclipse.wst.jsdt.core.formatter.CodeFormatter formatterJS;

	public JFacesFormat() {
		Map<String, String> optionsJAVA = new HashMap<>();
		optionsJAVA.put(JavaCore.COMPILER_SOURCE, "1.8");
		optionsJAVA.put(JavaCore.COMPILER_COMPLIANCE, "1.8");
		optionsJAVA.put(JavaCore.COMPILER_CODEGEN_TARGET_PLATFORM, "1.8");
		//optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_IMPORTS, "1");
		//optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_AFTER_IMPORTS, "1");
		//optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_FIRST_CLASS_BODY_DECLARATION, "1");
		//optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_METHOD, "1");
		//optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_TAB_SIZE, "3");
		//optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_TAB_CHAR, JavaCore.SPACE);

		optionsJAVA.put("org.eclipse.jdt.core.formatter.blank_lines_before_package", "0");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.blank_lines_after_package", "1");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.blank_lines_before_first_class_body_declaration", "1");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.lineSplit", "150");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.comment.line_length", "100");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.indentation.size", "1");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.tabulation.size", "1");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.continuation_indentation", "2");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.insert_space_after_at_in_annotation", "do not insert");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.compact_else_if", "true");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.number_of_empty_lines_to_preserve", "0");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.comment.format_html", "true");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.blank_lines_before_method", "1");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.blank_lines_between_type_declarations", "1");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.blank_lines_before_imports", "1");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.blank_lines_after_imports", "1");
		optionsJAVA.put("org.eclipse.jdt.core.formatter.blank_lines_between_import_groups", "1");

		formatterJAVA = ToolFactory.createCodeFormatter(optionsJAVA);
		
		Map<String, String> optionsJS = new HashMap<>();
		//optionsJS.put(org.eclipse.wst.jsdt.core.formatter.DefaultCodeFormatterConstants.FORMATTER_TAB_CHAR, " ");
		optionsJS.put(org.eclipse.wst.jsdt.core.formatter.DefaultCodeFormatterConstants.FORMATTER_TAB_SIZE, "1");
		optionsJS.put(org.eclipse.wst.jsdt.core.formatter.DefaultCodeFormatterConstants.FORMATTER_ALIGNMENT_FOR_MULTIPLE_FIELDS, "false");
		formatterJS = org.eclipse.wst.jsdt.core.ToolFactory.createCodeFormatter(optionsJS);
	}

	@Override
	public String doFormat(String code, String name) throws CrudException {
		try {
			System.out.println("--->" + name);
			if (name.endsWith(".java")) {
				code = doFormatJava(code);
			} else if (name.endsWith(".js")) {
				code = doFormatJS(code);
			} else if (name.endsWith(".html")) {
				code = doFormatHTML(code);
			}
		} catch (CrudException e) {
			throw e;
		} catch (Exception e) {
			System.out.println("Error Format: " + e.getLocalizedMessage());
			throw new CrudException(e.getLocalizedMessage(), e);
		}
		return code;
	}

	@Override
	public String doFormatJava(String code) throws Exception {
		TextEdit te;
		try {
			te = formatterJAVA.format(CodeFormatter.K_COMPILATION_UNIT, code, 0, code.length(), 0, "\n");
			if (te == null) {
				return null;
			}
		} catch (IndexOutOfBoundsException e) {
			return null;
		}
		IDocument doc = new Document(code);
		te.apply(doc);
		String formattedCode = doc.get();
		if (code.equals(formattedCode)) {
			return null;
		}
		return formattedCode;
	}

	public String doFormatJS(String code) throws Exception {
		TextEdit te;
		try {
			te = formatterJS.format(CodeFormatter.K_COMPILATION_UNIT, code, 0, code.length(), 0, "\n");
			if (te == null) {
				return "//NULL return" + "\n" + code;
			}
		} catch (IndexOutOfBoundsException e) {
			return "//ERROR: " + e.getLocalizedMessage() + "\n" + code;
		}
		IDocument doc = new Document(code);
		te.apply(doc);
		String formattedCode = doc.get();
		return formattedCode;
	}

	public String doFormatHTML(String code) throws Exception {
		try {
			code = FormatXML.format(code, Boolean.TRUE);
		} catch (Exception e) {
			return "//ERROR: " + e.getLocalizedMessage() + "\n" + code;
		}
		return code;
	}

}
