/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.yracnet.crud.spi.format;

import dev.yracnet.crud.spi.CrudException;

/**
 *
 * @author yrac
 */
public interface Format {

	public String doFormat(String code, String name) throws CrudException;

	public String doFormatJava(String code) throws Exception;
}
