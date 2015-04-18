<%@page language="java" import="com.verilion.database.*, java.sql.*,java.util.*,java.text.*,
org.sourceforge.jxutil.sql.XDisconnectedRowSet, com.verilion.display.HTMLTemplateDb,
java.lang.reflect.Method, com.verilion.utility.*,com.oreilly.servlet.MultipartRequest,
java.io.*, javax.imageio.ImageIO, java.awt.image.BufferedImage"%>
<%
java.util.Date today;
GregorianCalendar x = new GregorianCalendar();
today = new java.util.Date();
int year = x.get(Calendar.YEAR);
int month = x.get(Calendar.MONTH);
month = month + 1;
int day = x.get(Calendar.DAY_OF_MONTH);
int hour = x.get(Calendar.HOUR_OF_DAY);
int minute = x.get(Calendar.MINUTE);
int second = x.get(Calendar.SECOND);
		
%>
<%=year%>-<%=month%>-<%=day%> <%=hour%>:<%=minute%>:<%if (second < 10){%>0<%}%><%=second%>