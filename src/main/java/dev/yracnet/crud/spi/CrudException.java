/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.yracnet.crud.spi;

/**
 *
 * @author wyujra
 */
public class CrudException extends RuntimeException {

	public CrudException() {
		super();
	}

	public CrudException(String message) {
		super(message);
	}

	public CrudException(String message, Throwable cause) {
		super(message, cause);
	}

	public CrudException(Throwable cause) {
		super(cause);
	}

}
