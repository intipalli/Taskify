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
      <title>Add Task</title>
      <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
      <style>
         * {
         font-size: 13px;
         }
      </style>
      <link href="${pageContext.request.contextPath}/resources/css/toastr.min.css" rel="stylesheet" type="text/css" />
      <link href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" rel="stylesheet">
      <style>
         .toast {
         opacity: 1 !important;
         }
      </style>
   </head>
   <body >
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
                     <li class="breadcrumb-item text-dark">Task</li>
                     <li class="breadcrumb-item active text-dark" aria-current="page">Add Task</li>
                  </ol>
               </div>
               <section class="pb-5 py-2">
                  <div class="row">
                     <div class="col-lg-12">
                        <div class="card">
                           <div class="card-header border-bottom">
                              <h3 class="h4 mb-0 text-primary">Add Task</h3>
                           </div>
                           <div class="card-body">
                              <form id="addTaskForm" class="form-horizontal">
                                 <div class="row">
                                    <label class="col-sm-3 form-label"><span class="text-danger">*</span> Task Name</label>
                                    <div class="col-sm-9">
                                       <textarea class="form-control" id="taskName" onpaste="var e=this; setTimeout(function(){taskname(e)}, 4);" aria-describedby="tasknameFeedback" rows="1" maxlength="100" autofocus autocomplete="off"></textarea>
                                       <span id="remaining"></span>
                                       <div id="tasknameFeedback" class="invalid-feedback">
                                          Please provide a task name.
                                       </div>
                                    </div>
                                 </div>
                                 <div class="border-bottom my-5 border-gray-200"></div>
                                 <div class="row">
                                    <label class="col-sm-3 form-label"><span class="text-danger">*</span> Task Description</label>
                                    <div class="col-sm-9">
                                       <textarea class="form-control" id="taskDescription" rows="3" onpaste="var e=this; setTimeout(function(){taskdesc(e)}, 4);" aria-describedby="taskdescriptionFeedback" maxlength="250" autocomplete="off"></textarea>
                                       <span id='remainingC'></span>
                                       <div id="taskdescriptionFeedback" class="invalid-feedback">
                                          Please provide a description.
                                       </div>
                                    </div>
                                 </div>
                                 <div class="border-bottom my-5 border-gray-200"></div>
                                 <div class="row">
                                    <label class="col-sm-3 form-label"><span class="text-danger">*</span> Estimated Time Of Delivery In Days</label>
                                    <div class="col-sm-9">
                                       <input class="form-control" type="text" id="mins" onkeypress="javascript:return isNumber(event)" onPaste="var e=this; setTimeout(function(){check(e)}, 4);" aria-describedby="timeFeedback" autocomplete="off">
                                       <div id="timeFeedback" class="invalid-feedback">
                                          Please provide a estimated time in days.
                                       </div>
                                    </div>
                                 </div>
                                 <div class="border-bottom my-5 border-gray-200"></div>
                                 <div class="row">
                                    <label class="col-sm-3 form-label"><span class="text-danger">*</span> Priority</label>
                                    <div class="col-sm-9">
                                       <select class="form-select mb-3" id="priority" aria-describedby="priorityFeedback">
                                          <option value="">Select</option>
                                          <option value="High">High</option>
                                          <option value="Medium">Medium</option>
                                          <option value="Low">Low</option>
                                       </select>
                                       <div id="priorityFeedback" class="invalid-feedback ">
                                          Please select a priority.
                                       </div>
                                    </div>
                                 </div>
                                 <div class="border-bottom my-5 border-gray-200"></div>
                                 <div class="row">
                                    <div class="col-sm-9 ms-auto">
                                       <button type="button" class="btn btn-md btn-success" onclick="addTask()">Add</button>
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
      <script type="text/javascript">
         $(document).ready(function() {
         	
          
           $('#sidebarCollapse').on('click', function() {
             $('#sidebar, #content').toggleClass('active');
           });
           $('#taskDescription').keyup(function() {
             var len = this.value.length
             if (len > 250) {
               return false;
             } else if (len > 0) {
               $("#remainingC").html("Remaining characters: " + (250 - len));
             } else {
               $("#remainingC").html("Remaining characters: " + (250));
             }
           });
           $('#taskName').keyup(function() {
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
         function taskname(e){
          var len = e.value.length
             if (len > 100) {
               return false;
             } else if (len > 0) {
               $("#remaining").html("Remaining characters: " + (100 - len));
             } else {
               $("#remaining").html("Remaining characters: " + (100));
             }
         }
         function taskdesc(e){
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
      <script>
         function isNumber(evt) {
           var iKeyCode = (evt.which) ? evt.which : evt.keyCode
           if (iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
             toastr.options.closeButton = true;
             toastr.options.positionClass = 'toast-top-center';
             toastr.options.timeOut = 2000;
             toastr.warning('Estimated time cannot have letters, period and special characters.', 'warning');
             return false;
           }
           return true;
         }
         function check(e) {
           let text = e.value;
           let pattern = /[ a-zA-Z`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/;
           if (pattern.test(text)) {
             toastr.options.closeButton = true;
             toastr.options.positionClass = 'toast-top-center';
             toastr.options.timeOut = 2000;
             toastr.warning('Estimated time cannot have letters, period and special characters.', 'warning');
             $("#mins").val("");
           } else {}
         }
      </script>
      <script>
         function addTask() {
           var taskname = $("#taskName").val();
           var taskdescription = $("#taskDescription").val();
           var esttime = document.getElementById("mins").value;
           var Priority = $("#priority").val();
           var sid = ${sprintId};
           $("#taskName").attr("class", "form-control");
           $("#taskDescription").attr("class", "form-control");
           $("#mins").attr("class", "form-control");
           $("#priority").attr("class", "form-select mb-3");
           $("#priorityFeedback").attr("class", "invalid-feedback");
           if (taskname.replace(/\s/g, '').length && taskdescription.replace(/\s/g, '').length && esttime != '' && Priority != '') {
         	  if(/^0+$/.test(esttime)){
         		  toastr.options.closeButton = true;
                   toastr.options.positionClass = 'toast-top-center';
                   toastr.warning("Zero(s) are not allowed in estimated days field", 'Warning');
         		  return;
         	  }
             $.ajax({
               type: "POST",
               url: "addSprintTask.htm",
               data: {
             	sprintId:sid,
                 taskName: taskname,
                 taskDescription: taskdescription,
                 estTime: esttime,
                 priority: Priority
               },
               async: false,
               success: function(data) {
                 if (data != '') {
                     var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
         
                   if (response.hasOwnProperty("Warning")) {
                 	  toastr.options.closeButton = true;
                       toastr.options.positionClass = 'toast-top-center';
                       toastr.warning(response.Warning, 'Warning');
                       $("#taskName").val("");
                       $("#remaining").text("Remaining characters: 100");
         
                   }
                   else{
                 	  toastr.options.closeButton = true;
                       toastr.options.positionClass = 'toast-top-center';
                       toastr.success('Task Added Successfully', ' Success');
                       document.getElementById("addTaskForm").reset();
                       $("#remainingC").html("");
                       $("#remaining").html("");
                       var sprintId = response.sprintId;
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
                 } 
               }
             });
           } else {
             if (!taskname.replace(/\s/g, '').length) {
               $("#taskName").attr("class", "form-control is-invalid");
             }
             if (!taskdescription.replace(/\s/g, '').length) {
               $("#taskDescription").attr("class", "form-control is-invalid");
             }
             if (esttime == '') {
               $("#mins").attr("class", "form-control is-invalid");
             }
             if (Priority == '') {
               $("#priority").attr("class", "form-select mb-3 is-invalid");
               $("#priorityFeedback").attr("class", "invalid-feedback d-block");
             }
           }
         }
      </script>
   </body>
</html>