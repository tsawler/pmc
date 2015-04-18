<%@page language="java" import="com.verilion.database.*, java.sql.*,java.util.*,java.text.*,
org.sourceforge.jxutil.sql.XDisconnectedRowSet, com.verilion.display.HTMLTemplateDb,
java.lang.reflect.Method, com.verilion.utility.*,com.oreilly.servlet.MultipartRequest,
java.io.*, javax.imageio.ImageIO, java.awt.image.BufferedImage"%>
<%@page language="java" import="com.verilion.components.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Untitled Document</title>
</head>

<body>
<%
Chat c = new Chat();
LinkedList<ChatUsers> lst = (LinkedList<ChatUsers>) c.getListOfUsers();

ListIterator itr = lst.listIterator();


while(itr.hasNext()) {
	ChatUsers cu = (ChatUsers) itr.next();
	%>
	<%=cu.getText()%>
	<%
}
%>

</body>
</html>
