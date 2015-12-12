<%@page import="org.jfree.chart.plot.PlotOrientation"%>
<%@page import="org.jfree.chart.JFreeChart"%>
<%@page import="org.jfree.chart.ChartFactory"%>
<%@page import="org.jfree.chart.ChartFactory"%>
<%@page import="org.jfree.data.category.DefaultCategoryDataset"%>
<%@page import="weka.classifiers.Evaluation"%>
<%@page import="weka.classifiers.Evaluation"%>
<%@page import="weka.classifiers.bayes.NaiveBayes"%>
<%@page import="javax.swing.JFrame"%>
<%@page import="org.jfree.chart.ChartPanel"%>
<%@page import="java.lang.String"%>
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
        HttpSession sesionOk = request.getSession();
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
               }
            fw.flush();
            fw.close();                   
        } catch (Exception e) {
            e.printStackTrace();
        }        
        Statement stmt2 = conexion.createStatement();                       
        String sql = "DROP TABLE "+nombrearchivo[0];
        stmt2.executeUpdate(sql); 
        conexion.close();     
            
        
        String sourcepath = "C:\\Users\\KissPK\\Teconlogico\\9no\\Inteligencia Artificial\\GraphicMinningV1\\csv\\"+nombrearchivo[0]+".csv";
        String destpath = "C:\\Users\\KissPK\\Teconlogico\\9no\\Inteligencia Artificial\\GraphicMinningV1\\arff\\"+nombrearchivo[0]+".arff";        
         // load CSV               
         CSVLoader loader = new CSVLoader();
         loader.setSource(new File(sourcepath));
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
        
        sesionOk.removeAttribute("arff");                
        sesionOk.setAttribute("arff",destpath);   
        
        
%>
<html>

    <head>                            
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
    <section class="content">
     <div class="container-fluid">
             <div class="col-lg-12 r1" id="r1">
                 <h1>Bienvenido a GraphicMinning</h1>
             </div>
             <div class="col-lg-12 pform">                        
                 <div class="col-lg-4">
                     <!--Lo real mente importante es en el formulario decir -->
                     <!--que van archivos con el enctype igual a MULTIPART/FORM-DATA -->                            
                     <h3>El archivo que elegiste es: <%=nombrearchivo[0] %> </h3> 

                 </div>
                 <div class="col-lg-8">                            
                     <form action="graficas.jsp"  enctype="MULTIPART/FORM-DATA" method="GET">
                         <input type="hidden" id="arff" name="arff" value="<%=destpath%>">                                
                         <h3>Atributos:</h3>
                         <%for(int i=0;i<atributos.size();i++){%> 
                            <label for='tipo' class="col-lg-3"><%=atributos.get(i).toString()+","+training_data.attribute(i).type()%></label>                              
                          <%}%>                                                    
                     </form>                                                                   
                 </div>                                      
             </div>
             <div class="col-lg-12">
                 <div class='col-lg-6'>
                    <form action="crossValidation.jsp"  enctype="MULTIPART/FORM-DATA" method="GET">
                         <input type="hidden" id="arff" name="arff" value="<%=destpath%>">                                
                         <label class="col-lg-3" for="metodo2">CrossValidation</label>
                         <div class="col-lg-6">                                                                                                                  
                            <input type="submit" value="Ver Gráfica" class="btn btn-success"/>
                         </div> 
                     </form>       
                 </div>
                 <div class='col-lg-6'>
                     <form action="crossDetail.jsp"  enctype="MULTIPART/FORM-DATA" method="GET">
                         <input type="hidden" id="arff" name="arff" value="<%=destpath%>">                                
                         <label class="col-lg-3" for="metodo2">CrossDetailValidation</label>
                         <div class="col-lg-6">                                                                                                                  
                            <input type="submit" value="Ver Gráfica" class="btn btn-success"/>
                         </div> 
                     </form>   
                                 
                 </div>
                <div class='col-lg-6'>
                    <form action="graficas.jsp"  enctype="MULTIPART/FORM-DATA" method="GET">
                         <input type="hidden" id="arff" name="arff" value="<%=destpath%>">                                
                         <label class="col-lg-3" for="metodo2">CrossValidation</label>
                         <div class="col-lg-6">                                                                                                                  
                            <input type="submit" value="Ver Gráfica" class="btn btn-success"/>
                         </div> 
                     </form>   
                </div>
             </div>
     </section>
    </body>        
</html>