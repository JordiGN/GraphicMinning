<%-- 
    Document   : info
    Created on : 11-dic-2015, 19:05:02
    Author     : KissPK
--%>
<%@page import="weka.classifiers.functions.SMO"%>
<%@page import="weka.classifiers.trees.J48"%>
<%@page import="weka.classifiers.Classifier"%>
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%    
        String destpath = request.getParameter("arff");       
            
        Instances training_data = new Instances(new BufferedReader(
                new FileReader(destpath)));
        training_data.setClassIndex(training_data.numAttributes() - 1);                          
        //Creamos la lista de los atributos seleccionados   
        SMO classifier = new SMO();
        classifier.buildClassifier(training_data);
        Evaluation eval = new Evaluation(training_data);
        eval.crossValidateModel(classifier,training_data,10, new Random(1));

        DefaultCategoryDataset dataset = new DefaultCategoryDataset();              
        dataset.setValue(eval.fMeasure(1),"Measure","Measure");
        dataset.setValue(eval.precision(1),"Precision","Precision");
        dataset.setValue(eval.recall(1),"Recall","Recall");           

        JFreeChart chart = ChartFactory.createBarChart("SMO Clasification","Medicion", "Porcentaje", dataset, PlotOrientation.VERTICAL, false,true, false);
 
        try {
            response.setContentType("image/png");
            OutputStream os = response.getOutputStream();
            ChartUtilities.writeChartAsPNG(os, chart, 625, 500);
 
 
        } catch (IOException e) {
            System.err.println("Error creando grafico.");
        }

%>