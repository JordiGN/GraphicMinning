/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clases;
/**
 *
 * @author KissPK
 */
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.SQLException;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletResponse;

public class converter{       
    
    public void exportExcelData(StringBuffer sb) {
        byte[] csvData = sb.toString().getBytes();
        FacesContext context = FacesContext.getCurrentInstance();
        HttpServletResponse response = (HttpServletResponse) FacesContext
        .getCurrentInstance().getExternalContext().getResponse();
        response.setHeader("Content-disposition",
        "attachment; filename=convertido.csv");
        response.setContentLength(sb.length());
        response.setContentType("text/csv");
        try {
            response.getOutputStream().write(csvData);
            response.getOutputStream().flush();
            response.getOutputStream().close();
            context.responseComplete();
        } 
        catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
        }
    }
}
/* Primer comentario
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
/**
 *
 * @author KissPK
 */ 
/*public class converter {   Comentarios
    public static void main(String[] args, String direccion) {
        DBase db = new DBase();
        Connection conn = db.connect(
                "jdbc:mysql://localhost:3306/test","root","caspian");
         
        if (args.length != 1) {
            System.out.println(
                    "Usage: java automateExport [outputfile path] ");
            return;
        }
        db.exportData(conn,args[0]);
    }     
}
 
class DBase {
    public DBase() {
    }
     
    public Connection connect(String db_connect_str, 
            String db_userid, String db_password) {
        Connection conn;
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection(db_connect_str,
                    db_userid, db_password);
             
        } catch(Exception e) {
            e.printStackTrace();
            conn = null;
        }
        return conn;
    }
     
    public void exportData(Connection conn,String filename) {
        Statement stmt;
        String query;
        try {
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
             
            //For comma separated file
            query = "SELECT * into OUTFILE  '"+filename+
                    "' FIELDS TERMINATED BY ',' FROM testtable t";
            stmt.executeQuery(query);
             
        } catch(Exception e) {
            e.printStackTrace();
            stmt = null;
        }
    }
};
Ultima llave de comentario*/
