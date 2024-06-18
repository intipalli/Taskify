<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="ISO-8859-1">
  <style>
  @import "https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700";
  body {
    font-family: 'Poppins', sans-serif;
    background: #fafafa;
  }
  a,
  a:hover,
  a:focus {
    color: inherit;
    text-decoration: none;
    transition: all 0.3s;
  }
  .navbar {
    padding: 15px 10px;
    background: #fff;
    border: none;
    border-radius: 0;
    margin-bottom: 40px;
    box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.1);
  }
  i,
  span {
    display: inline-block;
  }
  /* ---------------------------------------------------
    SIDEBAR STYLE
----------------------------------------------------- */
  .wrapper {
    display: flex;
    align-items: stretch;
  }
  #sidebar {
    min-width: 200px;
    max-width: 200px;
    background: #495371;
    color: #fff;
    transition: all 0.3s;
  }
  #sidebar.active {
    min-width: 100px;
    max-width: 100px;
    text-align: center;
  }
  #sidebar.active .sidebar-header h5 {
    display: none;
  }
  #sidebar.active .sidebar-header strong {
    display: block;
  }
  #sidebar ul li a {
    text-align: left;
  }
  #sidebar.active ul li a {
    padding: 20px 10px;
    text-align: center;
    font-size: 0.85em;
  }
  #sidebar.active ul li a i {
    margin-right: 0;
    display: block;
    font-size: 1.8em;
    margin-bottom: 5px;
  }
  #sidebar.active ul ul a {
    padding: 10px !important;
  }
  #sidebar.active .dropdown-toggle::after {
    top: auto;
    bottom: 10px;
    right: 50%;
    -webkit-transform: translateX(50%);
    -ms-transform: translateX(50%);
    transform: translateX(50%);
  }
  #sidebar .sidebar-header {
    padding: 20px;
    background: #495371;
  }
  #sidebar .sidebar-header strong {
    display: none;
    font-size: 1.4em;
  }
  #sidebar ul.components {
    padding: 20px 0;
  }
  #sidebar ul li a {
    padding: 10px;
    font-size: 1.1em;
    display: block;
  }
  #sidebar ul li a:hover {
    color: #495371;
    background: #fff;
  }
  #sidebar ul li a i {
    margin-right: 10px;
  }
  #sidebar ul li.active>a,
  a[aria-expanded="true"] {
    color: #fff;
    background: #495371;
  }
  a[data-toggle="collapse"] {
    position: relative;
  }
  .dropdown-toggle::after {
    display: block;
    position: absolute;
    top: 50%;
    right: 20px;
    transform: translateY(-50%);
  }
  ul ul a {
    font-size: 0.9em !important;
    padding-left: 30px !important;
    background: #495371;
  }
  /* ---------------------------------------------------
    CONTENT STYLE
----------------------------------------------------- */
  #content {
    width: 100%;
    padding: 20px;
    min-height: 100vh;
    transition: all 0.3s;
  }
  /* ---------------------------------------------------
    MEDIAQUERIES
----------------------------------------------------- */
  @media (max-width: 768px) {
    #sidebar {
      min-width: 100px;
      max-width: 100px;
      text-align: center;
      margin-left: -100px !important;
    }
    .dropdown-toggle::after {
      top: auto;
      bottom: 10px;
      right: 50%;
      -webkit-transform: translateX(50%);
      -ms-transform: translateX(50%);
      transform: translateX(50%);
    }
    #sidebar.active {
      margin-left: 0 !important;
    }
    #sidebar .sidebar-header h5 {
      display: none;
    }
    #sidebar .sidebar-header strong {
      display: block;
    }
    #sidebar ul li a {
      padding: 20px 10px;
    }
    #sidebar ul li a span {
      font-size: 0.85em;
    }
    #sidebar ul li a i {
      margin-right: 0;
      display: block;
    }
    #sidebar ul ul a {
      padding: 10px !important;
    }
    #sidebar ul li a i {
      font-size: 1.3em;
    }
    #sidebar {
      margin-left: 0;
    }
    #sidebarCollapse span {
      display: none;
    }
  }
</style>
 <style>
   .toast {
    opacity: 1 !important;
}
</style>

</head>
<body>
  <nav id="sidebar" class="active">
    <div class="sidebar-header">
      <h5>Task Management System</h5>
      <strong>TMS</strong>
    </div>
    <ul class="list-unstyled components" id="sbcontent">
      <li class="active"><a href="home"> <i class="fas fa-tachometer-alt"></i> Dashboard
        </a></li>
           <li><a name="#sprintSubmenu" onmousedown="mouseDown(event,this);" onmouseover="over(this)" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle"> <i class="fas fa-clock"></i> Sprint
        </a>
        <ul class="collapse list-unstyled" id="sprintSubmenu">
          <li><a href="addSprint">Add Sprint</a></li>
          <li><a href="listSprints">All Sprints</a></li>
        </ul>
      </li>
      <li><a name="#taskSubmenu" onmousedown="mouseDown(event,this);" onmouseover="over(this)" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle"> <i class="fas fa-tasks"></i> Task
        </a>
        <ul class="collapse list-unstyled" id="taskSubmenu">
          <li><a href="listTasks">My Tasks</a></li>
          <li><a href="taskreport">Task Report</a></li>
        </ul>
      </li>
    
      <li><a name="#settingsSubmenu" onmousedown="mouseDown(event,this);" onmouseover="over(this)" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle"> <i class="fas fa-cog"></i> Settings
        </a>
        <ul class="collapse list-unstyled" id="settingsSubmenu">
          <li><a href="editProfile">Edit Profile</a></li>
          <li><a href="changePassword">Change Password</a></li>
          <li><a href="logoutUser">Logout</a></li>
        </ul>
      </li>
    </ul>
  </nav>
  <script>
    var roleName = "${sessionScope.Role}";
    if (roleName == "Admin") {
      var settings = document.getElementById("settingsSubmenu");
      let adduser = document.createElement("li");
      let a1 = document.createElement("a");
      a1.href = "addUser";
      a1.text = "Add User";
      adduser.append(a1);
      settings.prepend(adduser);
      
      let users = document.createElement("li");
      let a2 = document.createElement("a");
      a2.href = "listUsers";
      a2.text = "All Users";
      users.append(a2);
      settings.prepend(users);
    }
    
    function mouseDown(e,t){
    	e = e || window.event;
    	  switch (e.which) {
    	    case 1: {
    	    	var href = t.getAttribute("name");
    	        if (href) {
    	            t.href = href;
    	        }
    	    	break;
    	    }
    	    case 3: {
    	    	t.removeAttribute("href");
    	    	t.style.cursor = "pointer";
    	    	break;	
    	    } 
    	  }
    }
    
    function over(t){
    	t.removeAttribute("href");
    	t.style.cursor = "pointer";
    }
  </script>
 
</body>
</html>