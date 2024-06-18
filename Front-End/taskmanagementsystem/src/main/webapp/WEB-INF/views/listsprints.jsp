<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>Sprints</title>
      <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
      <style>
         * {
         font-size: 13px;
         }
      </style>
      <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/dataTables.bootstrap4.min.css">
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
                     <li class="breadcrumb-item text-dark">Sprint</li>
                     <li class="breadcrumb-item active text-dark" aria-current="page">All Sprints</li>
                  </ol>
               </div>
               <div class="home" style="cursor: default;">
                  <div class="text-primary">
                     Fetch Sprints
                  </div>
                  <div class="pt-2">
                     <label><i class="fas fa-calendar-alt"></i> Date Range</label>
                     <div class="input-group mb-3 w-25">
                        <input type="text" class="form-control" onkeydown="return false;" onpaste="return false;" value="" id="reportrange" autocomplete="off">
                        <button onclick="fetchSprint()" class="btn btn-sm btn-success" >Fetch</button>
                     </div>
                  </div>
               </div>
               <br><br>
               <div class="home">
                  <header class="py-4 text-center">
                     <div class="btn-group">
                        <button type="button" id="allBtn" onclick="showAll(this)" class="btn btn-outline-primary">All</button>
                        <button type="button" id="upBtn" onclick="showUpcoming(this)" class="btn btn-outline-primary">Upcoming</button>
                        <button type="button" id="ongoingBtn" onclick="showOngoing(this)" class="btn btn-outline-primary">Ongoing</button>
                        <button type="button" id="compBtn" onclick="showCompleted(this)" class="btn btn-outline-primary">Completed</button>
                     </div>
                  </header>
                  <header class="py-4">
                     <button id="excelDownload" class="btn btn-sm btn-outline-dark float-right">
                     <span class="fas fa-file"></span> Excel
                     </button>
                  </header>
                  <section class="py-4">
                     <div class="row">
                        <div class="col-lg-12">
                           <div class="table-responsive">
                              <table id="example" style="width: 100%;" class="bg-light table table-bordered table-hover table-sm mb-0 text-center">
                                 <thead>
                                    <tr>
                                       <td style="display:none;" data-f-bold="true">Id</td>
                                       <td data-f-bold="true">Sprint Name</td>
                                       <td data-f-bold="true">Sprint Objective</td>
                                       <td data-f-bold="true">Start Date</td>
                                       <td data-f-bold="true">End Date</td>
                                       <td data-f-bold="true">Actual End Date</td>
                                       <td data-f-bold="true">Duration</td>
                                       <td data-f-bold="true">Actual Time Taken</td>
                                       <td data-f-bold="true">Status</td>
                                       <td data-exclude="true">Actions</td>
                                    </tr>
                                 </thead>
                                 <tbody id="tableBody">
                                 </tbody>
                              </table>
                           </div>
                        </div>
                     </div>
                  </section>
               </div>
            </div>
            <div class="modal fade" id="editModal" role="dialog">
               <div class="modal-dialog modal-lg">
                  <div class="modal-content">
                     <div class="modal-header">
                        <h6 class="modal-title float-left text-primary" id="editModalHeading">Edit
                           Sprint
                        </h6>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                     </div>
                     <div class="modal-body">
                        <div class="row">
                           <div class="col-md-12">
                              <label><span class="text-danger">*</span>Sprint Name</label> <textarea class="form-control" id="editSprintName" rows="1" maxlength="100" autocomplete="off"></textarea><span id="remaining"></span>
                           </div>
                        </div>
                        <br>
                        <div class="row">
                           <div class="col-md-12">
                              <label><span class="text-danger">*</span>Sprint Objective</label>
                              <textarea rows="3" style="width: 100%;" id="editSprintObjective" maxlength="250" autocomplete="off"></textarea><span id="remainingC"></span>
                           </div>
                        </div>
                        <br>
                        <div class="row">
                           <div class="col-md-12">
                              <label><span class="text-danger">*</span>Start Date</label>
                              <input type="text" class="form-control" onkeydown="return false;" onpaste="return false;" id="sprintStartDate" name="datefilter1" value="" autocomplete="off">                      
                           </div>
                        </div>
                        <div class="row">
                           <div class="col-md-12">
                              <label><span class="text-danger">*</span>End Date</label>
                              <input type="text" class="form-control" onkeydown="return false;" onpaste="return false;" id="sprintEndDate" name="datefilter2" value="" autocomplete="off">                      
                           </div>
                        </div>
                        <br>
                     </div>
                     <div class="modal-footer">
                        <button type="button" onclick="editSprint()" class="btn btn-sm btn-success pull-right">Save</button>
                        <button type="button" class="btn btn-sm btn-secondary pull-right" data-dismiss="modal">Close</button>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
      <script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/popper.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/bootbox.min.js"></script>
      <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
      <script src="https://cdn.datatables.net/1.11.4/js/dataTables.bootstrap4.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/tableToExcel.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/toastr.min.js"></script>
      <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/moment.min.js"></script>
      <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/daterangepicker.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/datejs/1.0/date.min.js" integrity="sha512-/n/dTQBO8lHzqqgAQvy0ukBQ0qLmGzxKhn8xKrz4cn7XJkZzy+fAtzjnOQd5w55h4k1kUC+8oIe6WmrGUYwODA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
      <script type="text/javascript">
         $(document).ready(function() {
         	
         	
         	$('input[name="datefilter1"]').daterangepicker({
           	    singleDatePicker: true,
           	      autoUpdateInput: false,
           	    
           	    showDropdowns: true,
         	      minDate:new Date()
         
           	  },function(start, end, label) {
            	      $("#sprintStartDate").val(start.format('MM/DD/YYYY'));
              
           	  });
           	  
           	  $('input[name="datefilter2"]').daterangepicker({
           		    singleDatePicker: true,
           		      autoUpdateInput: false,
           		  showDropdowns: true,
         	      minDate:new Date(),
         	      drops: 'up'
           		  },function(start, end, label) {
           		      $("#sprintEndDate").val(end.format('MM/DD/YYYY'));
         
           			  });
           	  
         
           $('#editSprintObjective').keyup(function() {
             var len = this.value.length
             if (len > 250) {
               return false;
             } else if (len > 0) {
               $("#remainingC").html("Remaining characters: " + (250 - len));
             } else {
               $("#remainingC").html("Remaining characters: " + (250));
             }
           });
           
           $('#editSprintName').keyup(function() {
             var len = this.value.length
             if (len > 100) {
               return false;
             } else if (len > 0) {
               $("#remaining").html("Remaining characters: " + (100 - len));
             } else {
               $("#remaining").html("Remaining characters: " + (100));
             }
           });
           
           $("#excelDownload").click(function() {
             var d = new Date();
             var MM = d.getMonth() + 1;
             var DD = d.getDate();
             var YYYY = d.getFullYear();
             var HH = d.getHours();
             var MIN = d.getMinutes();
             var SS = d.getSeconds();
             var filename = "Sprints " + DD + MM + YYYY + "_" + HH + "_" + MIN + "_" + SS + ".xlsx";
             TableToExcel.convert(document.getElementById("example"), {
               name: filename,
               sheet: {
                 name: "Sprints"
               }
             });
           });
           
           $('#sidebarCollapse').on('click', function() {
             $('#sidebar, #content').toggleClass('active');
           });
         });
      </script>
      <script type="text/javascript">
         $(function() {
          
             var start = moment().startOf('month').format('MM/DD/YYYY');
             var end = moment().endOf('month').format('MM/DD/YYYY');
             $('#reportrange').val(start + ' to ' + end);
              
             function cb(start, end) {
                 $('#reportrange').val(start + ' to ' + end);
             }
         
             $('#reportrange').daterangepicker({
                 locale: {
                     "format": "MM/DD/YYYY",
                     "separator": " to ",
                     "applyLabel": "Apply",
                     "cancelLabel": "Cancel",
                     "fromLabel": "From",
                     "toLabel": "To",
                     "customRangeLabel": "Custom",
                     "weekLabel": "W",
                     "daysOfWeek": [
                         "Su",
                         "Mo",
                         "Tu",
                         "We",
                         "Th",
                         "Fr",
                         "Sa"
                     ],
                     "monthNames": [
                         "January",
                         "February",
                         "March",
                         "April",
                         "May",
                         "June",
                         "July",
                         "August",
                         "September",
                         "October",
                         "November",
                         "December"
                     ],
                     "firstDay": 1
                 },
                 startDate: start,
                 endDate: end,
                 showDropdowns: true,
                 linkedCalendars: false,
                 ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                 }
             }, cb);
             
            
         
         
             cb(start, end);
             getSprints();
         
             updateDataTable();
         
         
         });
      </script>
      <script>
         var etable = null;
         function updateDataTable() {
           etable = $('#example').DataTable({
             "lengthMenu": [
               [10, 25, 50, -1],
               [10, 25, 50, "All"]
             ],
             "pageLength": -1,
         
           });
         }
         
         
         var tBody = "";
         
         function getSprints() {
         
           $("#allBtn").attr("class", "btn btn-primary");
           $("#ongoingBtn").attr("class", "btn btn-outline-primary");
           $("#compBtn").attr("class", "btn btn-outline-primary");
           tBody = "";
           var fd="";
           var td="";
           let daterange = $('#reportrange').val();
         
           if(daterange.trim().length>0){
         	  
         	  fd = daterange.split("to")[0];
               td = daterange.split("to")[1];
               
           }
          
           $.ajax({
             type: "GET",
             url: "fetchSprint.htm",
             data: {
             	fromDate:fd,
             	toDate:td
             },
             async: false,
             success: function(data) {
             	console.log(data);
               if (data != null) {
                   var res = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n") );
                 var tableContent = "";
                 var arr = res.sprints;
                 for (var i = 0; i < arr.length; i++) {
                   var response = arr[i];
                     tableContent += "<tr class='" + response.currentSprintStatus + "'><td style='display:none'>" + response.sprintId +
                       "</td><td name='sn' class='font-weight-bold'><a  style='cursor:pointer;' name='sprintName' onclick='sprintTasks(this)'>" + response.sprintName + "</a></td>" +
                       "<td name='so' >" + response.objective + "</td>" +
                       "<td name='sd'>" + (response.startDate).split(" ")[0] + "</td>" +
                       "<td name='ed'>" + (response.endDate).split(" ")[0] + "</td>" +
                       "<td name='ed'>" + (response.actualEndDate != undefined ? (response.actualEndDate) : "-") + "</td>" +
         
                       "<td>" + (response.duration+1 == 1 ? "1 day" : response.duration + " days"  ) + "</td>" +
                       "<td>" + (response.actualTimeTaken != undefined ? (parseInt(response.actualTimeTaken)+1 == 1 ? "1 day" : response.actualTimeTaken + " days"  ) : "-") + "</td>" +
         
                       "<td><h5><span name='sprintStatus' class='badge'>" + response.currentSprintStatus + "</span></h5></td>" +
                       "<td data-exclude='true'><div class='btn-group' role='group' >" +
                       "<button type='button'  onclick='showEditSprintModal(this)'  class='btn btn-sm' data-toggle='tooltip' data-placement='top' title='Edit Sprint'>" +
                       "<span class='fas fa-edit' ></span></button>";
                     if (response.sprintCompleted == "true" && response.currentSprintStatus != "Completed") {
                       tableContent +=
                         '<button id="btnGroupDrop1" type="button" name="' + response.sprintId + '" onclick="updateSprintStatus(this)" class="btn btn-sm" data-toggle="tooltip" data-placement="top" title="Mark sprint as complete">' +
                         '<span class="fas fa-check" ></span></button>' +
                         '</div> </td></tr>';
                     }
                  
         
                 }
                 $("#tableBody").html(tableContent);
                 var tags = document.getElementsByName("sprintStatus");
                 for (var i = 0; i < tags.length; i++) {
                   if (tags[i].innerHTML == "Completed") {
                     $(tags[i]).attr("class", "badge badge-success");
                   } else {
                     $(tags[i]).attr("class", "badge badge-warning");
                   }
                 }
                 $("tr.Completed .btn-group button").attr('disabled', 'disabled');
               }
             }
           });
         }
         
         function fetchSprint() {
            
                 if($("#reportrange").val() == ''){
                 	 toastr.options.closeButton = true;
                      toastr.options.positionClass = 'toast-top-center';
                      toastr.warning('Please choose a sprint range', 'Warning');
                      return;
                 }
         etable.destroy();
                 getSprints();
                 updateDataTable();
          
           }
         
         function showUpcoming(pointer) {
            etable.destroy();
            tBody = "";
            getSprints();
            $('tr.Completed').remove();
            $('tr.Ongoing').remove();
         
            updateDataTable();
            $(pointer.previousElementSibling).attr("class", "btn btn-outline-primary");
            $(pointer).attr("class", "btn btn-primary");
            $(pointer.nextElementSibling).attr("class", "btn btn-outline-primary");
            $(pointer.nextElementSibling.nextElementSibling).attr("class", "btn btn-outline-primary");
         
          }
         
         function showOngoing(pointer) {
           etable.destroy();
           tBody = "";
           getSprints();
           $('tr.Completed').remove();
           $('tr.Upcoming').remove();
         
           updateDataTable();
           $(pointer.previousElementSibling).attr("class", "btn btn-outline-primary");
           $(pointer.previousElementSibling.previousElementSibling).attr("class", "btn btn-outline-primary");
           $(pointer).attr("class", "btn btn-primary");
           $(pointer.nextElementSibling).attr("class", "btn btn-outline-primary");
         }
         function showAll(pointer) {
           etable.destroy();
           tBody = "";
           getSprints();
           updateDataTable();
         }
         function showCompleted(pointer) {
           etable.destroy();
           tBody = "";
           getSprints();
           $('tr.Ongoing').remove();
           $('tr.Upcoming').remove();
         
           updateDataTable();
           $(pointer.previousElementSibling).attr("class", "btn btn-outline-primary");
           $(pointer.previousElementSibling.previousElementSibling).attr("class", "btn btn-outline-primary");
           $(pointer.previousElementSibling.previousElementSibling.previousElementSibling).attr("class", "btn btn-outline-primary");
         
           $(pointer).attr("class", "btn btn-primary");
         }
         
         var id = 0;
         var sn = "";
         
         function showEditSprintModal(sprint) {
           $("#editModal").modal("show");
           
           
           
          
           var sprintObjective = "";
           var startDate = "";
           var endDate = "";
          
           id = sprint.parentElement.parentElement.parentElement.firstChild.innerHTML;
           var prevSibling = sprint.parentElement.parentElement.previousElementSibling;
           
           while (prevSibling) {
             if (prevSibling.getAttribute("name") == "sn") {
               sn = prevSibling.children[0].innerHTML;
             } else if (prevSibling.getAttribute("name") == "so") {
               sprintObjective = prevSibling.innerHTML;
             }
             else if (prevSibling.getAttribute("name") == "sd") {
                 startDate = prevSibling.innerHTML;
               }
             else if (prevSibling.getAttribute("name") == "ed") {
                 endDate = prevSibling.innerHTML;
               }
             else{}
             prevSibling = prevSibling.previousElementSibling;
           }
           $("#editSprintName").val(sn);
           $("#remaining").html("Remaining characters: " + (100 - sn.length));
           
           $("#editSprintObjective").val(sprintObjective);
           $("#remainingC").html("Remaining characters: " + (250 - sprintObjective.length));
           
           $("#sprintStartDate").val(startDate);
           $("#sprintEndDate").val(endDate);
           
         
           $('#sprintStartDate').prop('disabled', false);
           $('#sprintEndDate').prop('disabled', false);
         
         
           $.ajax({
         	 type:"POST",
         	 url:"isSprintEmpty.htm",
         	 data:{
         		 sprintId:id
         	 },
         	 success:function(data){
         		 if(data != null){
                      var response = $.parseJSON(data.replace(/\n/g,"\\n").replace(/\\/g,'\\\\'));
         			 if(response.Empty == "False"){
         			      $("#sprintStartDate").attr("disabled","disabled");
         			      $("#sprintEndDate").attr("disabled","disabled");
         
         
         			 }
         		 }
         	 }
           });
         
         }
         
          function editSprint() {
           var sprintName = $("#editSprintName").val();
           var sprintObjective = $("#editSprintObjective").val();
           var sprintStartDate = $("#sprintStartDate").val();
           var sprintEndDate = $("#sprintEndDate").val();
         
         
           if (sprintName.replace(/\s/g, '').length && sprintObjective.replace(/\s/g, '').length && sprintStartDate != '' && sprintEndDate != '') {
         	  
         	  if( !(sn == sprintName)){
         		  alert("going to call");
         	  var sprintNamePresent = "";
               $.ajax({
                   type: "POST",
                   url: "isSprintNameAvailable.htm",
                   data: {
                     sprintName: sprintName,
                    
                   
                   },
                   async: false,
                   success: function(data) {
                 	  alert(data);
                     if (data != '') {
                         var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                       if (response.exists == true) {
                     	  toastr.options.closeButton = true;
                           toastr.options.positionClass = 'toast-top-center';
                           toastr.error('Sprint name already exists', ' Error');
                           $("#sprintName").val("");
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
         	  }
         	  
         	  
             $.ajax({
               type: "POST",
               url: "editSprint.htm",
               data: {
                 sprintId: id,
                 sprintname: sprintName,
                 sprintobjective: sprintObjective,
         sprintrange: sprintStartDate + " - " + sprintEndDate             
               },
               async: false,
               success: function(data) {
                 if (data != '') {
                     var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                   if (response.hasOwnProperty("sprintName")) {
                     toastr.options.closeButton = true;
                     toastr.options.positionClass = 'toast-top-center';
                     toastr.success(' Edited Successfully', ' Success');
                   }
                   $("#editModal").modal("hide");
                   etable.destroy();
                   getSprints();
                   updateDataTable();
                 } else {
                   $("#editModal").modal("hide");
                   toastr.options.closeButton = true;
                   toastr.options.positionClass = 'toast-top-center';
                   toastr.error('No response from the API', ' Error');
                 }
               }
             });
           } else {
             toastr.options.closeButton = true;
             toastr.options.positionClass = 'toast-top-center';
             toastr.error('Please fill all the fields', ' Error');
           }
         }
         
         function updateSprintStatus(a) {
           var sprintId = a.getAttribute("name");
           bootbox.confirm("Are you sure to mark this sprint as complete?", function(result) {
             if (result == true) {
               $.ajax({
                 type: "POST",
                 url: "updateSprintStatus.htm",
                 data: {
                   id: sprintId
                 },
                 success: function(data) {
                   if (data != '') {
                       var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                     if (response.hasOwnProperty("Success")) {
                       toastr.options.closeButton = true;
                       toastr.options.positionClass = 'toast-top-center';
                       toastr.success('Success', ' Success');
                       etable.destroy();
                       getSprints();
                       updateDataTable();
                     }
                     else if (response.hasOwnProperty("Warning")) {
                         toastr.options.closeButton = true;
                         toastr.options.positionClass = 'toast-top-center';
                         toastr.warning('You cannot mark the sprint as complete at this moment because all the tasks in this sprint are not yet completed.', 'Warning');
                        
                       }
                     else{}
                   } else {
                     toastr.options.closeButton = true;
                     toastr.options.positionClass = 'toast-top-center';
                     toastr.error('No response from the API', ' Error');
                   }
                 }
               });
             }
           });
         }
          function sprintTasks(pointer) {
           var sprintId = pointer.parentElement.previousElementSibling.innerHTML;
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
      </script>
   </body>
</html>