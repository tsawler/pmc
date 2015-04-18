<%@include file="/PageSecurity.jsp"%>
<%
Enumeration en = null;
en = request.getParameterNames();
while (en.hasMoreElements()) {
	String theElementName = (String) en.nextElement();
	if (theElementName.startsWith("del_")) {
		String theId = theElementName.substring(theElementName.lastIndexOf("_") + 1, theElementName.length());
		try {
			Statement st = null;
			st = conn.createStatement();
			String query = "delete from customer_messages_sent where customer_message_sent_id = " + theId + " and from_user_id = '" + session.getAttribute("customer_id") + "'";
			st.executeUpdate(query);
			st.close();
			st = null;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
response.sendRedirect("/messages/jpage/1/p/messages/content.do");
%>
<%@include file="/footer.jsp"%>