<%-- 
    Document   : graficas
    Created on : 10-dic-2015, 20:28:24
    Author     : KissPK
--%>
<%@page import="org.jfree.chart.ChartFactory" %>
<%@page import="org.jfree.chart.ChartUtilities" %>
<%@page import="org.jfree.chart.JFreeChart" %>
<%@page import="java.io.File" %>
<%@page import="org.jfree.chart.plot.*" %>
<%@page import="java.io.*" %>
<%@page import="org.jfree.data.category.DefaultCategoryDataset" %>
<%@page import="java.util.ArrayList"%>
<%@page import="weka.core.Instances"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
        String destpath = request.getParameter("arff");
        String atributo = request.getParameter("atributo");        

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

        //Variables       
        
        String [][] distintos=new String[training_data.numDistinctValues(Integer.parseInt(atributo))][2];
        distintos[0][0]="";
        int v=0;
        int dist=training_data.numDistinctValues(Integer.parseInt(atributo)); 
        for(int p=0;p<dist;p++){
            for(int i=0;i<instancias.size();i++){
                String[] ins=instancias.get(i).toString().split(",");
                String dis=distintos[p][0];
                if(ins[1]!=dis){
                    distintos[p][0]=ins[1];
                    distintos[p][1]= String.valueOf(v++);
                }else{
                    distintos[p][1]= String.valueOf(v++);
                }
            }
        }                        
        //String atrib=atributos.get(Integer.parseInt(atributo)).toString();

        DefaultCategoryDataset dataset = new DefaultCategoryDataset();      
        for(int p=0;p<dist;p++){
            dataset.setValue(Integer.parseInt(distintos[p][1]), "Compras", distintos[p][0]);
        }       
        
        JFreeChart chart = ChartFactory.createBarChart("Distintos",atributos.get(Integer.parseInt(atributo)).toString(), "Numero de apariciones", dataset, PlotOrientation.VERTICAL, false,true, false);
 
        try {
            response.setContentType("image/png");
            OutputStream os = response.getOutputStream();
            ChartUtilities.writeChartAsPNG(os, chart, 625, 500);
 
 
        } catch (IOException e) {
            System.err.println("Error creando grafico.");
        }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/style.css" type="text/css"><link>
        <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css"><link>
        <title>Graphic Minning</title>        
    </head>
    <body>
        <h1>Hello World!</h1>
        <h3>El atributo que deseas examinar es: <%=atributos.get(Integer.parseInt(atributo)).toString()%></h3>
        <img src="graficas.jsp" />  
    </body>
</html>
<frameset rows="50%,50%" frameborder="no" border="0"
framespacing="0">
<frame src="table.jsp" name="topFrame" scrolling="No"
noresize="noresize" id="topFrame" title="topFrame" />
<frameset cols="34%,33%,33%" framespacing="0" frameborder="no"
border="0">
<frame src="bars.jsp" name="mainFrame" id="mainFrame"
title="mainFrame" />
<frame src="cake_man.jsp" name="rightFrame" scrolling="No"
noresize="noresize" id="rightFrame" title="barras_man" />
<frame src="cake_woman.jsp" name="leftFrame" scrolling="No"
noresize="noresize" id="leftFrame" title="barras_woman" />
</frameset>
</frameset>
<noframes><body>
</body>
</noframes></html>
                         
                                             