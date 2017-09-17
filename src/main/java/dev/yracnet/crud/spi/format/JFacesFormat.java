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

	private final CodeFormatter formatter;

	public JFacesFormat() {
		Map<String, String> options = new HashMap<>();
		options.put(JavaCore.COMPILER_SOURCE, "1.8");
		options.put(JavaCore.COMPILER_COMPLIANCE, "1.8");
		options.put(JavaCore.COMPILER_CODEGEN_TARGET_PLATFORM, "1.8");
		options.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_IMPORTS, "1");
		options.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_AFTER_IMPORTS, "1");
		options.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_FIRST_CLASS_BODY_DECLARATION, "1");
		options.put(DefaultCodeFormatterConstants.FORMATTER_BLANK_LINES_BEFORE_METHOD, "1");
		options.put(DefaultCodeFormatterConstants.FORMATTER_TAB_SIZE, "1");
		options.put(DefaultCodeFormatterConstants.FORMATTER_TAB_CHAR, JavaCore.SPACE);
		this.formatter = ToolFactory.createCodeFormatter(options);
	}

	@Override
	public String doFormat(String code, String name) throws CrudException {
		try {
			if (name.endsWith(".java")) {
				code = doFormatJava(code);
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
			te = this.formatter.format(CodeFormatter.K_COMPILATION_UNIT, code, 0, code.length(), 0, "\n");
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

}
