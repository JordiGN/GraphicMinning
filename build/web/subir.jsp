
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
        //Pattern p = Pattern.compile("(INSERT INTO*)(\\d+)");
	String tabla="\\W{1}\\w+\\W{1}";//Insert into y nombre de la tabla
        String columnas = "(\\W{1}\\w+\\W+)+";
        //String datos="(\\W?\\w+\\W{0,3})+";
        String datos="(\\W{0,2}\\w+\\W{0,2})+";        
                
        Pattern r = Pattern.compile("(INSERT INTO ("+tabla+") \\W{1}("+columnas+")\\W{1} "
                + "VALUES\\W{1}("+datos+")([),]|[);]))");
        //Pattern cols= Pattern.compile(columnas); 
        //Pattern dat= Pattern.compile(datos); 
         
         
        while((s = br.readLine()) != null){                          
            aux+=s;
            sb.append(s);            
        }
        String aux2="";
        List<String> datosfile = new ArrayList<String>();
        Matcher m = r.matcher(aux);
        while (m.find()) {
            
            out.print("Cabeceras"+  m.group(3));            
            //datosfile.add(m.group(3));            
            out.print("<br>");            
            //out.print("Columnas "+ m.group(5));
            String[] cols = m.group(5).split("[)]");
            for (int i=0;i<cols.length;i++){
                   out.print("Columnas "+ cols[i]); 
                   out.print("<br>"); 
                   //datosfile.add(cols[i]);
            }
            //datosfile.add(m.group(5));
            out.print("<br>");
            aux2+=m.group(0);           
        }  
        
        /*String[] nombrearchivo = nombre.split(".sql");
        out.print(nombrearchivo[0]);
       
        String outputFile = "C:/Users/KissPK/Teconlogico/9no/Inteligencia Artificial/GraphicMinningV1/csv/"+nombrearchivo[0]+".csv";
        boolean alreadyExists = new File(outputFile).exists();
         
        if(alreadyExists){
            File ficheroUsuarios = new File(outputFile);
            ficheroUsuarios.delete();
        }        
         
        try {
         
            CsvWriter csvOutput = new CsvWriter(new FileWriter(outputFile, true), ',');
            while (m.find()) {

               out.print("Cabeceras"+  m.group(3));            
               datosfile.add(m.group(3));            
               out.print("<br>");            
               out.print("Columnas "+ m.group(5));
               String[] cols = m.group(5).split("[),(]");
               for (int i=0;i<cols.length;i++){
                      datosfile.add(cols[i]);
               }
               //datosfile.add(m.group(5));
               out.print("<br>");
               aux2+=m.group(0);           
           }        
            csvOutput.write("Codigo");
            csvOutput.write("Nombres");
            csvOutput.write("Apellidos");
            csvOutput.write("Correo");
            csvOutput.endRecord();                                   
            csvOutput.close();
         
        } catch (IOException e) {
            e.printStackTrace();
        }*/
        
        /*String[] aux2 = aux.split("INSERT");
        aux2[0]="";*/
        br.close();
        /*for (int i=0;i<aux2.length;i++){
            out.print(aux2[i]);
            out.print("<br>");
        }*/
        // here is our splitter ! We use ";" as a delimiter for each request
        // then we are sure to have well formed statements
        String[] inst = sb.toString().split(";");
        
        /*for(int i = 0; i<inst.length; i++) {
        // we ensure that there is no spaces before or after the request 
        // string in order to not execute empty statements
           if(!inst[i].trim().equals("")){
              stm.executeUpdate(inst[i]+";");
           }
         }*/
        converter convertir = new converter();
        /*out.print("SB" + sb);*/
        /*convertir.exportExcelData(sb);*/
        
        
        
%>
