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
      <title>Users</title>
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
                     <li class="breadcrumb-item text-dark">Settings</li>
                     <li class="breadcrumb-item active text-dark" aria-current="page">All Users</li>
                  </ol>
               </div>
               <br>
               <div class="home">
                  <header class="py-4">
                     <button id="excelDownload" class="btn btn-sm btn-outline-dark float-right">
                     <span class="fas fa-file"></span> Excel
                     </button>
                     <div class="dropdown mr-3 pt-0 float-right">
                        <button class="btn btn-sm btn-primary" type="button" data-toggle="dropdown" id="dropdownMenuButton" aria-haspopup="true" aria-expanded="false"><span id="selected">User Status</span>&nbsp;&nbsp;&nbsp;<i
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
                              <table id="example" style="width: 100%;" class="bg-light table table-bordered table-hover table-sm mb-0 text-center">
                                 <thead>
                                    <tr>
                                       <td style="display:none;" data-f-bold="true">Id</td>
                                       <td data-f-bold="true">Username</td>
                                       <td data-f-bold="true">First Name</td>
                                       <td data-f-bold="true">Last Name</td>
                                       <td data-f-bold="true">Email ID</td>
                                       <td data-f-bold="true">Mobile Number</td>
                                       <td data-f-bold="true">Role</td>
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
                           User Details
                        </h6>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                     </div>
                     <div class="modal-body">
                        <div class="row">
                           <div class="col-md-12">
                              <label><span class="text-danger">*</span> First Name</label> 
                              <input  type="text" class="form-control" onkeypress="javascript:return isFirstName(event)" onPaste="var e=this; setTimeout(function(){checkFirstName(e)}, 4);" id="firstName" autocomplete="off" />
                           </div>
                        </div>
                        <br>
                        <div class="row">
                           <div class="col-md-12">
                              <label><span class="text-danger">*</span> Last Name</label> 
                              <input  type="text" class="form-control" onkeypress="javascript:return isLastName(event)" onPaste="var e=this; setTimeout(function(){checkLastName(e)}, 4);" id="lastName" autocomplete="off" />
                           </div>
                        </div>
                        <br>
                        <div class="row">
                           <div class="col-md-12">
                              <label><span class="text-danger">*</span>Email ID</label> 
                              <div class="input-group mb-3">
                                 <input type="text" class="form-control" id="email" onkeypress="javascript:return isEmail(event)" onPaste="var e=this; setTimeout(function(){checkEmail(e)}, 4);"
                                    autocomplete="nope">
                                 <div class="input-group-append">
                                    <select class="form-select input-group-text" id="emailSuffix">
                                       <option selected disabled>Domain</option>
                                       <option value="@gmail.com">@gmail.com</option>
                                       <option value="@amazon.com">@amazon.com</option>
                                    </select>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <br>
                        <div class="row">
                           <div class="col-md-12">
                              <label><span class="text-danger">*</span>Mobile Number</label> 
                              <div class="input-group mb-3">
                                 <div class="input-group-prepend">
                                    <span class="input-group-text" id="">+1</span>
                                 </div>
                                 <input type="text" class="form-control" id="phone" placeholder="" 
                                    onkeypress="javascript:return isNumber(event)" onPaste="var e=this; setTimeout(function(){checkPhoneNumber(e)}, 4);"
                                    autocomplete="nope">
                              </div>
                           </div>
                        </div>
                        <br>
                     </div>
                     <div class="modal-footer">
                        <button type="button" onclick="editUser()" class="btn btn-sm btn-success pull-right">Save</button>
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
             var filename = "All Users " + DD + MM + YYYY + "_" + HH + "_" + MIN + "_" + SS + ".xlsx";
             TableToExcel.convert(document.getElementById("example"), {
               name: filename,
               sheet: {
                 name: "TMS Users"
               }
             });
           });
           $('#sidebarCollapse').on('click', function() {
             $('#sidebar, #content').toggleClass('active');
           });
         });
      </script>
      <script>
         function isFirstName(evt) {
             var iKeyCode = (evt.which) ? evt.which : evt.keyCode
             if ((iKeyCode >= 65 && iKeyCode <= 90) || (iKeyCode >= 97 && iKeyCode <= 122) || iKeyCode == 46 || iKeyCode == 44 || iKeyCode == 39 || iKeyCode == 32) {
               return true;
             }
             toastr.options.closeButton = true;
             toastr.options.positionClass = 'toast-top-center';
             toastr.options.timeOut = 2000;
             toastr.warning("First name can only have letters and special characters such as (.,')", 'warning');
             return false;
           }
           
           function isLastName(evt) {
             var iKeyCode = (evt.which) ? evt.which : evt.keyCode
             if ((iKeyCode >= 65 && iKeyCode <= 90) || (iKeyCode >= 97 && iKeyCode <= 122) || iKeyCode == 46 || iKeyCode == 44 || iKeyCode == 39 || iKeyCode == 32) {
               return true;
             }
             toastr.options.closeButton = true;
             toastr.options.positionClass = 'toast-top-center';
             toastr.options.timeOut = 2000;
             toastr.warning("Last name can only have letters and special characters such as (.,')", 'warning');
             return false;
           }
           function isNumber(evt) {
             var iKeyCode = (evt.which) ? evt.which : evt.keyCode
             if (iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
               toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.options.timeOut = 2000;
               toastr.warning('Phone number can only have numbers.', 'warning');
               return false;
             }
             if(evt.target.value.length>9){
           	  return false;
             }
             return true;
           }
         
           function isEmail(evt) {
             var iKeyCode = (evt.which) ? evt.which : evt.keyCode
             if ((iKeyCode >= 48 && iKeyCode <= 57) || (iKeyCode >= 65 && iKeyCode <= 90) || (iKeyCode >= 97 && iKeyCode <= 122) || iKeyCode == 46) {
               return true;
             }
             toastr.options.closeButton = true;
             toastr.options.positionClass = 'toast-top-center';
             toastr.options.timeOut = 2000;
             toastr.warning('Email prefix can only have letters, numbers and period.', 'warning');
             return false;
           }
           function checkEmail(e) {
             let text = e.value;
             let pattern = /[ `!@#$%^&*()_+\-=\[\]{};':"\\|,<>\/?~]/;
             if (pattern.test(text)) {
               toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.options.timeOut = 2000;
               toastr.warning('Email prefix can only have letters, numbers and period.', 'warning');
               $("#email").val("");
             } else {}
           }
           function checkPhoneNumber(e) {
             let text = e.value;
             let pattern = /[ a-zA-Z`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/;
             if (pattern.test(text)) {
               toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.options.timeOut = 2000;
               toastr.warning('Phone number can only have numbers.', 'warning');
               $("#phone").val("");
             } 
             else if(text.length>10 || text.length<10){
           	  toastr.options.closeButton = true;
                 toastr.options.positionClass = 'toast-top-center';
                 toastr.options.timeOut = 2000;
                 toastr.warning('Phone number must be 10 digits.', 'warning');
                 $("#phone").val("");  
             }
             else{}
           }
         
           function checkFirstName(e) {
             let text = e.value;
             let pattern = /[0-9`!@#$%^&*()_+\-=\[\]{};:"\\|<>\/?~]/;
             if (pattern.test(text)) {
               toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.options.timeOut = 2000;
               toastr.warning("First name can only have letters and characters such as (.,')", 'warning');
               $("#firstName").val("");
             } else {}
           }
           function checkLastName(e) {
             let text = e.value;
             let pattern = /[0-9`!@#$%^&*()_+\-=\[\]{};:"\\|<>\/?~]/;
             if (pattern.test(text)) {
               toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.options.timeOut = 2000;
               toastr.warning("Last name can only have letters and characters such as (.,')", 'warning');
               $("#lastName").val("");
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
         getUsers();
         updateDataTable();
         
         
         function getUsers(){
          
           $.ajax({
             type: "GET",
             url: "listUsers.htm",
             data: {},
             async: false,
             success: function(data) {
               if (data != null) {
                 var res = $.parseJSON(data.replace(/\n/g,"\\n"));
         
                 var tableContent = "";
                 var arr = res.users;
                 for (var i = 0; i < arr.length; i++) {
                   var response = arr[i];
                   if (response.status == 0) {
                     tableContent += "<tr name='inactiveUser'><td style='display:none'>" + (response.id != 0 ? response.id : "-") + "</td><td class='text-danger'>" + (response.userName != undefined ? response.userName : "-") + "</td><td name='fn' >" + response.firstName +
                       "</td><td name='ln'>" + response.lastName + "</td>" +
                       "<td name='eid' >" + response.email + "</td>" +
                       "<td name='mn'>" + response.mobile + "</td>" +
                       "<td name='st'>" + response.role + "</td>" +
                       "<td>Inactive</td>" +
                       "<td data-exclude='true'><div class='btn-group' role='group' >" +
                       "<button type='button'  onclick='editUserDetails(this)'  class='btn btn-sm edit' data-toggle='tooltip' data-placement='top' title='Edit User'>" +
                       "<span class='fas fa-edit' ></span></button>" +
                       "<button type='button' name='" + response.id + " " + response.status + "'onclick='activateInactivate(this)'  class='btn btn-sm actInact' data-toggle='tooltip' data-placement='top' title='Activate'>" +
                       '<span class="fal fa-toggle-on" ></span></button>';
                   
                   } else {
                 	  tableContent += "<tr name='activeUser'><td style='display:none'>" + (response.id != 0 ? response.id : "-") + "</td><td class='text-success'>" + (response.userName != undefined ? response.userName : "-") + "</td><td name='fn'>" + response.firstName +
                       "</td><td name='ln'>" + response.lastName + "</td>" +
                       "<td name='eid' >" + response.email + "</td>" +
                       "<td name='mn'>" + response.mobile + "</td>" +
                       "<td name='st'>" + response.role + "</td>" +
                       "<td>Active</td>" +
                    
                       "<td data-exclude='true'><div class='btn-group' role='group'>" +
                       "<button type='button' onclick='editUserDetails(this)' class='btn btn-sm edit' data-toggle='tooltip' data-placement='top' title='Edit User'>" +
                       "<span class='fas fa-edit' ></span></button>" +
                       "<button type='button' name='" + response.id + " " + response.status + "'onclick='activateInactivate(this)' class='btn btn-sm actInact' data-toggle='tooltip' data-placement='top' title='Inactivate'>" +
                       '<span class="fal fa-toggle-off" ></span></button>';
                   
                   }
                 }
                 $("#tableBody").html(tableContent);
                
               }
             }
           });
         }
         
         
         function active() {
         
           etable.destroy();
           getUsers();
           $('tr[name="inactiveUser"]').remove();
           updateDataTable();
         }
         
         function inactive() {
         
           etable.destroy();
           getUsers();
           $('tr[name="activeUser"]').remove();
           updateDataTable();
         }
         
         function both() {
         
         	etable.destroy();
             getUsers();
             updateDataTable();
          }
         
         var id = 0;
         var emailId = "";
         
          function editUserDetails(user) {
           $("#editModal").modal("show");
           var firstName = "";
           var lastName = "";
           var mobileNumber = "";
           id = user.parentElement.parentElement.parentElement.children[0].innerHTML;
           var prevSibling = user.parentElement.parentElement.previousElementSibling;
           while (prevSibling) {
             if (prevSibling.getAttribute("name") == "fn") {
               firstName = prevSibling.innerHTML;
             } else if (prevSibling.getAttribute("name") == "ln") {
               lastName = prevSibling.innerHTML;
             } else if (prevSibling.getAttribute("name") == "eid") {
               emailId = prevSibling.innerHTML;
             } else if (prevSibling.getAttribute("name") == "mn") {
               mobileNumber = prevSibling.innerHTML;
             } else {}
             prevSibling = prevSibling.previousElementSibling;
           }
           $("#firstName").val(firstName);
           $("#lastName").val(lastName);
           $("#email").val(emailId.split("@")[0]);
           $("#emailSuffix").val("@" + emailId.split("@")[1]);
           $("#phone").val(mobileNumber);
         }
         
         function editUser() {
           var fn = $("#firstName").val();
           var ln = $("#lastName").val();
           var email = $("#email").val();
           var suffix = $("#emailSuffix").val();
           
         
           var phone = $("#phone").val();
           
           if (fn.trim() != '' &&  ln.trim() != '' && email != '' &&  phone != '' && suffix != null) {
         	  
           	if (fn.length < 6 || fn.length > 30) {
                 toastr.options.closeButton = true;
                 toastr.options.positionClass = 'toast-top-center';
                 toastr.warning('First name must be minimum 6 and maximum 30 characters', ' warning');
                 return;
                }
           	  
               if (ln.length < 6 || ln.length > 30) {
                 toastr.options.closeButton = true;
                 toastr.options.positionClass = 'toast-top-center';
                 toastr.warning('Last name must be minimum 6 and maximum 30 characters', ' warning');
                 return;
               }
               
               if (phone.length < 10 || phone.length > 10) {
                 toastr.options.closeButton = true;
                 toastr.options.positionClass = 'toast-top-center';
                 toastr.warning('Phone number should be 10 digits', ' warning');
                 return;
               }
               
               if (email.length < 5 || email.length > 50) {
                   toastr.options.closeButton = true;
                   toastr.options.positionClass = 'toast-top-center';
                   toastr.warning('Email must be minimum 5 and maximum 50 characters excluding domain', ' warning');
                   return;
                 }
               
               if(!(email+suffix == emailId)){
               var isEmailExist = "";
               $.ajax({
                 type: "GET",
                 url: "isEmailExists",
                 data: {
                   emailId: email.toLowerCase() + suffix
                 },
                 async: false,
                 success: function(data) {
                   if (data != '') {
                       var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                     if (response.exists == "true") {
                       toastr.options.closeButton = true;
                       toastr.options.positionClass = 'toast-top-center';
                       toastr.error('email already exists', ' Error');
                       $("#email").val("");
                       isEmailExist = "yes";
                     }
                   }
                
                 }
               });
               
               if (isEmailExist == "yes") {
                 return;
               }
               }
               
             $.ajax({
               type: "POST",
               url: "editProfile.htm",
               data: {
             	  userId:id,
                 firstName:fn.trim(),
                 lastName:ln.trim(),
                 emailId:email.toLowerCase() + suffix,
                 phoneNumber:phone
               },
               async: false,
               success: function(data) {
                 if (data != '') {
                     var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                   if (response.Status == "updated") {
                     toastr.options.closeButton = true;
                     toastr.options.positionClass = 'toast-top-center';
                     toastr.success('User Details Edited Successfully', ' Success');
                   }
                   $("#editModal").modal("hide");
                   etable.destroy();
                   getUsers();
                   updateDataTable();
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
           var uid = btn.getAttribute("name").split(" ")[0];
           var status = btn.getAttribute("name").split(" ")[1];
           if (status == 0) {
             bootbox.confirm("Are you sure to activate this user?", function(result) {
               if (result == true) {
                 $.ajax({
                   type: "POST",
                   url: "updateUserStatus.htm",
                   data: {
                    userId:uid,
                    status:1
                   },
                   success: function(data) {
                     if (data != '') {
                         var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                       if (response.hasOwnProperty("Success")) {
                         toastr.options.closeButton = true;
                         toastr.options.positionClass = 'toast-top-center';
                         toastr.success('User is activated', ' Success');
                         etable.destroy();
                         getUsers();
                         updateDataTable();
                       }
                     } 
                   }
                 });
               }
             });
           } else {
             bootbox.confirm("Are you sure to inactivate this user?", function(result) {
               if (result == true) {
                 $.ajax({
                   type: "POST",
                   url: "updateUserStatus.htm",
                   data: {
                 	  userId:uid,
                       status:0
                   },
                   success: function(data) {
                     if (data != '') {
                         var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                       if (response.hasOwnProperty("Success")) {
                         toastr.options.closeButton = true;
                         toastr.options.positionClass = 'toast-top-center';
                         toastr.success('User is inactivated', ' Success');
                         etable.destroy();
                         getUsers();
                         updateDataTable();
                       }
                     } 
                   }
                 });
               }
             });
           }
         }
         
      </script>
   </body>
</html>