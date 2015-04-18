<%
	try {
			// close connection
			DbBean.closeDbConnection(conn);
			conn = null;
	} catch (Exception e2) {
			e2.printStackTrace();
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
