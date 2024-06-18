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

  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/daterangepicker.css" />
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
            <li class="breadcrumb-item active text-dark" aria-current="page">Task Report</li>
          </ol>
        </div>
        <div class="card" style="cursor: default;">
          <div class="card-header text-primary h4">
            Task Report
          </div>
          <div class="card-body">
            <i class="fas fa-calendar-alt"></i> <span> Date Range: </span>  <span id="reportrange" class="p-1 border border-secondary" style="cursor: pointer;"></span>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="getTasks();initialise();" class="btn btn-sm btn-success">Fetch</button>
          </div>
        </div>
        <div id="sample1" style="display:none;">
          <header class="py-4 text-center">
            <div class="btn-group">
              <button type="button" id="allBtn" onclick="showAll(this)" class="btn btn-warning">All</button>
              <button type="button" id="inPBtn" onclick="showInProgress(this)" class="btn btn-warning">In Progress</button>
              <button type="button" id="compBtn" onclick="showCompleted(this)" class="btn btn-warning">Completed</button>
            </div>
          </header>
          <header class="py-4">
            <button id="excelDownload" class="btn btn-sm btn-outline-dark float-right"><span class="fas fa-file"></span> Excel</button>
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
                  <table id="sample_7" style="width:100%;" class="table table-bordered table-hover table-sm mb-0 text-center">
                    <thead>
                      <tr>
                        <td style="display:none;" data-f-bold="true">Sprint Id</td>
                    
                    	<td data-f-bold="true">Sprint Name</td>
                        <td style="display:none;" data-f-bold="true"> Task ID</td>
                        <td data-f-bold="true">Task Name</td>
                        <td data-f-bold="true">Description</td>
                        <td data-f-bold="true">Priority</td>
                        <td data-f-bold="true">Est Time Of Delivery In Mins</td>
                        <td data-f-bold="true">Start Date Time</td>
                        <td data-f-bold="true">End Date Time</td>
                        <td data-f-bold="true">Total Time Spent</td>
                        <td data-f-bold="true">Current Task Status</td>
                        <td data-f-bold="true">Status</td>
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
  <script type="text/javascript">

    $(document).ready(function() {
    	
      $('.dropdown-menu a').click(function() {
        $('#selected').text($(this).text());
      });
      $("#excelDownload").click(function() {
        var d = new Date();
        var MM = d.getMonth() + 1;
        var DD = d.getDate();
        var YYYY = d.getFullYear();
        var HH = d.getHours();
        var MIN = d.getMinutes();
        var SS = d.getSeconds();
        var filename = "Task report " + DD + MM + YYYY + "_" + HH + "_" + MIN + "_" + SS + ".xlsx";
        TableToExcel.convert(document.getElementById("sample_7"), {
          name: filename,
          sheet: {
            name: "Tasks Report"
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
      var start = moment().subtract(29, 'days');
      var end = moment();
      function cb(start, end) {
        $('#reportrange').html(start.format('DD/MM/YYYY') + ' to ' + end.format('DD/MM/YYYY'));
      }
      $('#reportrange').daterangepicker({
        startDate: start,
        endDate: end,
        ranges: {
          'Today': [moment(), moment()],
          'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
          'Last 7 Days': [moment().subtract(6, 'days'), moment()],
          'Last 30 Days': [moment().subtract(29, 'days'), moment()],
          'This Month': [moment().startOf('month'), moment().endOf('month')],
          'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        },
        maxDate: new Date(),
        showDropdowns: true,
        linkedCalendars: false
      }, cb);
      cb(start, end);
    });
  </script>
  <script>
    var etable = null;
    function updateDataTable() {
      etable = $('#sample_7').DataTable({
        "lengthMenu": [
          [10, 25, 50, -1],
          [10, 25, 50, "All"]
        ],
        "pageLength": -1
      });
    }
    function initialise() {
      if (etable == null)
        updateDataTable();
      else {
        etable.destroy();
        getTasks();
        updateDataTable();
      }
    }
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
    var tBody = "";
    function getTasks() {
      $("#allBtn").attr("class", "btn btn-info");
      $("#inPBtn").attr("class", "btn btn-warning");
      $("#compBtn").attr("class", "btn btn-warning");
      tBody = "";
      document.getElementById("sample1").style.display = "";
      var daterange = $('#reportrange').text();
      var fd = daterange.split("to")[0];
      var td = daterange.split("to")[1];
      $.ajax({
        type: "GET",
        url: "taskReport.htm",
        data: {
          fromDate: fd,
          toDate: td
        },
        async: false,
        success: function(data) {
          if (data != null) {
              var res = $.parseJSON(data.replace(/\\/g,'\\\\').replace(/\n/g,"\\n"));

            var tableContent = "";
            var arr = res.tasks;
            for (var i = 0; i < arr.length; i++) {
              var response = arr[i];
              if (response.status == 0) {
                tableContent += "<tr name='inactiveTask' class='" + response.currentTaskStatus + "'><td style='display:none'>" + (response.sprintId != 0 ? response.sprintId : "-") + "</td><td>" + (response.sprintName != undefined ? response.sprintName : "-") + "</td><td style='display:none'>" + response.id + "</td><td name='tn'><a style='cursor:text;'  class='text-danger' name='taskName'>" +
                  response.taskName + "</a></td>" +
                  "<td name='td'>" + response.taskDescription + "</td>" +
                  "<td name='p'>" + response.priority + "</td>" +
                  "<td name='et'>" + response.estimatedTimeOfDelivery + "</td>" +
                  "<td>" + response.startDateTime + "</td>" +
                  "<td>" + (response.endDateTime != undefined ? response.endDateTime : "-") + "</td>" +
                  "<td>" + (response.totalTimeSpent != 0 ? timeConvert(response.totalTimeSpent) : "-") + "</td>" +
                  "<td><h5><span name='tag' class='badge'>" + response.currentTaskStatus + "</span></h5></td><td>Inactive</td>";
              } else {
                tableContent += "<tr name='activeTask' class='" + response.currentTaskStatus + "'><td style='display:none'>" + (response.sprintId != 0 ? response.sprintId : "-") + "</td><td>" +(response.sprintName != undefined ? response.sprintName : "-") + "</td><td style='display:none;'>" + response.id + "</td><td name='tn'><a style='cursor:text;' class='text-success' name='taskName'>" +
                  response.taskName + "</a></td>" +
                  "<td name='td'>" + response.taskDescription + "</td>" +
                  "<td name='p'>" + response.priority + "</td>" +
                  "<td name='et'>" + response.estimatedTimeOfDelivery + "</td>" +
                  "<td>" + response.startDateTime + "</td>" +
                  "<td>" + (response.endDateTime != undefined ? response.endDateTime : "-") + "</td>" +
                  "<td>" + (response.totalTimeSpent != 0 ? timeConvert(response.totalTimeSpent) : "-") + "</td>" +
                  "<td><h5><span name='tag' class='badge'>" + response.currentTaskStatus + "</span></h5></td><td>Active</td>";
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
          }
        }
      });
    }
    function showInProgress(pointer) {
    	$("#selected").text("Task Status");

      tBody = "";
      etable.destroy();
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

      tBody = "";
      etable.destroy();
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
  </script>
</body>
</html>