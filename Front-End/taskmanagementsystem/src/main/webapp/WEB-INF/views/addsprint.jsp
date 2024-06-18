<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>Add Sprint</title>
      <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
      <style>
         * {
         font-size: 13px;
         }
      </style>
      <link href="${pageContext.request.contextPath}/resources/css/toastr.min.css" rel="stylesheet" type="text/css" />
      <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/daterangepicker.css" />
      <link href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" rel="stylesheet">
      <style>
         .toast {
         opacity: 1 !important;
         }
      </style>
   </head>
   <body>
      <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
         %>
      <div class="wrapper">
         <!-- Sidebar  -->
         <c:import url="../commons/sidebar.jsp"></c:import>
         <!-- Page Content  -->
         <div id="content">
            <c:import url="../commons/topnavbar.jsp"></c:import>
            <div class="container-fluid">
               <div class="bg-secondary-200 text-sm">
                  <ol class="breadcrumb py-2">
                     <li class="breadcrumb-item text-dark">Sprint</a></li>
                     <li class="breadcrumb-item active text-dark" aria-current="page">Add Sprint</li>
                  </ol>
               </div>
               <section class="pb-5 py-2">
                  <div class="row">
                     <div class="col-lg-12">
                        <div class="card">
                           <div class="card-header border-bottom">
                              <h3 class="h4 mb-0 text-primary">Add Sprint</h3>
                           </div>
                           <div class="card-body">
                              <form id="addSprintForm" class="form-horizontal">
                                 <div class="row">
                                    <label class="col-sm-3 form-label"><span class="text-danger">*</span>Sprint Name</label>
                                    <div class="col-sm-9">
                                       <textarea class="form-control" id="sprintName" onpaste="var e=this; setTimeout(function(){sprintname(e)}, 4);" aria-describedby="sprintnameFeedback" rows="1" maxlength="100" autofocus autocomplete="off"></textarea>
                                       <span id="remaining"></span>
                                       <div id="sprintnameFeedback" class="invalid-feedback">
                                          Please provide a sprint name.
                                       </div>
                                    </div>
                                 </div>
                                 <div class="border-bottom my-5 border-gray-200"></div>
                                 <div class="row">
                                    <label class="col-sm-3 form-label"><span class="text-danger">*</span>Sprint Objective</label>
                                    <div class="col-sm-9">
                                       <textarea class="form-control" id="sprintObjective" onpaste="var e=this; setTimeout(function(){sprintobj(e)}, 4);" rows="3" aria-describedby="sprintObjectiveFeedback" maxlength="250" autocomplete="off"></textarea>
                                       <span id='remainingC'></span>
                                       <div id="sprintObjectiveFeedback" class="invalid-feedback">
                                          Please provide a sprint objective.
                                       </div>
                                    </div>
                                 </div>
                                 <div class="border-bottom my-5 border-gray-200"></div>
                                 <div class="row">
                                    <label class="col-sm-3 form-label"><span class="text-danger">*</span>Sprint Range</label>
                                    <div class="col-sm-9">
                                       <input type="text" class="form-control" onkeydown="return false;" onpaste="return false;" id="sprintRange" name="datefilter" value="" class="p-1" aria-describedby="sprintRangeFeedback"/ autocomplete="off">                      
                                       <div id="sprintRangeFeedback" class="invalid-feedback">
                                          Please provide a sprint range.
                                       </div>
                                       <input type="hidden" id="range" value="">                      
                                    </div>
                                 </div>
                                 <div class="border-bottom my-5 border-gray-200"></div>
                                 <div class="row">
                                    <div class="col-sm-9 ms-auto">
                                       <button type="button" class="btn btn-md btn-success" onclick="addSprint()">Add</button>
                                    </div>
                                 </div>
                              </form>
                           </div>
                        </div>
                     </div>
                  </div>
               </section>
            </div>
         </div>
      </div>
      <script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/popper.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/bootbox.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/toastr.min.js"></script>
      <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/moment.min.js"></script>
      <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/daterangepicker.min.js"></script>
      <script type="text/javascript">
         $(document).ready(function() {
         	
         
         	  
           $('#sidebarCollapse').on('click', function() {
             $('#sidebar, #content').toggleClass('active');
           });
           $('#sprintObjective').keyup(function() {
             var len = this.value.length
             if (len > 250) {
               return false;
             } else if (len > 0) {
               $("#remainingC").html("Remaining characters: " + (250 - len));
             } else {
               $("#remainingC").html("Remaining characters: " + (250));
             }
           });
           
           $('#sprintName').keyup(function() {
             var len = this.value.length
             if (len > 100) {
               return false;
             } else if (len > 0) {
               $("#remaining").html("Remaining characters: " + (100 - len));
             } else {
               $("#remaining").html("Remaining characters: " + (100));
             }
           });
         });
         
         function sprintname(e){
         	 var len = e.value.length
              if (len > 100) {
                return false;
              } else if (len > 0) {
                $("#remaining").html("Remaining characters: " + (100 - len));
              } else {
                $("#remaining").html("Remaining characters: " + (100));
              }
         }
         function sprintobj(e){
         	 var len = e.value.length
              if (len > 250) {
                return false;
              } else if (len > 0) {
                $("#remainingC").html("Remaining characters: " + (250 - len));
              } else {
                $("#remainingC").html("Remaining characters: " + (250));
              }
         }
      </script>
      <script type="text/javascript">
         $(function() {
         
           $('input[name="datefilter"]').daterangepicker({
               autoUpdateInput: false,
               
               showDropdowns: true,
               linkedCalendars: false,
               drops: 'up',
               minDate:new Date()
           });
         
           $('input[name="datefilter"]').on('apply.daterangepicker', function(ev, picker) {
               $(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
               $("#range").val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
         
               
           });
         
           $('input[name="datefilter"]').on('cancel.daterangepicker', function(ev, picker) {
         	  $("#range").val("");
         
         	  $(this).val("");
           });
         
         });
      </script>
      <script>
         function addSprint() {
           var sprintname = $("#sprintName").val();
           var sprintobjective = $("#sprintObjective").val();
          var sprintrange = $("#range").val();
          
          
         	$("#sprintName").attr("class", "form-control");
           $("#sprintObjective").attr("class", "form-control");
           $("#sprintRange").attr("class", "form-control");
         
           if (sprintname.replace(/\s/g, '').length && sprintobjective.replace(/\s/g, '').length && sprintrange != '') {
         	  var sprintNamePresent = "";
               $.ajax({
                   type: "POST",
                   url: "isSprintNameAvailable.htm",
                   data: {
                     sprintName: sprintname,
                    
                   
                   },
                   async: false,
                   success: function(data) {
                     if (data != '') {
                         var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                        
                      
                       if (response.exists == true) {
                     	  
                     	  toastr.options.closeButton = true;
                           toastr.options.positionClass = 'toast-top-center';
                           toastr.error('Sprint name already exists. Give another sprint name.', ' Error');
                           $("#sprintName").val("");
                           $("#remaining").html("");
         
                   	  	sprintNamePresent = "yes";
         
                       }
                      
                     } else {
                       toastr.options.closeButton = true;
                       toastr.options.positionClass = 'toast-top-center';
                       toastr.info('No response from the API', 'Info');
                     }
                   }
                 }); 
               
               if(sprintNamePresent == "yes"){
             	  return;
               }
         	  
              $.ajax({
               type: "POST",
               url: "addSprint.htm",
               data: {
                 sprintName: sprintname,
                 sprintObjective: sprintobjective,
                 sprintRange:sprintrange
               
               },
               async: false,
               success: function(data) {
                 if (data != '') {
                     var res = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
               
         
                   if (res.hasOwnProperty("sprintName")) {
                     toastr.options.closeButton = true;
                     toastr.options.positionClass = 'toast-top-center';
                     toastr.success('Sprint Added Successfully', ' Success');
                     document.getElementById("addSprintForm").reset();
                     
                     var sprintId = res.sprintId;
                     var form = document.createElement("form");
                     var element1 = document.createElement("input");
                     form.method = "GET";
                     form.action = "sprintTasks";
                     element1.value = sprintId;
                     element1.name = "sprintId";
                     element1.type = "hidden";
                     form.appendChild(element1);
                     document.body.appendChild(form);
                     form.submit();
                   }
                 } else {
                   toastr.options.closeButton = true;
                   toastr.options.positionClass = 'toast-top-center';
                   toastr.info('No response from the API', 'Info');
                 }
               }
             });
           } else {
             if (!sprintname.replace(/\s/g, '').length) {
               $("#sprintName").attr("class", "form-control is-invalid");
             }
             if (!sprintobjective.replace(/\s/g, '').length) {
               $("#sprintObjective").attr("class", "form-control is-invalid");
             }
          if (sprintrange == '') {
               $("#sprintRange").attr("class", "form-control is-invalid");
             }
           
           }
         }
      </script>
   </body>
</html>