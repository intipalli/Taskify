<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="ISO-8859-1">
</head>
<body>
<%--   <nav class="navbar navbar-expand-lg"  style="background-color:#495371;">
    <div class="container-fluid">
    <div>
      <h5 class="text-white float-left ml-4 pt-1">BUDDI AI</h5>
      </div>
                <h6 class="text-white float-right"><%= session.getAttribute("Username") %></h6>
      
    </div>
  </nav> --%>
  
  <nav class="navbar navbar-inverse" style="background-color:#495371;">
    <a class="navbar-brand" href="https://www.buddi.ai/">
      <img src="Logo.png" height="20" alt="logo">
    </a>
    <ul class="navbar-nav">
      <li class="nav-item">
                        <h6 class="text-white float-right"><%= session.getAttribute("Username") %></h6>
        
      </li>
    </ul>
  </nav>
</body>
</html>