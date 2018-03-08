/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.yracnet.crud.spi.format;

import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.JavaFormatterOptions;
import dev.yracnet.crud.spi.CrudException;

/**
 *
 * @author yrac
 */
public class GoogleFormat implements Format {

	@Override
	public String doFormat(String code, String name) throws CrudException {
		try {
			if (name.endsWith(".java")) {
				code = doFormatJava(code);
			}
		} catch (CrudException e) {
			throw e;
		} catch (Exception e) {
			throw new CrudException(e.getLocalizedMessage(), e);
		}
		return code;
	}

	@Override
	public String doFormatJava(String code) throws Exception {
		JavaFormatterOptions options = JavaFormatterOptions.builder().style(JavaFormatterOptions.Style.AOSP).build();		
		Formatter formatter = new Formatter(options);
		code = formatter.formatSource(code);
		return code;
	}

}
