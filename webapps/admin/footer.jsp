	<%
	try{
		DbBean.closeDbConnection(conn);
		conn = null;
	} catch(Exception e){
		System.out.println("JSP HEADER EXCEPTION: Could not return the connection:: " + e.getMessage());
		e.printStackTrace();  	
	}
	lPageGenTimeEnd = System.currentTimeMillis() - lPageGenTime;
	%>
	<!-- time to generate: <%=(lPageGenTimeEnd / 1000f)%> seconds -->
	<%
} catch (Exception e) {
	e.printStackTrace();
} finally {
	if (conn != null) {
		conn.close();
		conn = null;
	}
}
%>
