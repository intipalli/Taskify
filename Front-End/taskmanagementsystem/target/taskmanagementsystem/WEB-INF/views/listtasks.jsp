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
  <title>BUDDI AI</title>
  <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
  <style>
  * {
   font-size: 13px;
}
</style>
  <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/dataTables.bootstrap4.min.css">
  <link href="${pageContext.request.contextPath}/resources/css/toastr.min.css" rel="stylesheet" type="text/css" />
  <link href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
            <li class="breadcrumb-item text-dark">Task</li>
            <li class="breadcrumb-item active text-dark" aria-current="page">My Tasks</li>
          </ol>
        </div>
        <header class="py-4 text-center">
          <div class="btn-group">
            <button type="button" id="allBtn" onclick="showAll(this)" class="btn btn-warning">All</button>
            <button type="button" id="inPBtn" onclick="showInProgress(this)" class="btn btn-warning">In Progress</button>
            <button type="button" id="compBtn" onclick="showCompleted(this)" class="btn btn-warning">Completed</button>
          </div>
       </header>
        <header class="py-4">
          <button id="excelDownload" class="btn btn-sm btn-outline-dark float-right">
            <span class="fas fa-file"></span> Excel
          </button>
          <div class="dropdown mr-3 pt-0 float-right">
            <button class="btn btn-sm btn-primary" type="button" data-toggle="dropdown" id="dropdownMenuButton" aria-haspopup="true" aria-expanded="false"><span id="selected">Task Status</span>&nbsp;&nbsp;&nbsp;<i
                class="fas fa-caret-down"></i></button>
            <ul class="dropdown-menu">
              <li><a class="dropdown-item" onclick="both()" style="cursor:pointer;">All</a></li>
              <li> <a class="dropdown-item" onclick="active()" style="cursor:pointer;">Active</a></li>
              <li><a class="dropdown-item" onclick="inactive()" style="cursor:pointer;">Inactive</a></li>
            </ul>
          </div>
        </header>
        <section class="py-4">
          <div class="row">
            <div class="col-lg-12">
              <div class="table-responsive">
                <table id="example" style="width: 100%;" class="table table-bordered table-hover table-sm mb-0 text-center">
                  <thead>
                    <tr>
                            <td style="display:none;" data-f-bold="true">Sprint Id</td>
                    
                    	<td data-f-bold="true">Sprint Name</td>
                      <td style="display:none;" data-f-bold="true">Task Id</td>
                      <td data-f-bold="true">Task Name</td>
                      <td data-f-bold="true">Description</td>
                      <td data-f-bold="true">Priority</td>
                      <td data-f-bold="true">Est Time Of Delivery In Mins</td>
                      <td data-f-bold="true">Start Date Time</td>
                      <td data-f-bold="true">End Date Time</td>
                      <td data-f-bold="true">Total Time Spent</td>
                      <td data-f-bold="true">Current Task Status</td>
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
      
      <div class="modal fade" id="editModal" role="dialog">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header">
              <h6 class="modal-title float-left text-primary" id="editModalHeading">Edit
                Task Details</h6>
              <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
              <div class="row">
                <div class="col-md-12">
                  <label><span class="text-danger">*</span> Task Name</label> <textarea class="form-control" id="editTaskName" rows="1" maxlength="100" autocomplete="off"></textarea><span id="remaining"></span>
                </div>
              </div>
              <br>
              <div class="row">
                <div class="col-md-12">
                  <label><span class="text-danger">*</span> Task Description</label>
                  <textarea rows="3" style="width: 100%;" id="editTaskDescription" maxlength="250" autocomplete="off"></textarea><span id="remainingC"></span>
                </div>
              </div>
              <br>
              <div class="row">
                <div class="col-md-12">
                  <label><span class="text-danger">*</span> Priority</label> <select class="form-select" name="priority" id="editTaskPriority">
                    <option value="High">High</option>
                    <option value="Medium">Medium</option>
                    <option value="Low">Low</option>
                  </select>
                </div>
              </div>
              <br>
              <div class="row">
                <div class="col-md-12">
                  <label><span class="text-danger">*</span> Estimated Time Of Delivery In Mins(Enter number)</label> 
                  <input type="text"  onkeypress="javascript:return isNumber(event)" onPaste="var e=this; setTimeout(function(){check(e)}, 4);"  style="width: 20%;" class="form-control" id="editEstTime" autocomplete="off">
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" onclick="editTask()" class="btn btn-sm btn-success pull-right">Save</button>
              <button type="button" class="btn btn-sm btn-secondary pull-right" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
     

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Are you sure you want to mark this task as "In Progress"? If Yes, Please enter a comment.</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      <div>
      <textarea id="reason" class="form-control" rows="2" maxlength="100" placeholder="Enter a comment of maximum 100 characters" autocomplete="off"></textarea>
      </div>
      <span id="rremaining"></span>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" onclick="moveToInProgress()" class="btn btn-primary">Yes</button>
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
  <script type="text/javascript">
  
    $(document).ready(function() {
    	
    	 $('#reason').keyup(function() {
             var len = this.value.length
             if (len > 100) {
               return false;
             } else if (len > 0) {
               $("#rremaining").html("Remaining characters: " + (100 - len));
             } else {
               $("#rremaining").html("Remaining characters: " + (100));
             }
           });
 	   
      $('.dropdown-menu a').click(function() {
        $('#selected').text($(this).text());
      });
      $('#editTaskDescription').keyup(function() {
        var len = this.value.length
        if (len > 250) {
          return false;
        } else if (len > 0) {
          $("#remainingC").html("Remaining characters: " + (250 - len));
        } else {
          $("#remainingC").html("Remaining characters: " + (250));
        }
      });
      
     
      
      $('#editTaskName').keyup(function() {
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
        var filename = "My tasks " + DD + MM + YYYY + "_" + HH + "_" + MIN + "_" + SS + ".xlsx";
        TableToExcel.convert(document.getElementById("example"), {
          name: filename,
          sheet: {
            name: "Tasks"
          }
        });
      });

      $('#sidebarCollapse').on('click', function() {
        $('#sidebar, #content').toggleClass('active');
      });
    });
  </script>
    <script>
    
   
    function isNumber(evt) {
      var iKeyCode = (evt.which) ? evt.which : evt.keyCode
      if (iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
        toastr.options.closeButton = true;
        toastr.options.positionClass = 'toast-top-center';
        toastr.options.timeOut = 2000;
        toastr.warning('This field cannot have letters, period and special characters.', 'warning');
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
        toastr.warning('This field cannot have letters, period and special characters.', 'warning');
        $("#editEstTime").val("");
      } else {}
    }
  </script>
  <script>
    var etable = null;
    function updateDataTable() {
      etable = $('#example').DataTable({
        "lengthMenu": [
          [10, 25, 50, -1],
          [10, 25, 50, "All"]
        ],
        "pageLength": -1
      });
    }
    getTasks();
    updateDataTable();
    var tBody = "";
    function timeConvert(n) {
    	var num = n;
    	var hours = (num / 60);
    	var rhours = Math.floor(hours);
    	var minutes = (hours - rhours) * 60;
    	var rminutes = Math.round(minutes);
    	
    	
    	if(rhours!=0)
        	return rhours + "." + rminutes;
        else
        	return rminutes;
    	
    	}
    
    function getTasks(){
      $("#allBtn").attr("class", "btn btn-info");
      $("#inPBtn").attr("class", "btn btn-warning");
      $("#compBtn").attr("class", "btn btn-warning");
      tBody = "";
      $.ajax({
        type: "GET",
        url: "listTasks.htm",
        data: {},
        async: false,
        success: function(data) {
          if (data != null) {
              var res = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));

            var tableContent = "";
            var arr = res.tasks;
            for (var i = 0; i < arr.length; i++) {
              var response = arr[i];
              if (response.status == 0) {
                tableContent += "<tr name='inactiveTask' class='" + response.currentTaskStatus + "'><td style='display:none'>" + (response.sprintId != 0 ? response.sprintId : "-") + "</td><td>" + (response.sprintName != undefined ? response.sprintName : "-") + "</td><td style='display:none'>" + response.id +
                  "</td><td name='tn'><a  style='cursor:pointer;' class='text-danger' name='taskName' onclick='taskHistory(this)'>" + response.taskName + "</a></td>" +
                  "<td name='td' >" + response.taskDescription + "</td>" +
                  "<td name='p'>" + response.priority + "</td>" +
                  "<td name='et'>" + response.estimatedTimeOfDelivery  + "</td>" +
                  "<td>" + response.startDateTime + "</td>" +
                  "<td>" + (response.endDateTime != undefined ? response.endDateTime : "-") + "</td>" +
                  "<td>" + (response.totalTimeSpent != 0 ? timeConvert(response.totalTimeSpent) : "-") + "</td>" +
                  "<td><h5><span name='tag' class='badge'>" + response.currentTaskStatus + "</span></h5></td><td>Inactive</td>" +
                  "<td data-exclude='true'><div class='btn-group' role='group' >" +
                  "<button type='button'  onclick='editTaskDetails(this)'  class='btn btn-sm edit' data-toggle='tooltip' data-placement='top' title='Edit Task'>" +
                  "<span class='fas fa-edit' ></span></button>" +
                  "<button type='button' name='" + response.id + " " + response.status + "'onclick='activateInactivate(this)'  class='btn btn-sm actInact' data-toggle='tooltip' data-placement='top' title='Activate'>" +
                  '<span class="fal fa-toggle-on" ></span></button>';
                if (response.currentTaskStatus != "Completed") {
               
                }
                else{
                	  tableContent +=
                          '<button type="button" name="' + response.id + ",In Progress" + '" onclick="updateCurrentTaskStatus(this)" class="btn btn-sm" data-toggle="tooltip" data-placement="top" title="Mark As In Progress">' +
                          '<span class="fa fa-close" style="font-size:15px" ></span></button>' +
                          '</div> </td></tr>';
                }
              } else {
                tableContent += "<tr name='activeTask' class='" + response.currentTaskStatus + "'><td style='display:none'>" + (response.sprintId != 0 ? response.sprintId : "-") + "</td><td>" +(response.sprintName != undefined ? response.sprintName : "-") + "</td><td style='display:none;'>" + response.id +
                  "</td><td name='tn'><a style='cursor:pointer;' class='text-success' name='taskName'  onclick='taskHistory(this)' >" + response.taskName + "</a></td>" +
                  "<td name='td'>" + response.taskDescription + "</td>" +
                  "<td name='p'>" + response.priority + "</td>" +
                  "<td name='et'>" + response.estimatedTimeOfDelivery  + "</td>" +
                  "<td>" + response.startDateTime + "</td>" +
                  "<td>" + (response.endDateTime != undefined ? response.endDateTime : "-") + "</td>" +
                  "<td>" + (response.totalTimeSpent != 0 ? timeConvert(response.totalTimeSpent) : "-") + "</td>" +
                  "<td><h5><span name='tag' class='badge'>" + response.currentTaskStatus + "</span></h5></td><td>Active</td>" +
                  "<td data-exclude='true'><div class='btn-group' role='group'>" +
                  "<button type='button' onclick='editTaskDetails(this)' class='btn btn-sm edit' data-toggle='tooltip' data-placement='top' title='Edit Task'>" +
                  "<span class='fas fa-edit' ></span></button>" +
                  "<button type='button' name='" + response.id + " " + response.status + "'onclick='activateInactivate(this)' class='btn btn-sm actInact' data-toggle='tooltip' data-placement='top' title='Inactivate'>" +
                  '<span class="fal fa-toggle-off" ></span></button>';
                if (response.currentTaskStatus != "Completed") {
                  tableContent +=
                    '<button type="button" name="' + response.id + ",Completed" + '"class="btn btn-sm" onclick="updateCurrentTaskStatus(this)" data-toggle="tooltip" data-placement="top" title="Mark As Complete">' +
                    '<span class="fas fa-check" ></span></button></div> </td></tr>';
                }
                else{
              	  tableContent +=
                        '<button type="button" name="' + response.id + ",In Progress" + '" onclick="updateCurrentTaskStatus(this)" class="btn btn-sm" data-toggle="tooltip" data-placement="top" title="Mark As In Progress">' +
                        '<span class="fa fa-close" style="font-size:15px"></span></button>' +
                        '</div> </td></tr>';
              }
              }
            }
            $("#tableBody").html(tableContent);
            var tags = document.getElementsByName("tag");
            for (var i = 0; i < tags.length; i++) {
              if (tags[i].innerHTML == "Completed") {
                $(tags[i]).attr("class", "badge badge-success");
              } else {
                $(tags[i]).attr("class", "badge badge-warning");
              }
            }
            $("tr.Completed .btn-group .edit").attr('disabled', 'disabled');
            $("tr.Completed .btn-group .actInact").attr('disabled', 'disabled');

          }
        }
      });
    }
    function showInProgress(pointer) {
    	$("#selected").text("Task Status");
      etable.destroy();
      tBody = "";
      getTasks();
      $('tr.Completed').remove();
      updateDataTable();
      $(pointer.previousElementSibling).attr("class", "btn btn-warning");
      $(pointer).attr("class", "btn btn-info");
      $(pointer.nextElementSibling).attr("class", "btn btn-warning");
    }
    function showAll(pointer) {
    	$("#selected").text("Task Status");
    	etable.destroy();
      tBody = "";
      getTasks();
      updateDataTable();
    }
    function showCompleted(pointer) {
    	$("#selected").text("Task Status");
    	etable.destroy();
      tBody = "";
      getTasks();
      $('tr.In').remove();
      updateDataTable();
      $(pointer.previousElementSibling).attr("class", "btn btn-warning");
      $(pointer.previousElementSibling.previousElementSibling).attr("class", "btn btn-warning");
      $(pointer).attr("class", "btn btn-info");
    }
    function clone() {
      tBody = $("#tableBody").html();
    }
    function active() {
      if (tBody == '') {
        clone();
      }
      etable.destroy();
      $("#tableBody").html(tBody);
      $('tr[name="inactiveTask"]').remove();
      updateDataTable();
    }
    function inactive() {
      if (tBody == '') {
        clone();
      }
      etable.destroy();
      $("#tableBody").html(tBody);
      $('tr[name="activeTask"]').remove();
      updateDataTable();
    }
    function both() {
      if (tBody == '') {
        clone();
      }
      etable.destroy();
      $("#tableBody").html(tBody);
      updateDataTable();
    }
    var id = 0;
    var sid = 0;
    function editTaskDetails(task) {
      $("#editModal").modal("show");
      var taskName = "";
      var taskDescription = "";
      var priority = "";
      var estimatedTime = "";
      id = task.parentElement.parentElement.parentElement.children[2].innerHTML;
      sid = task.parentElement.parentElement.parentElement.children[0].innerHTML;

      var prevSibling = task.parentElement.parentElement.previousElementSibling;
      while (prevSibling) {
        if (prevSibling.getAttribute("name") == "tn") {
          taskName = prevSibling.children[0].innerHTML;
        } else if (prevSibling.getAttribute("name") == "td") {
          taskDescription = prevSibling.innerHTML;
        } else if (prevSibling.getAttribute("name") == "et") {
          estimatedTime = prevSibling.innerHTML;
        } else if (prevSibling.getAttribute("name") == "p") {
          priority = prevSibling.innerHTML;
        } else {}
        prevSibling = prevSibling.previousElementSibling;
      }
      $("#editTaskName").val(taskName);
      $("#remaining").html("Remaining characters: " + (100 - taskName.length));
      $("#editTaskDescription").val(taskDescription);
      $("#remainingC").html("Remaining characters: " + (250 - taskDescription.length));
      $("#editTaskPriority").val(priority);
      $("#editEstTime").val(estimatedTime.substring(0,estimatedTime.length - 5));

      $.ajax({
          type: "POST",
          url: "taskTransaction",
          data: {
           taskId:id
          },
          success: function(data) {
            if (data != '') {
                var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                if(response.Key == "True"){
             		 $("#editEstTime").prop('disabled', true);

             	}
               else{
             	  $("#editEstTime").prop('disabled', false);

               }
            }
          }
        });
    }
    
    function editTask() {
      var taskName = $("#editTaskName").val();
      var taskDescription = $("#editTaskDescription").val();
      var priority = $("#editTaskPriority").val();
      var estimatedTime = $("#editEstTime").val();
      if (taskName.replace(/\s/g, '').length && taskDescription.replace(/\s/g, '').length && priority != '' && estimatedTime != '') {
    	  if(/^0+$/.test(estimatedTime)){
    		  toastr.options.closeButton = true;
              toastr.options.positionClass = 'toast-top-center';
              toastr.warning("Zero(s) are not allowed in estimated time field", 'Warning');
    		  return;
    	  }
        $.ajax({
          type: "POST",
          url: "editTask.htm",
          data: {
        	  sprintId:sid,
            taskId: id,
            taskname: taskName,
            taskdescription: taskDescription,
            Priority: priority,
            EstTime: estimatedTime
          },
          async: false,
          success: function(data) {
            if (data != '') {
                var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                if (response.hasOwnProperty("Warning")) {
              	  toastr.options.closeButton = true;
                    toastr.options.positionClass = 'toast-top-center';
                    toastr.warning(response.Warning, 'Warning');
                    $("#editTaskName").val("");
                }
                else{
                toastr.options.closeButton = true;
                toastr.options.positionClass = 'toast-top-center';
                toastr.success(' Edited Successfully', ' Success');
                $("#editModal").modal("hide");
                etable.destroy();
                getTasks();
                updateDataTable();
              }
            
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
    function activateInactivate(btn) {
      var tid = btn.getAttribute("name").split(" ")[0];
      var status = btn.getAttribute("name").split(" ")[1];
      if (status == 0) {
        bootbox.confirm("Are you sure to activate this task?", function(result) {
          if (result == true) {
            $.ajax({
              type: "POST",
              url: "updateTaskStatus.htm",
              data: {
                taskId: tid,
                status: 1
              },
              success: function(data) {
                if (data != '') {
                    var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                  if (response.hasOwnProperty("Id")) {
                    toastr.options.closeButton = true;
                    toastr.options.positionClass = 'toast-top-center';
                    toastr.success('Task is activated', ' Success');
                    etable.destroy();
                    getTasks();
                    updateDataTable();
                  }
                } else {
                  toastr.options.closeButton = true;
                  toastr.options.positionClass = 'toast-top-center';
                  toastr.error('No response from the API', ' Error');
                }
              }
            });
          }
        });
      } else {
        bootbox.confirm("Are you sure to inactivate this task?", function(result) {
          if (result == true) {
            $.ajax({
              type: "POST",
              url: "updateTaskStatus.htm",
              data: {
                taskId: tid,
                status: 0
              },
              success: function(data) {
                if (data != '') {
                    var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                  if (response.hasOwnProperty("Id")) {
                    toastr.options.closeButton = true;
                    toastr.options.positionClass = 'toast-top-center';
                    toastr.success('Task is inactivated', ' Success');
                    etable.destroy();
                    getTasks();
                    updateDataTable();
                  }
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
    }
    var taskId="";
    var st="";
    function updateCurrentTaskStatus(a) {
     taskId = a.getAttribute("name").split(",")[0];
     st = a.getAttribute("name").split(",")[1];
      var comment = "";
      if(st == "Completed"){
		comment = "Auto: Task is completed";
	}
      
      
     if(st == "In Progress"){
         $("#rremaining").html("");
         $("#reason").val("");
		$("#exampleModal").modal("show");
      

    	
         

     }
     else{
         bootbox.confirm("Are you sure to mark this task as " + st + "?", function(result) {
             if (result == true) {
               $.ajax({
                 type: "POST",
                 url: "updateCurrentTaskStatus.htm",
                 data: {
                   tid: taskId,
                   status:st,
                   comments:comment
                 },
                 success: function(data) {
                   if (data != '') {
                       var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                     if (response.hasOwnProperty("Success Message")) {
                       toastr.options.closeButton = true;
                       toastr.options.positionClass = 'toast-top-center';
                       toastr.success('Task marked as ' + st + ' successfully', ' Success');
                       etable.destroy();
                       getTasks();
                       updateDataTable();
                     }
                   }
                 }
               });
             }
           });
     }
    }
    
    function moveToInProgress(){
    	var comment = document.getElementById("reason").value;
    	
    	if(comment.replace(/\s/g, '').length){
				
             $.ajax({
              type: "POST",
              url: "updateCurrentTaskStatus.htm",
              data: {
                tid: taskId,
                status:st,
                comments:comment
              },
              success: function(data) {
                if (data != '') {
                    var response = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));
                  if (response.hasOwnProperty("Success Message")) {
                    toastr.options.closeButton = true;
                    toastr.options.positionClass = 'toast-top-center';
                    toastr.success('Task marked as ' + st + ' successfully', ' Success');
                    $("#rremaining").html("");
                    $("#reason").val("");
           		$("#exampleModal").modal("hide");
                    etable.destroy();
                    getTasks();
                    updateDataTable();
                  }
                } 
              }
            });
          }
    	else{
            $("#rremaining").html("");

            $("#reason").val("");

    			toastr.options.closeButton = true;
                 toastr.options.positionClass = 'toast-top-center';
                 toastr.warning('Please enter a comment', 'Warning');
    		
    		
    	}
    }
    
    function taskHistory(pointer) {
      var tid = pointer.parentElement.previousElementSibling.innerHTML;
      var form = document.createElement("form");
      var element1 = document.createElement("input");
      form.method = "GET";
      form.action = "taskHistory";
      element1.type = "hidden";
      element1.value = tid;
      element1.name = "taskId";
      form.appendChild(element1);
      document.body.appendChild(form);
      form.submit();
    }
  </script>

</body>
</html>