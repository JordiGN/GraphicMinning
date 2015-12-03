
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
                + "VALUES\\W{1}("+datos+")([),]|[);]))");
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
                out.print("Cabeceras"+  m.group(3)); 
                String[] cab=m.group(3).split("[,]");
                for (int ii=0;ii<cab.length;ii++){
                          out.print("cabecera "+ cab[ii]);
                          out.print("<br>");
                  }
                //csvOutput.write(m.group(3));
                //csvOutput.endRecord(); 
                //datosfile.add(m.group(3));            
                out.print("<br>");            
                //out.print("Columnas "+ m.group(5));
                String[] cols = m.group(5).split("[)(]");
                for (int i=0;i<cols.length;i++){
                       if(i%2==0){
                            //out.print("Columnas "+ cols[i]);
                            String [] cols2= cols[i].split("[,]"); 
                            int auxi=cols2.length;
                            out.print("<br>");                            
                            for (int ii=0;ii<auxi-1;ii++){
                                out.print("Columnas "+ cols2[ii]);
                                out.print("<br>");
                            };
                            //csvOutput.write(cols[i]);
                            //csvOutput.endRecord(); 
                            out.print("<br>");
                       }
                       //datosfile.add(cols[i]);
                }
                //datosfile.add(m.group(5));                                
            }*/
        
        //se obtiene el nmbre del archivo para hacer el CSV, con un split para quitar la extensión
        String[] nombrearchivo = nombre.split(".sql");
        out.print(nombrearchivo[0]);
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
                //out.print("Cabeceras"+  m.group(3)); 
                String[] cab=m.group(3).split("[,]");
                for (int ii=0;ii<cab.length;ii++){
                          out.print("cabecera "+ cab[ii]);
                          out.print("<br>");
                          csvOutput.write(cab[ii]);
                  }
                //csvOutput.write(m.group(3));
                csvOutput.endRecord(); 
                //datosfile.add(m.group(3));            
                out.print("<br>");            
                //out.print("Columnas "+ m.group(5));
                String[] cols = m.group(5).split("[()]");
                
                for (int i=0;i<cols.length;i++){
                    
                       if(i%2==0){
                            //out.print("Columnas "+ cols[i]);
                            //out.print("<br>");  
                            String [] cols2= cols[i].split("[,]"); 
                            int auxi=cols2.length;
                            out.print("<br>");                            
                            for (int ii=0;ii<auxi;ii++){
                                out.print("Columnas "+ cols2[ii]);
                                out.print("<br>");
                                csvOutput.write(cols2[ii]);
                            };
                            //csvOutput.write(cols[i]);
                            csvOutput.endRecord(); 
                            out.print("<br>");
                       }                       
                }                                              
            }
            csvOutput.close();           
        } catch (IOException e) {
            e.printStackTrace();
        }          
        
        /*String archivoarff = "C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/csv/"+nombrearchivo[0]+".arff";
        String argumento =archivoarff+","+outputFile;
        String[] args = argumento.split(",");
        
                
                
                CSV2Arff convertirARFF = new CSV2Arff();
                CSV2Arff.main(args);    */                          
%>
