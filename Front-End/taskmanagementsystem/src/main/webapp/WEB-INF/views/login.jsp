<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <title>Login</title>
      <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
      <link href="${pageContext.request.contextPath}/resources/css/toastr.min.css" rel="stylesheet" type="text/css" />
      <link href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" rel="stylesheet">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
      <style>
         html,
         body {
         height: 100%;
         }
         body {
         display: -ms-flexbox;
         display: -webkit-box;
         display: flex;
         -ms-flex-align: center;
         -ms-flex-pack: center;
         -webkit-box-align: center;
         align-items: center;
         -webkit-box-pack: center;
         justify-content: center;
         padding-top: 40px;
         padding-bottom: 40px;
         background-color: #f5f5f5;
         }
         .form-signin {
         width: 100%;
         max-width: 330px;
         padding: 15px;
         margin: 0 auto;
         }
         .form-signin .form-control {
         position: relative;
         box-sizing: border-box;
         height: auto;
         padding: 10px;
         font-size: 16px;
         }
         .form-signin .form-control:focus {
         z-index: 2;
         }
         .form-signin input[type="text"] {
         margin-bottom: -1px;
         border-bottom-right-radius: 0;
         border-bottom-left-radius: 0;
         }
         .form-signin input[type="password"] {
         margin-bottom: 10px;
         border-top-left-radius: 0;
         border-top-right-radius: 0;
         }
      </style>
      <style>
         .toast {
         opacity: 1 !important;
         }
      </style>
   </head>
   <body>
      <form action="login" method="POST" class="form-signin text-center" id="loginForm">
         <img class="mb-4" src="task.jpg" alt="" width="72" height="72">
         <h1 class="h5 mb-3 font-weight-normal text-success">Taskify</h1>
         <label for="username" class="form-label sr-only">Username</label>
         <input type="text" name="userName" id="username" class="form-control" placeholder="Username" aria-describedby="usernameFeedback" autocomplete="off" autofocus>
         <label for="password" class="form-label sr-only">Password</label>
         <input type="password" name="Passwd" id="password" class="form-control" placeholder="Password" aria-describedby="passwordFeedback" autocomplete="off">
         <div class="mb-5">
            <a href="#" id="forgotPasswordLink" class="float-left" onclick="showUsernameModal()">Forgot Password</a>
         </div>
         <input class="btn btn-lg btn-primary btn-block" id="signinButton" type="submit" value="Sign In">
         <p class="mt-5 mb-3 text-muted">&copy; Rohan Innovatech</p>
         <p style="display:none;" id="errMsg">${ErrorMessage}</p>
      </form>
      <div class="modal fade" id="usernameModal" tabindex="-1" role="dialog" aria-labelledby="usernameModalLabel" aria-hidden="true">
         <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
               <div class="modal-header">
                  <h5 class="modal-title" id="usernameModalTitle">User Verification</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                  </button>
               </div>
               <div class="modal-body">
                  <div class="row" id="fpUsername">
                     <div class="col">
                        <input type="text" id="forgotPasswordUsername" placeholder="Enter your username" style="width:100%;" autocomplete="off" required>
                     </div>
                  </div>
                  <div class="row">
                     <div class="col">
                        <p class="text-danger" id="usernameModalErrorMessage"></p>
                     </div>
                  </div>
               </div>
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                  <button type="button" id="usernameModalSubmitButton" class="btn btn-success">Submit</button>
               </div>
            </div>
         </div>
      </div>
      <div class="modal fade" id="codeModal" tabindex="-1" role="dialog" aria-labelledby="codeModalLabel" aria-hidden="true">
         <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
               <div class="modal-header">
                  <h5 class="modal-title" id="codeModalTitle">User Validation</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                  </button>
               </div>
               <div class="modal-body">
                  <div class="row" id="fpCode">
                     <div class="col">
                        <label for="code">An OTP has been sent to your email address, please enter it.</label>
                        <input type="text" id="code" placeholder="Your verification code" style="width:100%;" required>
                     </div>
                  </div>
                  <div class="row">
                     <div class="col">
                        <p class="text-danger" id="codeModalErrorMessage"></p>
                     </div>
                  </div>
               </div>
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                  <button type="button" id="codeModalSubmitButton" class="btn btn-success">Submit</button>
               </div>
            </div>
         </div>
      </div>
      <script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/popper.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/toastr.min.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/bootbox.min.js"></script>
      <script>
         $('#forgotPasswordUsername').keyup(function() {
             var len = this.value.length;
             if (len > 0) {
                 $("#usernameModalErrorMessage").text("");
             } 
           });
         
         
           if ($("#errMsg").text() != '') {
             toastr.options.closeButton = true;
             toastr.options.positionClass = 'toast-top-center';
             toastr.error($("#errMsg").text(), ' Error');
           }
      </script>
      <script>
         const form = document.getElementById('loginForm');
         form.addEventListener('submit', (event) => {
           if ($("#username").val() != '' && $("#password").val() != '') {
             form.submit();
           } else {
             if ($("#username").val() == '' && $("#password").val() == '') {
               toastr.clear()
               toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.options.timeOut = 2000;
               toastr.warning('Please enter your username and password', ' Warning');
               event.preventDefault();
             } else if ($("#username").val() == '') {
               toastr.clear()
               toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.options.timeOut = 2000;
               toastr.warning('Please enter your username', ' Warning');
               event.preventDefault();
             } else {
               toastr.clear()
               toastr.options.closeButton = true;
               toastr.options.positionClass = 'toast-top-center';
               toastr.options.timeOut = 2000;
               toastr.warning('Please enter your password', ' Warning');
               event.preventDefault();
             }
           }
         });
      </script>
      <script>
         function showUsernameModal() {
           $('#forgotPasswordUsername').val('');
           $('#usernameModal').modal('show');
           $("#usernameModalErrorMessage").text("");
         }
         
         
         
         
         $("#usernameModalSubmitButton").click(function() {
           var username = $("#forgotPasswordUsername").val();
           if (username.replace(/\s/g, '').length) {
             $.ajax({
               type: 'GET',
               url: "checkUsername",
               data: {
                 userName: username
               },
               success: function(data) {
                 if (data != "") {
                     var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                   if (response["Exist"] == "Yes") {
                     $("#usernameModalErrorMessage").text("");
               
                     bootbox.dialog({ message: '<div class="text-center"><span class="fas fa-spinner"></span> Loading...</div>',size:"small",closeButton:false });
         
                     $.ajax({
                         type: 'POST',
                         url: "generateOtp.htm",
                         data: {
                         		userName:username
                                },
                         success: function(data) {
                            if (data != "") {
                         	   
                         	   var response = $.parseJSON(data);
                         	   bootbox.hideAll();
                         	    if(response.hasOwnProperty("Error"))
                     		   {
                                $('#usernameModal').modal('hide');
         
                     		   toastr.options.closeButton = true;
                                toastr.options.positionClass = 'toast-top-center';
                                toastr.error("User is inactive", 'Error');  
         
         
                     		   
                     		   }
                         	   
                         	   else if(response["status"]=="OTP sent successfully")
                         		   {
                                    $('#usernameModal').modal('hide');
         
                         		   toastr.options.closeButton = true;
                                    toastr.options.positionClass = 'toast-top-center';
                                    toastr.success('OTP sent', 'Success');  
         
                                    $("#codeModal").modal("show");
                                    $('#code').val('');
         
                         		   
                         		   }
                         	   else
                         		   {
                         		   toastr.options.closeButton = true;
                                    toastr.options.positionClass = 'toast-top-center';
                                    toastr.error('OTP generation failed.', 'Error');  
         
                         		   }
                         	   
                         	   
         
                                           }
                            
                            
                            
                                    }
                             });		
                   } else {
                     $("#usernameModalErrorMessage").text("User does not exist");
                   }
                 }
               }
             });
           } else {
             $("#usernameModalErrorMessage").text("Please provide a username");
           }
         });
         
         
         $("#codeModalSubmitButton").click(function() {
         var code = $("#code").val();
         var username = $("#forgotPasswordUsername").val();
         
         if (code.replace(/\s/g, '').length) {
         
         $.ajax({
         type: 'POST',
         url: "verifyOtp.htm",
         data: {
         otp:code,
         userName:username
         },
         success: function(data) {
         if (data != "") {
         var response = $.parseJSON(data);
         if(response.Error == "User is deactivated"){
          toastr.options.closeButton = true;
                  toastr.options.positionClass = 'toast-top-center';
                  toastr.error(response.Error, 'Error');
         }
         if(response["status"]=="verified")
           {
          toastr.options.closeButton = true;
                  toastr.options.positionClass = 'toast-top-center';
                  toastr.success('You are verified', 'Success');
                  $("#codeModal").modal("hide");
         	     $("#forgotPasswordUsername").val("");
         
                  var form = document.createElement("form");
                  var element1 = document.createElement("input");
                  form.method = "GET";
                  form.action = "resetPassword";
                  element1.value = username;
                  element1.name = "userName";
                  element1.type = "hidden";
                  form.appendChild(element1);
                  document.body.appendChild(form);
                  form.submit();
         
         
           
           }
         if(response["status"]=="not verified")
          {
         $("#code").val("");
          toastr.options.closeButton = true;
                  toastr.options.positionClass = 'toast-top-center';
                  toastr.warning("Incorrect OTP. " + response["retriesRemaining"] + " attempts remaining", 'Warning');  
           
          }
           
         }
         }
         }); 
         }
         else {
         $("#codeModalErrorMessage").text("Please enter OTP and submit");
         }
         
         });
      </script>
   </body>
</html>