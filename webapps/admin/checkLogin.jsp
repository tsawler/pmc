<%
int userId = 0;
int validRole = 0;

try {
	//session = request.getSession(true);
	String sThisPage = "";
	
	/*
	if ((session.getAttribute("userAdminId") == null) || (session.getAttribute("userAdminName") == null)) {
		session.setAttribute("msg", "Invalid access to requested page.");
		response.sendRedirect("index.jsp");
		return;
	}
   	userId = new Integer((String)session.getAttribute("userAdminId")).intValue();
	if (userId == 0) {
		session.setAttribute("msg", "Invalid access to requested page.");
		response.sendRedirect("index.jsp");
		return;
	}
	String test = request.getRequestURI();
	if (test.lastIndexOf("?") < 0) {
		sThisPage = test.substring((test.lastIndexOf("/") + 1), test.length());
	} else {
		sThisPage = test.substring((test.lastIndexOf("/") + 1), (test.lastIndexOf("?") - 1));
	}
	
	// now get the roles for this page, to see if we are allowed to be here
	
	if (!sThisPage.equals("Error.jsp")) {
	Admin.setDb(serverConn);
	validRole = Admin.CheckRole(userId + "", sThisPage);

		if (validRole < 1) {
			session.setAttribute("msg", "Invalid access to requested page.");
			response.sendRedirect("index.jsp");
			return;
		}
	}
	*/
	
	
} catch (Exception e) {
	System.out.println("Error in check -- " + e.toString());
	session.setAttribute("msg", "Invalid access to requested page.");
	response.sendRedirect("index.jsp");
	return;
}
%>