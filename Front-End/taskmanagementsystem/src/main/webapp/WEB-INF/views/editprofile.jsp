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
      <title>Edit Profile</title>
      <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
      <style>
         * {
         font-size: 13px;
         }
      </style>
      <link href="${pageContext.request.contextPath}/resources/css/toastr.min.css" rel="stylesheet" type="text/css" />
      <link href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" rel="stylesheet">
      <style>
         .account-settings .user-profile {
         margin: 0 0 1rem 0;
         padding-bottom: 1rem;
         text-align: center;
         }
         .account-settings .user-profile .user-avatar {
         margin: 0 0 1rem 0;
         }
         .account-settings .user-profile .user-avatar img {
         width: 90px;
         height: 90px;
         -webkit-border-radius: 100px;
         -moz-border-radius: 100px;
         border-radius: 100px;
         }
         .account-settings .user-profile h5.user-name {
         margin: 0 0 0.5rem 0;
         }
         .account-settings .user-profile h6.user-email {
         margin: 0;
         font-size: 0.8rem;
         font-weight: 400;
         color: #9fa8b9;
         }
         .account-settings .about {
         margin: 2rem 0 0 0;
         text-align: center;
         }
         .account-settings .about h5 {
         margin: 0 0 15px 0;
         color: #007ae1;
         }
         .account-settings .about p {
         font-size: 0.825rem;
         }
         .form-control {
         border: 1px solid #cfd1d8;
         -webkit-border-radius: 2px;
         -moz-border-radius: 2px;
         border-radius: 2px;
         font-size: .825rem;
         background: #ffffff;
         color: #2e323c;
         }
         .card {
         background: #ffffff;
         -webkit-border-radius: 5px;
         -moz-border-radius: 5px;
         border-radius: 5px;
         border: 0;
         margin-bottom: 1rem;
         }
      </style>
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
                     <li class="breadcrumb-item active text-dark" aria-current="page">Edit Profile</li>
                  </ol>
               </div>
               <div class="row gutters pt-5">
                  <div class="col-xl-3 col-lg-3 col-md-12 col-sm-12 col-12 pt-5">
                     <div class="card">
                        <div class="card-body">
                           <div class="account-settings">
                              <div class="user-profile">
                                 <h5 class="user-name">${userName}</h5>
                                 <h6 class="user-email">${email}</h6>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
                  <div class="col-xl-9 col-lg-9 col-md-12 col-sm-12 col-12">
                     <div class="card h-100">
                        <div class="card-body">
                           <div class="row gutters">
                              <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
                                 <h6 class="mb-2 text-primary">Personal Details</h6>
                              </div>
                              <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                 <div class="form-group">
                                    <label for="firstName"><span class="text-danger">*</span> First Name</label>
                                    <input type="text" class="form-control" id="firstName"  onkeypress="javascript:return isFirstName(event)" onPaste="var e=this; setTimeout(function(){checkFirstName(e)}, 4);" placeholder="Enter first name" value="${firstName}" autocomplete="off">
                                 </div>
                              </div>
                              <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                 <div class="form-group">
                                    <label for="lastName"><span class="text-danger">*</span> Last Name</label>
                                    <input type="text" class="form-control"  id="lastName"  onkeypress="javascript:return isLastName(event)" onPaste="var e=this; setTimeout(function(){checkLastName(e)}, 4);"  placeholder="Enter last name" value="${lastName}" autocomplete="off">
                                 </div>
                              </div>
                              <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                 <div class="form-group">
                                    <label for="eMail"><span class="text-danger">*</span> Email</label>
                                    <div class="input-group mb-3">
                                       <input type="text" class="form-control" id="email"  onkeypress="javascript:return isEmail(event)" onPaste="var e=this; setTimeout(function(){checkEmail(e)}, 4);"  placeholder="Enter email ID" autocomplete="off">
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
                              <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                 <div class="form-group">
                                    <label for="phone" class="form-label"><span class="text-danger">*</span> Phone</label>
                                    <div class="input-group mb-3">
                                       <div class="input-group-prepend">
                                          <span class="input-group-text" id="">+1</span>
                                       </div>
                                       <input type="text" class="form-control" id="phone" value="${mobile}" placeholder="Enter phone number" onkeypress="javascript:return isNumber(event)" onPaste="var e=this; setTimeout(function(){checkPhoneNumber(e)}, 4);"
                                          autocomplete="off">
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="row gutters">
                           <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
                              <div class="text-left">
                                 <a href="home" class="btn btn-sm btn-secondary">Cancel</a>
                                 <button type="button" onclick="editProfile()" class="btn btn-sm btn-success">Update</button>
                              </div>
                           </div>
                        </div>
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
      <script src="${pageContext.request.contextPath}/resources/js/toastr.min.js"></script>
      <script type="text/javascript">
         $(document).ready(function() {
         	
           $('#sidebarCollapse').on('click', function() {
             $('#sidebar, #content').toggleClass('active');
           });
           var e = "${email}".split("@")[0];
           $("#email").val(e);
           $("#emailSuffix").val("@" + "${email}".split("@")[1])
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
             function editProfile() {
               var firstname = $("#firstName").val();
               var lastname = $("#lastName").val();
               var Email = $("#email").val();
               var suffix = $("#emailSuffix").val();
               var phone = $("#phone").val();
               if (firstname.trim() != '' && lastname.trim() != '' && Email != '' && suffix != null && phone != '') {
             	  if (firstname.length < 6 || firstname.length > 30) {
                       toastr.options.closeButton = true;
                       toastr.options.positionClass = 'toast-top-center';
                       toastr.warning('First name must be minimum 6 and maximum 30 characters', ' warning');
                       return;
                     }
                     if (lastname.length < 6 || lastname.length > 30) {
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
                     if (Email.length < 5 || Email.length > 50) {
                         toastr.options.closeButton = true;
                         toastr.options.positionClass = 'toast-top-center';
                         toastr.warning('Email must be minimum 5 and maximum 50 characters excluding domain', ' warning');
                         return;
                       }
                   
                     if(!(Email+suffix == "${email}")){
                     	
                     var isEmailExist = "";
                     $.ajax({
                       type: "GET",
                       url: "isEmailExists",
                       data: {
                         emailId: Email.toLowerCase() + suffix
                       },
                       async: false,
                       success: function(data) {
                         if (data != '') {
                             var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                           if (response.exists == "true") {
                             toastr.options.closeButton = true;
                             toastr.options.positionClass = 'toast-top-center';
                             toastr.error('Email already exists', ' Error');
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
                 	  userId:${uid},
                     firstName: firstname.trim(),
                     lastName: lastname.trim(),
                     emailId: Email.toLowerCase() + suffix,
                     phoneNumber:phone
                   },
                   success: function(data) {
                     if (data != null) {
                         var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                       if (response.Status == "updated") {
                         toastr.options.closeButton = true;
                         toastr.options.positionClass = 'toast-top-center';
                         toastr.success('Updated Successfully, you need to sign in again to see the changes', ' Success');
                       }
                     }
                   }
                 });
               } else {
                 toastr.options.closeButton = true;
                 toastr.options.positionClass = 'toast-top-center';
                 toastr.error('Please enter all details', ' Error');
               }
             }
           
      </script>
   </body>
</html>