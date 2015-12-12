<%-- 
    Document   : info
    Created on : 11-dic-2015, 19:05:02
    Author     : KissPK
--%>
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%      HttpSession sesionOk = request.getSession();       
        String destpath = (String)sesionOk.getAttribute("arff"); 
        Instances training_data = new Instances(new BufferedReader(
                new FileReader(destpath)));
        training_data.setClassIndex(training_data.numAttributes() - 1);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
                         <label class="col-lg-3" for="metodo2">Atributos</label>
                         <div class="col-lg-6">                                    
                             <select class="form-control" name="atributo" >                                        
                                 <option value="0" selected>Seleccione</option> 
                                 <%for(int i=0;i<atributos.size();i++){%> 
                                 <option value="<%=(i)%>"><%=atributos.get(i).toString()%></option> 
                                 <%}%>  
                             </select>
                             <input type="submit" value="Procesar" class="btn btn-success"/>
                         </div> 
                     </form>                                                                   
                 </div>                                      
             </div>
             <div class="col-lg-12">
                 <div class='col-lg-6'><img src="crossValidation.jsp" /></div>
                 <div class='col-lg-6'>kjahskjahskdjhask</div>
                 <div class='col-lg-6'></div>
             </div>
     </section>
    </body>
        
</html>

