<%-- 
    Document   : distintos
    Created on : 10-dic-2015, 23:24:06
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%    
        String destpath = request.getParameter("arff");       
            
        Instances training_data = new Instances(new BufferedReader(
                new FileReader(destpath)));
        training_data.setClassIndex(training_data.numAttributes() - 1); 
        
        double precision=0;
        double recall=0;
        double fmeasure=0;
        double error=0;
        
        int size = training_data.numInstances()/10;
        int begin=0;
        int end=size-1;    
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for(int i=1;i<=10;i++){
            Instances trainingInstances = new Instances(training_data);
            Instances testInstances = new Instances(training_data, begin, (end-begin));
            for(int j=0;j<(end - begin);j++){
                trainingInstances.delete(begin);
            }                                   
            //Creamos la lista de los atributos seleccionados   
            NaiveBayes tree = new NaiveBayes();
            tree.buildClassifier(trainingInstances);

            Evaluation eval = new Evaluation(testInstances);
            eval.evaluateModel(tree,testInstances);
            dataset.setValue(eval.fMeasure(1),"Iteracion"+i,"Measure");
            dataset.setValue(eval.precision(1),"Iteracion"+i,"Precision");
            dataset.setValue(eval.recall(1),"Iteracion"+i,"Recall");
            dataset.setValue(eval.errorRate(),"Iteracion"+i,"Error");
            
            /*dataset.setValue(eval.precision(1),"Iteracion"+i,"Precision");
            dataset.setValue(eval.recall(1),"Iteracion"+i,"Recall");
            dataset.setValue(eval.fMeasure(1),"Iteracion"+i,"Measure");*/
            

            precision +=eval.precision(1);
            recall += eval.recall(1);
            fmeasure += eval.fMeasure(1);
            error +=eval.errorRate();

            //update
            begin = end+1;
            end += size;
            if (i==9){
                end=training_data.numInstances();
            }
        }                              
        JFreeChart chart = ChartFactory.createBarChart("CrossDetailValidation","Iteracion", "Porcentaje", dataset, PlotOrientation.VERTICAL, false,true, false);
 
        try {
            response.setContentType("image/png");
            OutputStream os = response.getOutputStream();
            ChartUtilities.writeChartAsPNG(os, chart, 625, 500);
        } catch (IOException e) {
            System.err.println("Error creando grafico.");
        }

%>

                         
