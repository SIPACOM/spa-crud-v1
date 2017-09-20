/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.yracnet.crud.spi.format;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

/**
 *
 * @author wyujra
 */
public class FormatXML {

	public static String format(String htmlString, Boolean ommitXmlDeclaration) throws Exception {
		Document doc = Jsoup.parseBodyFragment(htmlString);
		String body = doc.body().html();
		body = body.replace("&amp;", "&");
		return body;
	}
}
