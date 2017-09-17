/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.yracnet.crud.spi.format;

import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.FormatterException;
import com.google.googlejavaformat.java.JavaFormatterOptions;
import dev.yracnet.crud.spi.CrudException;

/**
 *
 * @author yrac
 */
public class GoogleFormat implements Format {

	@Override
	public String doFormat(String code, String name) throws CrudException {
		if (name.endsWith(".java")) {
			code = doFormatJava(code);
		}
		return code;
	}

	@Override
	public String doFormatJava(String code) {
		JavaFormatterOptions options = JavaFormatterOptions.builder().style(JavaFormatterOptions.Style.AOSP).build();
		Formatter formatter = new Formatter(options);
		try {
			code = formatter.formatSource(code);
		} catch (FormatterException e) {
			System.out.println("Error: " + e.getLocalizedMessage());
		}
		return code;
	}

}
