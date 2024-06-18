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
            <li class="breadcrumb-item active text-dark" aria-current="page">Change Password</li>
          </ol>
        </div>
        <section>
          <div class="container">
            <div class="row justify-content-center pt-5">
              <div class="col-md-6 col-lg-4">
                <h3 class="text-center mb-4">Change Password</h3>
                <form>
                  <div class="form-group">
                    <input type="text" class="form-control" value="${userName}" id="userName" placeholder="Username" disabled>
                  </div>
                  <div class="form-group">
                    <input type="password" class="form-control" id="password" placeholder="New Password" autocomplete="off" required>
                  </div>
                  <div class="form-group">
                    <input type="password" class="form-control" id="confirmPassword" placeholder="Confirm New Password" autocomplete="off" required>
                  </div>
                  <div class="form-group">
                    <button type="button" onclick="resetPassword()" class="btn btn-sm btn-success px-5">Change</button>
                  </div>
                </form>
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
<script src="${pageContext.request.contextPath}/resources/js/jquery.dataTables.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/dataTables.bootstrap4.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/tableToExcel.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/toastr.min.js"></script>
  <script type="text/javascript">

    $(document).ready(function() {
    	
      $('#sidebarCollapse').on('click', function() {
        $('#sidebar, #content').toggleClass('active');
        $('a[aria-expanded=true]').attr('aria-expanded', 'false');
      });
    });
  </script>
  <script>
    function resetPassword() {
      var username = $("#userName").val();
      var password = $("#password").val();
      var confirmpassword = $("#confirmPassword").val();
      if (username != '' && password != '' && confirmpassword != '') {
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
        if (password == confirmpassword) {
          $.ajax({
            type: "POST",
            url: "resetPassword.htm",
            data: {
              userName: username,
              Password: password
            },
            async: false,
            success: function(data) {
              if (data != '') {
                  var response = $.parseJSON(data.replace(/\n/g,"\\n"));
                  if(response.hasOwnProperty("Warning")){
                	  toastr.options.closeButton = true;
                      toastr.options.positionClass = 'toast-top-center';
                      toastr.error(response.Warning, ' Error');
                  }else{
                toastr.options.closeButton = true;
                toastr.options.positionClass = 'toast-top-center';
                toastr.success('Updated Successfully, please sign in again', ' Success');
                $("#password").val("");
                $("#confirmPassword").val("");

                $.get("logout");
                  }
              } 
            }
          });
        } else {
          toastr.options.closeButton = true;
          toastr.options.positionClass = 'toast-top-center';
          toastr.error('Passwords did not match', ' Error');
        }
      } else {
        toastr.options.closeButton = true;
        toastr.options.positionClass = 'toast-top-center';
        toastr.error('Please fill all fields', ' Error');
      }
    }
  </script>
</body>
</html>