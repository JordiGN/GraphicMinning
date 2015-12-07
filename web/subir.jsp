

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
                
                File archivo_server = new File("C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/subidos/"+item.getName());
                /*y lo escribimos en el servido*/                
                item.write(archivo_server);
                nombre = item.getName();
                tipo = item.getContentType();                
            }                       
        }
        String s = new String();
        String aux = new String();
        aux ="";
        StringBuffer sb = new StringBuffer();
        FileReader fr = new FileReader(new File("C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/subidos/"+nombre));
     // be sure to not have line starting with "--" or "/*" or any 
     // other non aplhabetical character
        BufferedReader br = new BufferedReader(fr);
        //Patron de coincidencias
        //para saber que tabla es
	String tabla="\\W{1}\\w+\\W{1}";//Insert into y nombre de la tabla
        //Saber las cabecersas del archivo
        String columnas = "(\\W{1}\\w+\\W+)+";
        //Los datos en el archivo
        String datos="(\\W{0,2}\\w+\\W{0,2})+";                        
        //variable para analizar las coincidencias
        Pattern r = Pattern.compile("(INSERT INTO ("+tabla+") \\W{1}("+columnas+")\\W{1} "
                + "VALUES[(]("+datos+")([),]|[);]))");
        //Pattern cols= Pattern.compile(columnas); 
        //Pattern dat= Pattern.compile(datos); 
         
        //Se lee todo el documento y se concatena en una variable auxiliar
        //desde ahi se pasara la cadena a anaizar
        while((s = br.readLine()) != null){                          
            aux+=s;            
        }                   
        //Se asigna la cadena al analizador
        Matcher m = r.matcher(aux);   
        
        /*while (m.find()) {
                 out.print(m.group(0));
                //Pequenio ciclo para poder ver los nombres de las columnas
                /*String[] cab=m.group(3).split("[,]");
                for (int ii=0;ii<cab.length;ii++){
                          out.print("cabecera "+ cab[ii]);
                          out.print("<br>");
                          //csvOutput.write(cab[ii]);
                  }                
                //finaliza record para salto de linea
                //csvOutput.endRecord();                            
                out.print("<br>");                   
                //las coincidencias con los datos son separadas por los parentesis, para que solo quede la
                //información dentro de los parentesis
                //out.print(m.group(5));
                String[] cols = m.group(5).split("[()]"); 
                //como aun quedan "," estas se ignoran yendo de par en par desde el 0 hasta n
                for (int i=0;i<cols.length;i++){                    
                       if(i%2==0){
                            //Cada que lee una linea de coincidencia par la separa por comas para obtener
                           //el valor individual
                            String [] cols2= cols[i].split("[,]"); 
                            int auxi=cols2.length;
                            out.print("<br>");                            
                            for (int ii=0;ii<auxi;ii++){
                                out.print("Columnas "+ cols2[ii]);
                                out.print("<br>");
                                //csvOutput.write(cols2[ii]);
                            };
                            //una vez recorrida la linea de coincidencia y escrita se cierrra registro para
                            //salto de linea
                            //csvOutput.endRecord(); 
                            out.print("<br>");
                       }                       
                }                                             
            }*/       
        
        //se obtiene el nmbre del archivo para hacer el CSV, con un split para quitar la extensión
        String[] nombrearchivo = nombre.split(".sql");
        //out.print(nombrearchivo[0]);
       //Se crea la el archivo con extensión CSV en la ruta especificada
        String outputFile = "C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/csv/"+nombrearchivo[0]+".csv";
        //Si esta el archivo lo sobreescribe
        boolean alreadyExists = new File(outputFile).exists();         
        if(alreadyExists){
            File ficheroUsuarios = new File(outputFile);
            ficheroUsuarios.delete();
        }   
        //Metodo para escribir el archivo
        try {
            
            CsvWriter csvOutput = new CsvWriter(new FileWriter(outputFile, true), ',');
            while (m.find()) {
                //Pequenio ciclo para poder ver los nombres de las columnas
                String[] cab=m.group(3).split("[,]");
                for (int ii=0;ii<cab.length;ii++){
                          //out.print("cabecera "+ cab[ii]);
                          //out.print("<br>");
                          csvOutput.write(cab[ii]);
                  }                
                //finaliza record para salto de linea
                csvOutput.endRecord();                            
                out.print("<br>");                   
                //las coincidencias con los datos son separadas por los parentesis, para que solo quede la
                //información dentro de los parentesis
                String[] cols = m.group(5).split("[()]"); 
                //como aun quedan "," estas se ignoran yendo de par en par desde el 0 hasta n
                for (int i=0;i<cols.length;i++){                    
                       if(i%2==0){
                            //Cada que lee una linea de coincidencia par la separa por comas para obtener
                           //el valor individual
                            String [] cols2= cols[i].split("[,]"); 
                            int auxi=cols2.length;
                            out.print("<br>");                            
                            for (int ii=0;ii<auxi;ii++){
                                //out.print("Columnas "+ cols2[ii]);
                                //out.print("<br>");
                                csvOutput.write(cols2[ii]);
                            };
                            //una vez recorrida la linea de coincidencia y escrita se cierrra registro para
                            //salto de linea
                            csvOutput.endRecord(); 
                            out.print("<br>");
                       }                       
                }                                              
            }
            csvOutput.close();           
        } catch (IOException e) {
            e.printStackTrace();
        }     
        
        
        String sourcepath = "C:\\Users\\KissPK\\Teconlogico\\9no\\Inteligencia Artificial\\GraphicMinningV1\\csv\\"+nombrearchivo[0]+".csv";
        String destpath = "C:\\Users\\KissPK\\Teconlogico\\9no\\Inteligencia Artificial\\GraphicMinningV1\\arff\\"+nombrearchivo[0]+".arff";
        String argumento =sourcepath+","+destpath;
//        out.print(argumento); 

        
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
        
         //response.sendRedirect("http://localhost:8080/GraphicMinning/");                   
         
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/style.css" type="text/css"><link>
        <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css"><link>
        <title>Graphic Minning</title>
    </head>
    <body>
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
                                El archivo que elegiste es: <%=nombrearchivo[0] %>
                            </p>                          
                        </div>
                        <div class="col-lg-8">                            
                            <form>
                                <label class="col-lg-3" for="metodo2">Atributos</label>
                                <div class="col-lg-9"> 
                     
                                    <!--<selectOneListbox value="opcion" id="atributo" class="form-control">
                                        <selectItem itemValue="opcion" itemLabel="bla"/>
                                        <selectItem itemValue="opcion1" itemLabel="Opcion1"/>
                                        <selectItem itemValue="opcion2" itemLabel="Opcion2"/>
                                        <selectItem itemValue="opcion3" itemLabel="Opcion3"/>                                                                      
                                    </selectOneListbox>-->
                                </div>
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
                            <?php foreach ($datos_actuales as $datos_actualess) {
                              # code...
                            } ?>
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
