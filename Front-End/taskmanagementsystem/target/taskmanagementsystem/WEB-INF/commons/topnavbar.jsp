<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="ISO-8859-1">
</head>
<body>
  <nav class="navbar navbar-expand-lg"  style="background-color:#495371;">
    <div class="container-fluid">
    <div>
    
<!--       <button type="button" id="sidebarCollapse"  class="btn btn-sm float-left"  ><i class="fas fa-bars"></i></button>
 -->      <h5 class="text-white float-left ml-4 pt-1">BUDDI AI</h5>
      </div>
                <h6 class="text-white float-right"><%= session.getAttribute("Username") %></h6>
      
    </div>
  </nav>
</body>
</html>