/*
 * Copyright (C) 2015 Oscaiito
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package App;

import java.security.*;
import java.security.spec.InvalidKeySpecException; 
import javax.crypto.Cipher; 
import javax.crypto.spec.SecretKeySpec; 
import javax.crypto.*;

/**
 * Clase para cifrar o descifrar texto plano mediante el sistema AES.
 */
public class Crypter{ //Stands for crypt-er ... lol    
    private static final String algorithm = "AES";
    private Cipher cipher;

    /**
     * Constructor, inicializa  el nuclo de encriptacion de java.
     */
    public Crypter(){
	try{
	    cipher = Cipher.getInstance(algorithm);
	}catch(Exception e){}
    }

    /**
     * Obtiene el texto cifrado como arreglo de bites.
     * @param customKey es la clave de encriptacion, esta puede ser de 16 o 32 bits.
     * @param text es el texto a encryptar.
     * @return texto encriptado como arreglo de bites.
     */
    public byte[] encrypt(byte[] customKey, String text)throws  BadPaddingException, InvalidKeyException, InvalidKeySpecException, IllegalBlockSizeException{	        
	if(customKey.length == 32)
	    cipher.init(Cipher.ENCRYPT_MODE, getKey(customKey));
	else if(customKey.length == 16)
	    cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(customKey, algorithm));
	else
	    throw new InvalidKeySpecException(); //En caso de que la clave no cumpla las especificaciones de longitud        
	return cipher.doFinal(text.getBytes());	
    }

    /**
     * Obtiene el texto descifrado como arreglo de bites.
     * @param customKey es la clave de encriptacion, esta puede ser de 16 o 32 bits.
     * @param cipherText es el texto a descifrar.
     * @return texto descifrado como arreglo de bites.
     */
    public byte[] decrypt(byte[] customKey, byte[] cipherText)throws BadPaddingException, InvalidKeyException, InvalidKeySpecException, IllegalBlockSizeException {	
	if(customKey.length == 32)
	    cipher.init(Cipher.DECRYPT_MODE, getKey(customKey));
	else if(customKey.length == 16)
	    cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(customKey, algorithm));
	else
	    throw new InvalidKeySpecException();	
	return cipher.doFinal(cipherText);
    }    
    
    // Obtiene los primeros 16 bits de una clave de 32, ya que AES trabaja con 128bits
    private SecretKeySpec getKey(byte[] key){	
	byte[] midKey = new byte[16];
        System.arraycopy(key, 0, midKey, 0, 16);
	return new SecretKeySpec(midKey, algorithm);
    }   
}
