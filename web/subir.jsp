<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="com.sun.xml.rpc.processor.modeler.j2ee.xml.string"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="javax.faces.context.FacesContext"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.*" %>
<%@ page import="java.io.*" %>
<%@page import="clases.converter" %>
<%@page import="clases.CSV2Arff" %>
<%@ page import="java.io.IOException" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.util.regex.*"%>
<%@page import="com.csvreader.CsvWriter" %>
<%@page  import="weka.core.Instances" %> 
<%@page import="weka.core.converters.ArffSaver"%>
<%@page import="weka.core.converters.CSVLoader" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>

<%@ page import="weka.classifiers.trees.J48" %>
<%@ page import="weka.experiment.InstanceQuery" %>
<%@ page import="weka.core.converters.*" %>
<%@ page import="weka.core.Instances" %>
<%@ page import="java.io.*" %>
<%@ page import="java.io.File.*" %>
<%@ page import ="java.util.ArrayList" %>
<%@ page import ="java.util.Arrays" %>
<%@ page import ="java.util.List" %>
<%@page import="clases.ScriptRunner"%>
<%@page import="clases.DBConexion"%>

<%
        /*FileItemFactory es una interfaz para crear FileItem*/
        FileItemFactory file_factory = new DiskFileItemFactory();
        /*ServletFileUpload esta clase convierte los input file a FileItem*/
        ServletFileUpload servlet_up = new ServletFileUpload(file_factory);
        /*sacando los FileItem del ServletFileUpload en una lista */
        List items = servlet_up.parseRequest(request);
        String nombre = "";
        String tipo = "";
 
        for(int i=0;i<items.size();i++){
            /*FileItem representa un archivo en memoria que puede ser pasado al disco duro*/
            FileItem item = (FileItem) items.get(i);
            /*item.isFormField() false=input file; true=text field*/
            if (! item.isFormField()){
                /*cual sera la ruta al archivo en el servidor*/
                String subir="C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/subidos/"+item.getName();
                
                File archivo_server = new File(subir);
                /*y lo escribimos en el servido*/  
                 
                item.write(archivo_server);
                nombre = item.getName();
                tipo = item.getContentType();                
            }                       
        }
        
        Connection conexion=null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
                String servidor="jdbc:mysql://www.webcolima.com/webcolim_graphicMinning";
                String usuario="webcolim_jordi";
                String contrasenia="Jord1";
                    conexion=(Connection)DriverManager.getConnection(servidor, usuario, contrasenia);
            } catch (ClassNotFoundException e) {
                System.err.println("Unable to get mysql driver: " + e);
            } catch (SQLException e) {
                System.err.println("Unable to connect to server: " + e);
            }
            ScriptRunner runner = new ScriptRunner(conexion, false, false);
            String file = "C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/subidos/"+nombre;
            runner.runScript(new BufferedReader(new FileReader(file)));
            String[] nombrearchivo = nombre.split(".sql");
            String outputFile = "C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/csv/"+nombrearchivo[0]+".csv";            
        try {
            FileWriter fw = new FileWriter(outputFile);
            /*Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");*/
            String query = "select * from "+nombrearchivo[0];
            Statement stmt = conexion.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            ResultSetMetaData rsmd = rs.getMetaData();
            fw.append(rsmd.getColumnName(1));
                for(int i=2;i<=rsmd.getColumnCount();i++)
                {                                     
                    fw.append(',');
                    fw.append(rsmd.getColumnName(i));                                       
                }  	
                fw.append('\n');
            while (rs.next()) {
                
                fw.append(rs.getString(1));
                for(int i=2;i<=rsmd.getColumnCount();i++)
                {                 
                    fw.append(',');
                    fw.append(rs.getString(i));                    
                }                             
                fw.append('\n');
                /*fw.append(rs.getString(1));
                fw.append(',');                
                fw.append(rs.getString(2));
                fw.append(',');
                fw.append(rs.getString(3));
                fw.append('\n');*/
               }
            fw.flush();
            fw.close();
            conexion.close();            
        } catch (Exception e) {
            e.printStackTrace();
        }
        /*String[] nombrearchivo = nombre.split(".sql");
        String outputFile = "C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/csv/"+nombrearchivo[0]+".csv";
        //Si esta el archivo lo sobreescribe
        boolean alreadyExists = new File(outputFile).exists();         
        if(alreadyExists){
            File ficheroUsuarios = new File(outputFile);
            ficheroUsuarios.delete();
        }   
        //Metodo para escribir el archivo
       
        

        
        
        //String argumento =sourcepath+","+destpath;
        
        boolean arffExists = new File(destpath).exists();           
        if(arffExists){
            File arffFile = new File(destpath);
            arffFile.delete();
        }*/
        //String sourcepath = "C:\\Users\\KissPK\\Teconlogico\\9no\\Inteligencia Artificial\\GraphicMinningV1\\csv\\"+nombrearchivo[0]+".csv";
        String destpath = "C:\\Users\\KissPK\\Teconlogico\\9no\\Inteligencia Artificial\\GraphicMinningV1\\arff\\"+nombrearchivo[0]+".arff";
        
         // load CSV               
         CSVLoader loader = new CSVLoader();
         loader.setSource(new File(outputFile));
         Instances data = loader.getDataSet();

         // save ARFF
         ArffSaver saver = new ArffSaver();
         saver.setInstances(data);
         saver.setFile(new File(destpath));
         //saver.setDestination(new File(destpath));
         saver.writeBatch();         
         
     
         Instances training_data = new Instances(new BufferedReader(
                new FileReader(destpath)));
        training_data.setClassIndex(training_data.numAttributes() - 1);  
        //Creamos la lista de los atributos seleccionados
        ArrayList<String> atributos = new ArrayList<String>();
        ArrayList<String> instancias = new ArrayList<String>();
        atributos.clear();
        instancias.clear();
        for(int i=0;i<training_data.numAttributes();i++){              
            atributos.add(training_data.attribute(i).name());
            
        }
        for(int i=0;i<training_data.numInstances();i++){              
            instancias.add(training_data.instance(i).toString());
            
        }
        
%>
<html>

    <head>
        
            <script type="text/javascript">
        
                function mostrar( obj ){
                    alert("Entro "+obj);                        
                    //var id= 
                            document.getElementById('id').value=obj
                            //id.value=obj;  
                      mostrar2();
                }                                                                        
            </script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/style.css" type="text/css"><link>
        <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css"><link>
        <title>Graphic Minning</title>
    </head>
    <body>
        <%
            if(DBConexion.conexion()!=null)
            {
                %>
                <p>La conexión se realizó de forma correcta</p>
                <%
            }
            else
            {
                %>
                <p>Hubo un error en la conexión</p>
                <%
            }
        %>
           
    </body>
        
</html>
