<%-- 
    Document   : wekaInterface
    Created on : 04-dic-2015, 11:39:13
    Author     : KissPK
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
                                <% String archivo= new String(request.getParameter("archivo"));   %>
                                El archivo que elegiste es: <%=archivo %>
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

<!--
<script>


            var datosActuales =
            [ 
                {value:100,color:"#0082FF",label:"prueba1"},
                {value:150,color:"#0b00FF",label:"prueba1"},
                {value:200,color:"#0b8200",label:"prueba1"},
                <?php foreach ($datos_actuales as $datos_actualess) { ?>
                  {value:<?php echo $datos_actualess['cantidad'] ?>,color:"#0b82FF",highlight: "#0c62ab",label: "'<?php echo $datos_actualess['nombre'] ?>'"},
               <?php } ?>
            ];



            var ctx = document.getElementById("actuales").getContext("2d");

            window.myPie = new Chart(ctx).Pie(datosActuales);

        </script> -->
<% //Patron de coincidencias
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

%>