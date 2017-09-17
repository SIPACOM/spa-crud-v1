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
		optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_IMPORTS, "1");
		optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_AFTER_IMPORTS, "1");
		optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_FIRST_CLASS_BODY_DECLARATION, "1");
		optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_METHOD, "1");
		optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_TAB_SIZE, "1");
		optionsJAVA.put(DefaultCodeFormatterConstants.FORMATTER_TAB_CHAR, JavaCore.SPACE);
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
			if (name.endsWith(".java")) {
				code = doFormatJava(code);
			} else if (name.endsWith(".js")) {
				code = doFormatJS(code);
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

}
