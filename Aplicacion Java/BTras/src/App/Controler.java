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

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;

import java.sql.Connection;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

/**
 *
 * @author Oscaiito
 */
public class Controler {

    private Connection cc;
    private boolean disable = true;
    private ResultSet rs = null;
    private Statement st = null;

    public Controler(Connection c) {
        try {
            if (c != null) {
                this.cc = c;
                this.disable = false;
                this.st = cc.createStatement();
            } else {
                this.error("No se puede inicializar el controlador."
                        + " Verifique que se tenga una conexion a la base de datos.", "Error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            error("Conexion interrumpida, reinicie la aplicacion.", "Connection lost");
        }

    }

    /**
     * *
     * @param table Nombre de la tabla
     * @param key {Nombre del campo, Valor del camp}
     * @param value Nombre del campo o Cadena de campos
     * @return
     */
    public ResultSet makeQuery(String table, String key[], String value) {
        if (disable) {
            error("No se tiene una conexion a la base de datos", "Connection unavalible");
        }
        String stq;
        if (key == null) {
            stq = "SELECT " + value + " FROM " + table;
        } else {
            stq = "SELECT " + value + " FROM " + table + " WHERE " + key[0] + " = " + key[1];
        }

        try {
            rs = st.executeQuery(stq);

        } catch (Exception e) {
            //e.printStackTrace();
            error(stq + " no es una consulta valida.", "Bad Statment");
            this.disable = true;
        }
        return rs;
    }

    public boolean isEnable() {
        return !this.disable;
    }

    private void error(String msg, String winLabel) {
        JOptionPane.showMessageDialog(new JFrame(), msg, winLabel, JOptionPane.ERROR_MESSAGE);
        System.exit(0);
    }

    public static void main(String args[]) {
        Controler c = new Controler(null);
    }

}
