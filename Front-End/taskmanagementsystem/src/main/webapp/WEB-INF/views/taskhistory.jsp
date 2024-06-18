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
      <title>Task Logs</title>
      <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
      <link href="${pageContext.request.contextPath}/resources/css/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css" />
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
                     <li class="breadcrumb-item text-dark" aria-current="page"><a href="listTasks">My Tasks</a></li>
                     <li class="breadcrumb-item active text-dark" aria-current="page">Task History</li>
                  </ol>
               </div>
               <div class="mt-4">
                  <div class="home">
                     <div>
                        <h3 class="text-center" id="taskName"></h3>
                        <p id="taskDescription"></p>
                        <button class="btn btn-sm btn-success" onclick="showAddCommentModal()">Add Comment</button>
                        <button id="excelDownload" class="btn btn-sm btn-outline-dark float-right"><span class="fas fa-file"></span> Excel</button>
                     </div>
                     <div class="table-responsive pt-5">
                        <table id="history" class="table table-hover table-bordered table-sm bg-light" style="width: 100%;">
                           <thead>
                              <tr>
                                 <td>Date Time</td>
                                 <td>Comments</td>
                                 <td>Status</td>
                                 <td data-exclude="true">Actions</td>
                              </tr>
                           </thead>
                           <tbody id="tableBody">
                           </tbody>
                        </table>
                     </div>
                  </div>
               </div>
            </div>
            <!-- Modal -->
            <div class="modal fade" id="addCommentModal" tabindex="-1" role="dialog" aria-labelledby="commentModalLabel" aria-hidden="true">
               <div class="modal-dialog modal-lg" role="document">
                  <div class="modal-content">
                     <div class="modal-header">
                        <h5 class="modal-title" id="commentModelTitle">Add Comment</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                     </div>
                     <div class="modal-body">
                        <textarea id="commentModalValue" rows="2" style="width:100%;" maxlength="100" placeholder="Type comment here.."></textarea>
                        <span id="remaining"></span>
                     </div>
                     <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" onclick="addComment()" class="btn btn-success">Add</button>
                     </div>
                  </div>
               </div>
            </div>
            <div class="modal fade" id="editCommentModal" tabindex="-1" role="dialog" aria-labelledby="commentModalLabel" aria-hidden="true">
               <div class="modal-dialog modal-lg" role="document">
                  <div class="modal-content">
                     <div class="modal-header">
                        <h5 class="modal-title">Edit Comment</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                     </div>
                     <div class="modal-body">
                        <textarea id="editCommentModalValue" rows="2" maxlength="100" style="width:100%;" placeholder="Type comment here.."></textarea>
                        <span id="eremaining"></span>
                     </div>
                     <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-success" onclick="editComment()">Edit</button>
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
      <script src="${pageContext.request.contextPath}/resources/js/tableToExcel.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/toastr.min.js"></script>
      <script type="text/javascript">
         $(document).ready(function() {
         	
           getTaskHistory();
           $("#excelDownload").click(function() {
             var d = new Date();
             var MM = d.getMonth() + 1;
             var DD = d.getDate();
             var YYYY = d.getFullYear();
             var HH = d.getHours();
             var MIN = d.getMinutes();
             var SS = d.getSeconds();
             var filename = document.getElementById("taskName").innerHTML + " history " + MM + DD + YYYY + "_" + HH + "_" + MIN + "_" + SS + ".xlsx";
             TableToExcel.convert(document.getElementById("history"), {
               name: filename,
               sheet: {
                 name: "Comments"
               }
             });
           });
           $('#sidebarCollapse').on('click', function() {
             $('#sidebar, #content').toggleClass('active');
           });
           $('#commentModalValue').keyup(function() {
               var len = this.value.length
               if (len > 100) {
                 return false;
               } else if (len > 0) {
                 $("#remaining").html("Remaining characters: " + (100 - len));
               } else {
                 $("#remaining").html("Remaining characters: " + (100));
               }
             });
           $('#editCommentModalValue').keyup(function() {
               var len = this.value.length
               if (len > 100) {
                 return false;
               } else if (len > 0) {
                 $("#eremaining").html("Remaining characters: " + (100 - len));
               } else {
                 $("#eremaining").html("Remaining characters: " + (100));
               }
             });
           
         });
      </script>
      <script>
         function getTaskHistory() {
           var tid = ${taskId};
           $.ajax({
             type: "GET",
             url: "taskHistory.htm",
             data: {
               taskId: tid
             },
             success: function(data) {
               if (data != '') {
                             var response = $.parseJSON(data.replace(/\n/g,"\\n"));
         
                 var tn = response.taskName;
                 var td = response.taskDescription;
                 $("#taskName").text(tn);
                 $("#taskDescription").text("Description: " + td);
                 var arr = response.taskHistory;
                 var tableContent = "";
                 for (var i = 0; i < arr.length; i++) {
                     tableContent += '<tr class="' + (arr[i].comments).split(":")[0] + '"><td>' + arr[i].dateTime + '</td><td>' + (arr[i].comments).split(":")[1] + '</td><td>' + arr[i].taskStatus +
                       '</td><td data-exclude="true"><div class="btn-group" role="group"><button name="editComment" class="edit" onclick ="showEditCommentModal(this)" class="btn btn-sm">' +
                       '<span class="fas fa-edit"></span></button>&nbsp;&nbsp;<button onclick="deleteComment(this)" class="delete" name="deleteButton" class="btn btn-sm"><span class="fas fa-trash"></span>' +
                       '</button></div></td></tr>';
                   
                 }
                 $("#tableBody").html(tableContent);
                 $("tr.Auto .btn-group .edit").attr('disabled', 'disabled');
                 $("tr.Auto .btn-group .delete").attr('disabled', 'disabled');
                 $("tr.Reason .btn-group .delete").attr('disabled', 'disabled');
         
         
         
               }
             }
           });
         }
      </script>
      <script>
         function addComment() {
           var c = $("#commentModalValue").val();
           var tid = ${taskId};
           if (c.replace(/\s/g, '').length) {
             $.ajax({
               type: "POST",
               url: "addComment.htm",
               data: {
                 taskId: tid,
                 comments: c
               },
               async: false,
               success: function(data) {
                 if (data != '') {
                     var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                   if (response.hasOwnProperty("Success")) {
                     $("#addCommentModal").modal("hide");
                     toastr.options.closeButton = true;
                     toastr.options.positionClass = 'toast-top-center';
                     toastr.success('Comment Added Successfully', ' Success');
                     getTaskHistory();
                   }
                 } else {
                   $("#addCommentModal").modal("hide");
                   toastr.options.closeButton = true;
                   toastr.options.positionClass = 'toast-top-center';
                   toastr.error('No response from the API', ' Error');
                 }
               }
             });
           } else {
             toastr.options.closeButton = true;
             toastr.options.positionClass = 'toast-top-center';
             toastr.error('Please give any comment', ' Error');
           }
         }
         var datetime = "";
         var tstatus = "";
         var isReason = null;
         var isManual = null;
         
         function editComment() {
         
           var comment = $("#editCommentModalValue").val();
           
           if(comment.trim().length == 0){
         	  toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.error('Please give any comment', ' Error');
         	  return;
           }
           
           if(isReason == true){
           	comment = "Reason: " + comment;
           }
           
           if(isManual == true){
         	  comment = "Manual: " + comment;
           }
           
           var tid = ${taskId};
           if (comment.replace(/\s/g, '').length) {
             $.ajax({
               type: "POST",
               url: "editComment.htm",
               data: {
                 taskId: tid,
                 Comment: comment,
                 dateTime: datetime,
                 status:tstatus
               },
               success: function(data) {
                 if (data != '') {
                     var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                   if (response.hasOwnProperty("Status")) {
                     $("#editCommentModal").modal("hide");
                     toastr.options.closeButton = true;
                     toastr.options.positionClass = 'toast-top-center';
                     toastr.success('Comment edited successfully', ' Success');
                     getTaskHistory();
                   }
                 } 
               }
             });
           } 
         }
         function deleteComment(pointer) {
           var datetime = pointer.previousElementSibling.parentElement.parentElement.parentElement.children[0].innerHTML;
           var taskstatus = pointer.previousElementSibling.parentElement.parentElement.parentElement.children[2].innerHTML;
         
           var tid = ${taskId};
           bootbox.confirm("Are you sure to delete this comment?", function(result) {
             if (result == true) {
               $.ajax({
                 type: "POST",
                 url: "deleteComment.htm",
                 data: {
                   dateTime: datetime,
                   taskId: tid,
                   status:taskstatus
         
                 },
                 success: function(data) {
                   if (data != '') {
                       var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                     toastr.options.closeButton = true;
                     toastr.options.positionClass = 'toast-top-center';
                     toastr.success('Deleted Successfully', ' Success');
                     getTaskHistory();
                   } else {
                     toastr.options.closeButton = true;
                     toastr.options.positionClass = 'toast-top-center';
                     toastr.error('No response from the API', ' Success');
                   }
                 }
               });
             }
           });
         }
         function showAddCommentModal() {
           $("#commentModalValue").val("");
           $("#remaining").html("");
         
           $("#addCommentModal").modal("show");
         }
         function showEditCommentModal(pointer) {
         	isReason = null;
         	isManual = null;
             var comment = pointer.parentElement.parentElement.previousElementSibling.previousElementSibling.innerHTML;
         	if(pointer.parentElement.parentElement.parentElement.getAttribute("class") == "Reason"){
         		isReason = true;
         	}
         	else if(pointer.parentElement.parentElement.parentElement.getAttribute("class") == "Manual"){
         		isManual = true;
         	}
         	else{}
           datetime = pointer.parentElement.parentElement.parentElement.children[0].innerHTML;
           tstatus = pointer.parentElement.parentElement.parentElement.children[2].innerHTML;
           $("#editCommentModal").modal("show");
           $("#editCommentModalValue").val(comment.trim());
           $("#eremaining").html("Remaining characters: " + (100 - comment.trim().length));
         
         }
      </script>
   </body>
</html>