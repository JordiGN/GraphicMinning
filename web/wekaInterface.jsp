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