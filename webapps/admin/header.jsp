<%@page language="java" import="java.sql.*,java.util.*,java.text.DecimalFormat, com.oreilly.servlet.MultipartRequest, 
org.sourceforge.jxutil.sql.*,com.verilion.database.*"%>
<%
Connection conn = null;
try {
try{
	conn = DbBean.getDbConnection();
} catch(Exception e) {
	System.out.println("JSP HEADER EXCEPTION: Could not retrieve a connection:: " + e.getMessage());
	e.printStackTrace();
}
%>