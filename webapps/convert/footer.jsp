	<%
	try{
	  conn.close();
	  conn = null;
		mysql_conn.close();
		mysql_conn = null;
	} catch(Exception e){
		System.out.println("JSP HEADER EXCEPTION: Could not return the connection:: " + e.getMessage());
		e.printStackTrace();  	
	}

} catch (Exception e) {
	e.printStackTrace();
} finally {
	if (mysql_conn != null) {
		mysql_conn.close();
		mysql_conn = null;
	}
	if (conn != null) {
		conn.close();
		conn = null;
	}
}
%>
