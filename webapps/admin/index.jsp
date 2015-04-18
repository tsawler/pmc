<%
String error = "";
String errorMessage = "";
int userId = 0;

int validRole = 0;
String sThisPage = "";

try {
   
   String test = request.getRequestURI();
   if (test.lastIndexOf("?") < 0) {
   		sThisPage = test.substring((test.lastIndexOf("/") + 1), test.length());
 	} else {
		sThisPage = test.substring((test.lastIndexOf("/") + 1), (test.lastIndexOf("?") - 1));
	}

	// now get the roles for this page, to see if we are allowed to be here
	//Admin.setDb(serverConn);
	//validRole = Admin.CheckRole(userId + "", sThisPage);
	validRole = 1;
	if (validRole > 0) {
   
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>vMaintain Admin tool</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel="stylesheet" href="/admin/adminstyles.css" type="text/css"  />
<script type="text/javascript" src="/js/editor/fckeditor.js"></script>
<script>
<!--
function sf(){document.memberLogin.username.focus();}
// -->
</script>
</head>

<body class="treenavpage" style="height: 100%;" onload="sf()">
&nbsp;
<table cellpadding="2" cellspacing="0" style="border: 1px solid silver; height: 95%; width: 100%;">
  <tr style="height: 15px;">
    <td colspan="2" class="treetoplevel" style="border: 1px solid silver;">vMaintain
    Admin tool<br /></td>
  </tr>
  <tr>
    <td width="17%" class="tableheader" style="text-align: left; border: 1px solid silver;" valign="top"><strong>Main Menu</strong><br />
        <br />
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabledata">
          <tr>
            <td><a href="/">To public site</a></td>
          </tr>
        </table>       
    </td>
    <td class="tabledata" style="border: 1px solid silver;" valign="top" width="83%" cellpadding="0" cellspacing="0">
        <table style="border-bottom: 1px solid silver; height: 100%; width: 100%"  cellpadding="2" cellspacing="0">
        <tr style="height: 15px;">
        <td class="tableheader">Verilion vMaintain  Application Login</td>
        </tr>
        <tr style="height: 15px;"><td class="tabledata">
        <% if (session.getAttribute("msg") != null) {
                %><div style="color: red; text-align: center"><strong><%=(String)session.getAttribute("msg")%></strong></div><% session.removeAttribute("msg");} else {%>&nbsp;<%}%>
        </td></tr>
        <tr><td class="tabledata" valign="top">
		  <div align="center">
          <form method=post name="memberLogin" action="/admin/processLogin.jsp">
		  <br /> 
		  <br />
		  <table border="0" class="tabledatacollapse">
                <tr>
                  <td width="50%"><div align="right">Username: </div></td>
                  <td><input class="inputbox" id="username" type="text" name="username" value=""></td>
                </tr>
                <tr>
                  <td width="50%"><div align="right">Password: </div></td>
                  <td><input class="inputbox" id="password" type="password" name="password" value=""></td>
                </tr>
                <tr>
                  <td width="50%"></td><td><div align="left">
                    <input class="inputbox" name="submit" type="submit" value="Login">
                  </div></td>
                </tr>
              </table>
		    
          </form>
		  <br /><br />
		  This is a restricted, private site. Only those persons who are explicitly authorized may access this site.<br />
		  Unauthorized access by any and all other persons is strictly prohibited.
		  </div>
		  </td>
        </tr></table>
    </td>
  </tr>
  <tr style="height: 15px">
    <td class="treetoplevel" colspan="2" style="text-align: right; border: 1px solid silver;">Copyright
      2003-2005 &copy; Verilion
      Inc.</td>
  </tr>
</table>
</body>
</html>
<%

} else {
error = "true";
   errorMessage = "You are not authorized to access the requested page.";
   session.setAttribute("msg", errorMessage);
   response.sendRedirect("Admin.jsp");
}
}
catch (Exception e){
	e.printStackTrace();
   error = "true";
   errorMessage = "Please login";
   session.setAttribute("loginError", error);
   session.setAttribute("loginErrorMessage", errorMessage);
   response.sendRedirect("index.jsp");
}
%>
