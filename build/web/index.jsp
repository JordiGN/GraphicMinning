<%-- 
    Document   : index
    Created on : 11-dic-2015, 18:28:10
    Author     : KissPK
--%>
<%@page import="weka.core.Debug.Random"%>
<%@page import="org.jfree.chart.ChartFactory" %>
<%@page import="org.jfree.chart.ChartUtilities" %>
<%@page import="org.jfree.chart.JFreeChart" %>
<%@page import="java.io.File" %>
<%@page import="org.jfree.chart.plot.*" %>
<%@page import="java.io.*" %>
<%@page import="org.jfree.data.category.DefaultCategoryDataset" %>
<%@page import="java.util.ArrayList"%>
<%@page import="weka.core.Instances"%>
<%@page import="weka.classifiers.Evaluation"%>
<%@page import="weka.classifiers.bayes.NaiveBayes"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<% HttpSession sesionOk = request.getSession();%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%
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
        NaiveBayes nB = new NaiveBayes();
        Evaluation eval = new Evaluation(training_data);
        eval.crossValidateModel(nB,training_data,10, new Random(1));
        
        
        sesionOk.removeAttribute("arff");                
        sesionOk.setAttribute("arff",destpath);
%>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1" />
<title>Consulta de estadísticas</title>
</head>

        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1" />
        <title>JSP Page</title>
    </head>
    <frameset rows="50%,50%" frameborder="no" border="0" framespacing="0">
        <frame src="table.jsp" name="topFrame" scrolling="No" noresize="noresize" id="topFrame" title="topFrame" />
        <frameset cols="34%,33%,33%" framespacing="0" frameborder="no"border="0">
            <frame src="crossValidation.jsp" name="mainFrame" id="mainFrame"title="mainFrame" />
            <frame src="cake_man.jsp" name="rightFrame" scrolling="No"noresize="noresize" id="rightFrame" title="barras_man" />
            <frame src="cake_woman.jsp" name="leftFrame" scrolling="No"noresize="noresize" id="leftFrame" title="barras_woman" />
        </frameset>
    </frameset>
<noframes>
    <body>
    </body>
</noframes>
</html>
