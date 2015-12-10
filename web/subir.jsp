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
            conexion.close();            
        } catch (Exception e) {
            e.printStackTrace();
        }        
        String query = "DROP TABLE"+nombrearchivo[0];
            Statement stmt = conexion.createStatement();
            ResultSet rs = stmt.executeQuery(query);
        
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
        
%>
<html>

    <head>
        
            <script type="text/javascript">
        
                //function mostrar( obj ){
                  //  alert("Entro "+obj);                        
                    //var id= 
                    //        document.getElementById('id').value=obj
                            //id.value=obj;  
                      //mostrar2();
                //}                                                                        
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
           <section class="content">
            <div class="container-fluid">
                    <div class="col-lg-12 r1" id="r1">
                        <h1>Bienvenido a GraphicMinning</h1>
                    </div>
                <div class="col-lg-1"></div>
                <div class="col-lg-10">                   
                    <div class="col-lg-12 pform">                        
                        <div class="col-lg-4">
                            <!--Lo real mente importante es en el formulario decir -->
                            <!--que van archivos con el enctype igual a MULTIPART/FORM-DATA -->
                            <p>
                                <!-- % //String archivo= new String(request.getParameter("archivo"));   %>
                                <!--El archivo que elegiste es: %=//archivo %>
                                -->
                            </p>                          
                        </div>
                        <div class="col-lg-8">                            
                            <form>
                                <label class="col-lg-3" for="metodo2">Atributos</label>
                                <div class="col-lg-9">                                    
                                    <select class="form-control" name="atributo" onchange="//mostrar(value);">                                        
                                        <option value="0" selected>Seleccione</option> 
                                        <%for(int i=0;i<atributos.size();i++){%> 
                                        <option value="<%=(i+1)%>"><%=atributos.get(i).toString()%></option> 
                                        <%}%>  
                                    </select>
                            </form>
                        </div>                                            
                    </div>    
                    <div class="col-lg-1"></div>
                    <div class="col-lg-5 pform">
                        <div class="col-lg-12">
                            <label>Selected Atribute</label>
                            <form>
                                <div class="col-lg-12">                                
                                    <div class="col-lg-6">
                                        <label>Nombre</label>
                                        <!--<inputText class="form-control" value=""/>-->
                                    </div>                                                               
                                    <div class="col-lg-6">
                                        <label>Tipo</label>
                                        <!--<inputText class="form-control" value=""/>-->
                                    </div>

                                </div>
                                <div class="col-lg-12">

                                    <div class="col-lg-6">
                                        <label>Missing</label>
                                        <!--<inputText class="form-control" value=""/>-->
                                    </div>                                                                
                                    <div class="col-lg-6">
                                        <label>Distinct</label>
                                        <!--<inputText class="form-control" value=""/>-->
                                    </div>                                                                                    
                                </div>
                                <div class="col-lg-12">                                
                                    <div class="col-lg-6">
                                        <label>Unique</label>
                                        <!--<inputText class="form-control" value=""/>-->                                
                                    </div>           
                                </div>
                            </form>
                           
                            <div class="col-lg-12">
                                <table class="table table-hover table-striped">
                                    <thead>
                                      <tr>
                                          <td><strong>Etiqueta</strong></td>
                                          <td><strong>Repeticiones</strong></td>
                                      </tr>
                                    </thead>
                                    <tbody>
                                      <tr>
                                        <td>datos</td>
                                        <td>datos</td>
                                      </tr>
                                      <tr>
                                        <td>datos</td>
                                        <td>datos</td>
                                      </tr>
                                      <tr>
                                        <td>datos</td>
                                        <td>datos</td>
                                      </tr>
                                    </tbody>
                                  </table>
                            </div>
                            
                        </div>                        
                    </div>
                    
                    <div class="col-lg-5 pform2">
                        <div class="col-lg-12">
                            <form>
                                <label class="col-lg-3" for="metodo2">Elige proceso</label>
                                <div class="col-lg-9"> 
                                    <select name="metodo2" class="form-control">
                                        <option value="">opciones</option>
                                        <option value="">opciones</option>
                                        <option value="">opciones</option>
                                        <option value="">opciones</option>
                                    </select>
                                </div>
                            </form>
                        </div>
                        <div class="col-lg-12">                           
                            <h1 align="center">Gráfica de proceso 2 <?php echo $datos_actualess  ['periodo'] ?></h1>
                            <div id="canvas-holder" align="center">
                                <canvas id="actuales" width="300" height="300"></canvas>                                
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-1"></div>
            </div>
        </section>
    </body>
        
</html>
