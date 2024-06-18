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
  <link href="${pageContext.request.contextPath}/resources/css/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css" />
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
            <li class="breadcrumb-item text-dark">Settings</li>
            <li class="breadcrumb-item active text-dark" aria-current="page">Add User</li>
          </ol>
        </div>
        <header class="py-3">
          <h4 class="text-primary">Add User</h4>
        </header>
        <form id="addUser" class="row g-3" autocomplete="off">
          <div class="col-md-6">
            <label for="firstName" class="form-label"><span class="text-danger">*</span> First Name</label>
            <input type="text" class="form-control" id="firstName" onkeypress="javascript:return isFirstName(event)" onPaste="var e=this; setTimeout(function(){checkFirstName(e)}, 4);" placeholder="first name"
              aria-describedby="fnameFeedback" autofocus autocomplete="off">
            <div id="fnameFeedback" class="invalid-feedback">
              Please enter first name.
            </div>
          </div>
          <div class="col-md-6">
            <label for="lastName" class="form-label"><span class="text-danger">*</span> Last Name</label>
            <input type="text" class="form-control" onkeypress="javascript:return isLastName(event)" onPaste="var e=this; setTimeout(function(){checkLastName(e)}, 4);" placeholder="last name" id="lastName" aria-describedby="lnameFeedback"
              autocomplete="off">
            <div id="nameFeedback" class="invalid-feedback">
              Please enter last name.
            </div>
          </div>
          <div class="border-bottom my-5 border-secondary"></div>
          <div class="col-md-6">
            <label for="email" class="form-label"><span class="text-danger">*</span> Email</label>
            <div class="input-group mb-3">
              <input type="text" class="form-control" id="email" placeholder="email address" autocomplete="nope" onkeypress="javascript:return isEmail(event)" onPaste="var e=this; setTimeout(function(){checkEmail(e)}, 4);" aria-label="email"
                aria-describedby="basic-addon2">
              <div class="input-group-append">
                <select class="form-select input-group-text" aria-label="Default select example" id="emailSuffix">
                  <option selected disabled>Domain</option>
                  <option value="@buddi.ai">@buddi.ai</option>
                  <option value="@buddihealth.com">@buddihealth.com</option>
                </select>
              </div>
              <div id="basic-addon2" class="invalid-feedback">
                Please enter email.
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <label for="phone" class="form-label"><span class="text-danger">*</span> Phone</label>
            <div class="input-group mb-3">
              <div class="input-group-prepend">
                <span class="input-group-text" id="">+91</span>
              </div>
              <input type="text" class="form-control" id="phone" placeholder="phone number" onkeypress="javascript:return isNumber(event)" onPaste="var e=this; setTimeout(function(){checkPhoneNumber(e)}, 4);" aria-label="Username"
                aria-describedby="phoneFeedback" autocomplete="nope">
              <div id="phoneFeedback" class="invalid-feedback">
                Please enter phone number.
              </div>
            </div>
          </div>
          <div class="border-bottom my-5 border-secondary"></div>
          <div class="col-md-6">
            <label for="username" class="form-label"><span class="text-danger">*</span> Username </label>
            <input type="text" class="form-control" placeholder="username" id="username" onkeypress="javascript:return isUsername(event)" onPaste="var e=this; setTimeout(function(){checkUsername(e)}, 4);" aria-describedby="usernameFeedback"
              autocomplete="nope">
            <div id="usernameFeedback" class="invalid-feedback">
              Please enter username.
            </div>
          </div>
          <div class="col-md-6">
            <label for="password" class="form-label"><span class="text-danger">*</span> Password</label>
            <input type="password" autocomplete="new-password" class="form-control" placeholder="password" id="password" aria-describedby="passwordFeedback">
            <div id="passwordFeedback" class="invalid-feedback">
              Please enter password.
            </div>
          </div>
          <div class="border-bottom my-5 border-secondary"></div>
          <div class="col-md-6">
            <label for="confirmPassword" class="form-label"><span class="text-danger">*</span> Confirm Password</label>
            <input type="password" autocomplete="new-password" class="form-control" placeholder="confirm password" id="confirmPassword" aria-describedby="cpasswordFeedback">
            <div id="cpasswordFeedback" class="invalid-feedback">
              Please enter password again.
            </div>
          </div>
          <div class="border-bottom my-5 border-secondary"></div>
          <div class="col-12">
            <button type="button" onclick="addUser()" class="btn btn-sm btn-success">Add</button>
          </div>
        </form>
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
    function isUsername(evt) {
      var iKeyCode = (evt.which) ? evt.which : evt.keyCode
      if ((iKeyCode >= 48 && iKeyCode <= 57) || (iKeyCode >= 65 && iKeyCode <= 90) || (iKeyCode >= 97 && iKeyCode <= 122)) {
        return true;
      }
      toastr.options.closeButton = true;
      toastr.options.positionClass = 'toast-top-center';
      toastr.options.timeOut = 2000;
      toastr.warning('Username can only have letters and numbers.', 'warning');
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
    function checkUsername(e) {
      let text = e.value;
      let pattern = /[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/;
      if (pattern.test(text)) {
        toastr.options.closeButton = true;
        toastr.options.positionClass = 'toast-top-center';
        toastr.options.timeOut = 2000;
        toastr.warning('Username can only have letters and numbers.', 'warning');
        $("#username").val("");
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
  </script>
  <script>
    function addUser(){
      
      var firstname = $("#firstName").val();
      var lastname = $("#lastName").val();
      var email = $("#email").val();
      var suffix = $("#emailSuffix").val();
      var phone = $("#phone").val();
      var username = $("#username").val();
      var password = $("#password").val();
      var confirmpassword = $("#confirmPassword").val();
      
      $("#firstName").attr("class", "form-control");
      $("#lastName").attr("class", "form-control");
      $("#email").attr("class", "form-control");
      $("#phone").attr("class", "form-control");
      $("#username").attr("class", "form-control");
      $("#password").attr("class", "form-control");
      $("#confirmPassword").attr("class", "form-control");
      
      if(firstname.trim() != '' && lastname.trim() != '' && email != '' && suffix != null && phone != '' && username != '' && password != '' && confirmpassword != '') {
        
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
        
        if (email.length < 5 || email.length > 50) {
            toastr.options.closeButton = true;
            toastr.options.positionClass = 'toast-top-center';
            toastr.warning('Email must be minimum 5 and maximum 50 characters excluding domain', ' warning');
            return;
          }
        
        if (username.length < 6 || username.length > 30) {
          toastr.options.closeButton = true;
          toastr.options.positionClass = 'toast-top-center';
          toastr.warning('Username must have a length of minimum 6 and maximum 30', ' warning');
          return;
        }
        
        if (password.length < 6 || password.length > 15) {
          toastr.options.closeButton = true;
          toastr.options.positionClass = 'toast-top-center';
          toastr.warning('Password must be minimum 6 and maximum 15 characters', ' warning');
          return;
        }
        
        let pattern1 = /[a-z]/;
        let pattern2 = /[A-Z]/;
        let pattern3 = /[0-9]/;
        let pattern4 = /[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/;
        
        if (!(pattern1.test(password) && pattern2.test(password) && pattern3.test(password) && pattern4.test(password))) {
          toastr.options.closeButton = true;
          toastr.options.positionClass = 'toast-top-center';
          toastr.options.timeOut = 3000;
          toastr.warning('Password must have atleast one lowercase letter, uppercase letter, number and special character.', 'warning');
          return;
        }
        
      
        
        if(password == confirmpassword) {
          $.ajax({
            type: "POST",
            url: "addUser.htm",
            data: {
              userName: username,
              firstName: firstname.trim(),
              lastName: lastname.trim(),
              Email: email.toLowerCase() + suffix,
              Mobile: phone,
              Password: password
            },
            async: false,
            success: function(data) {
              if (data != '') {
                  var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                if (response.hasOwnProperty("Error")) {
                  toastr.options.closeButton = true;
                  toastr.options.positionClass = 'toast-top-center';
                  toastr.error(response.Error, ' Error');
                  if(response.Error.includes("Email")){
                      $("#email").val("");
 
                  }
                  else{
                	  $("#username").val("");
                  }
                } else {
                  toastr.options.closeButton = true;
                  toastr.options.positionClass = 'toast-top-center';
                  toastr.success('User Added Successfully', ' Success');
                  document.getElementById("addUser").reset();
                  var form = document.createElement("form");
                  var element1 = document.createElement("input");
                  form.method = "GET";
                  form.action = "listUsers";
                  element1.type = "hidden";
                  form.appendChild(element1);
                  document.body.appendChild(form);
                  form.submit();
                }
              } 
            }
          });
        }
        else {
          toastr.options.closeButton = true;
          toastr.options.positionClass = 'toast-top-center';
          toastr.error('Passwords did not match', ' Error');
        } 
      } 
      else {
        if (firstname.trim() == '') {
          $("#firstName").attr("class", "form-control is-invalid");
        }
        if (lastname.trim() == '') {
          $("#lastName").attr("class", "form-control is-invalid");
        }
        if (email == '') {
          $("#email").attr("class", "form-control is-invalid");
        }
        if (suffix == null) {
          toastr.options.closeButton = true;
          toastr.options.positionClass = 'toast-top-center';
          toastr.warning('Please choose domain for your email', ' warning');
        }
        if (phone == '') {
          $("#phone").attr("class", "form-control is-invalid");
        }
        if (username == '') {
          $("#username").attr("class", "form-control is-invalid");
        }
        if (password == '') {
          $("#password").attr("class", "form-control is-invalid");
        }
        if (confirmpassword == '') {
          $("#confirmPassword").attr("class", "form-control is-invalid");
        }
      }
    }
  </script>
</body>
</html>