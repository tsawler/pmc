<%@include file="/admin/header.jsp" %>
<%
long lPageGenTime = 0;
long lPageGenTimeEnd = 0;
String userName = "";
String password = "";
String error = "false";
String errorMessage = "";
//session = request.getSession(true);
ResultSet rs = null;
int userId = 0;
String userLoginName = "";
Statement st = null;
lPageGenTime = System.currentTimeMillis();
//check for blank fields
try {
   userName = request.getParameter("username");
   password = request.getParameter("password");
}
catch (Exception npe){   
   error = "true";
   errorMessage = "Your username/password is empty";
   session.setAttribute("loginError", error);
   session.setAttribute("msg", errorMessage);
   response.sendRedirect("index.jsp"); 
}

if (userName.equals("")||userName == null){
   error = "true";
   errorMessage = "Your username is empty";
} else if (password.equals("")||password == null) {
   error = "true";
   errorMessage = "Your password is empty";
}
//check for maxsize
if (userName.length()>100 || password.length()>100) {
   error = "true";
   errorMessage = "Your username or password are too long";
}
if (error.equals("true")){
   //redirect to memberLogin
   session.setAttribute("msg", errorMessage);
   response.sendRedirect("index.jsp");      
}
else {   
	int customer_id = -1;
	
	String sqlQuery = "select ce.customer_email, "
		+ "c.customer_id, "
		+ "c.customer_password, "
		+ "c.customer_access_level, "
		+ "c.customer_first_name "
		+ "from customer_email_detail as ce, "
		+ "customer as c "
		+ "where ce.customer_email = '"
		+ userName
		+ "' "
		+ "and c.customer_id = ce.customer_id "
		+ "and ce.customer_email_default_yn = 'y'";
	
	boolean okay = false;

	try {
		st = conn.createStatement();
		rs = st.executeQuery(sqlQuery);
		if (rs.next()) {
			String pass = rs.getString("customer_password");
			if (pass.equals(password)) {
			   okay = true;
			   customer_id = rs.getInt("customer_id");
			   userLoginName = rs.getString("customer_first_name");
			   session.setAttribute("userAdminId", Integer.toString(customer_id));
			   session.setAttribute("customer_id", Integer.toString(customer_id));
			   session.setAttribute("userAdminName", userLoginName);
			   session.setAttribute("customer_access_level", rs.getInt("customer_access_level") + "");
			}
		}
		rs.close();
		rs = null;
		st.close();
		st = null;
	
	} catch (SQLException e) {
		throw new ServletException("Login:doLogin:SQLException:"
		   + e.toString());
	} finally {
		if (rs != null) {
			rs.close();
			rs = null;
		}
		if (st != null) {
			st.close();
			st = null;
		}
	}
	
	if (customer_id > 0) {
		// get the user's roles
		sqlQuery = "select role_id from user_role where customer_id = '" + customer_id + "'";
		String[] roles = new String[10];
		int j = 0;
		st = conn.createStatement();
		rs = st.executeQuery(sqlQuery);
		while (rs.next()) {
			//System.out.println("adding role " + rs.getString(1));
			roles[j] = rs.getString(1);
			j++;
		}
		for (int i = j; i < 10; i++) {
			roles[i] = "0";
		}
		rs.close();
		rs = null;
		st.close();
		st = null;
		session.setAttribute("roles", roles);
		response.sendRedirect("/admin/jpage/1/p/Welcome/admin/1/content.do");
		return;
	} else {
		response.sendRedirect("index.jsp");
		return;
	}
}

%>
<%@include file="../admin/footer.jsp" %>
