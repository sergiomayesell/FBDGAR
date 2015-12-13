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
import java.util.ArrayList;
import java.util.Map;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

/**
 *
 * @author Oscaiito
 */
public class Controler {

    private Connection cc;
    //private boolean disable = true;
    //private ResultSet rs = null;
    //private Statement st = null;

    public Controler(Connection c) {
        this.cc = c;
        requestStatement();
    }

    /**
     * *
     * @param table Nombre de la tabla
     * @param key {Nombre del campo, Valor del camp}
     * @param value Nombre del campo o Cadena de campos
     * @return
     */
    public ResultSet makeQuery(String table, String key[], String columnas[]) {
        if (!this.isEnable()) {
            error("No se cuenta con una conexion a la base de datos.");
            return null;
        }
        Statement st = this.requestStatement();
        //requestStatement();
        if (stClose(st)) {
            error("No statment found.");
            return null;
        }

        String stq, value = "", col, ref;
        for (int i = 0; i < columnas.length; i++) {
            value += columnas[i];
            if (i + 1 < columnas.length) {
                value += ", ";
            }
        }
        stq = "SELECT " + value + " FROM " + table;
        if (key != null) {
            stq = "SELECT " + value + " FROM " + table + " WHERE " + key[0] + " = ";
            if (key[0].charAt(0) == 's' || key[0].charAt(0) == 'd') {
                stq += "'" + key[1] + "'";
            } else {
                stq += key[1];
            }
        }
        ResultSet rs = null;
        try {
            rs = st.executeQuery(stq);

        } catch (Exception e) {
            //e.printStackTrace();
            error(stq + " no es una consulta valida.");
            //this.disable = true;
        }
        return rs;
    }

    public int insertTo(String table, Map<String, String> values) {
        if (!this.isEnable()) {
            error("No se cuenta con una conexion a la base de datos.");
            return -1;
        }
        String qry;
        try {
            
            String p = "INSERT INTO " + table + "(", s = ") VALUES (";
            for (String k : values.keySet()) {
                p += k + ",";
                s += "'" + values.get(k) + "',";
            }
            qry = p.substring(0, p.length() - 1) + s.substring(0, s.length() - 1) + ")";            
            Statement st = this.requestStatement();            
            if (stClose(st)) {
                error("No statment found.");
                return -1;
            }
            return st.executeUpdate(qry);
        } catch (Exception e) {
            print(e);
            return 0;
        }
        
    }

    public ResultSet makeQueryS(String qry) {
        print(qry);
        if (!this.isEnable()) {
            error("No se cuenta con una conexion a la base de datos.");
            return null;
        }
        Statement st = this.requestStatement();
        
        if (stClose(st)) {
            error("No statment found.");
            return null;
        }
        ResultSet rs = null;
        try {
            rs = st.executeQuery(qry);
        } catch (Exception e) {
            System.out.println(e);
            error("Upps somthing went wrong");
        }
        return rs;
    }

    public boolean isEnable() {
        return this.isActive();
    }

    private boolean isActive() {
        if (cc == null) {
            return false;
        }
        try {
            return cc.isValid(1);
        } catch (Exception e) {
            return false;
        }
    }

    private Statement requestStatement() {
        try {
            if (this.isEnable()) {
                return cc.createStatement();
            }
        } catch (Exception e) {
            error("No se puede crear Statmente de la conexcion actual.");

        }
        return null;
    }

    private void error(String msg) {
        //JOptionPane.showMessageDialog(new JFrame(), msg, winLabel, JOptionPane.ERROR_MESSAGE);
        System.err.println(msg);
        //System.exit(0);
    }

    private boolean stClose(Statement st) {
        try {
            if (st == null) {
                return true;
            }
            return st.isClosed();
        } catch (Exception e) {
            return true;
        }

    }

    private static void print(Object obj) {
        System.out.println(obj == null ? "null" : obj.toString());
    }

    public static void main(String args[]) {
        Controler c = new Controler(null);
    }

}
