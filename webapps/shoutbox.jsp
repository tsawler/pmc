<%@page language="java" import="java.util.*,java.text.*,com.verilion.object.html.modules.ShoutBoxModuleObject"%>
<%
ShoutBoxModuleObject c = new ShoutBoxModuleObject();

String shout = "";
String url = "";
String user = "";

shout = (String) request.getParameter("shout");
url = (String) request.getParameter("url");
user = (String) request.getParameter("user");

if (shout.length() > 0) {
	c.setMostRecentShout("<strong>From:</strong> " + user + "<br />" + shout);
}
response.sendRedirect(url);
%>