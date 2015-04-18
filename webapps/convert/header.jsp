<%@page language="java" 
import="javax.activation.DataHandler,
javax.activation.FileDataSource,
com.verilion.database.*, 
java.io.*,
java.sql.*,
java.util.*,
java.text.*,
org.sourceforge.jxutil.sql.XDisconnectedRowSet, 
com.verilion.display.HTMLTemplateDb,
java.lang.reflect.Method, 
com.verilion.database.SingletonObjects,
com.verilion.utility.*"%>
<%
Connection conn = null;
Connection mysql_conn = null;
String dbDriver = "com.mysql.jdbc.Driver";
String dbURL = "jdbc:mysql://192.168.0.100:3306/PMC";
String user = "pmc";
String dbpassword = "p@ce";
try {
try{
	try {
			Class.forName(dbDriver);
			mysql_conn = java.sql.DriverManager.getConnection(dbURL, user, dbpassword);
		} catch (Exception ex) {
			System.out.println(
				"Error conencting to "
					+ dbURL
					+ " with user: "
					+ user
					+ " using password: "
					+ dbpassword);
			mysql_conn = null;
		}
		
		try {
			conn = DbBean.getDbConnection();
	 } catch (Exception e2) {
		e2.printStackTrace();
	   System.out.println(
				"Error conencting to postgres");
			conn = null;
	 }

} catch(Exception e) {
	System.out.println("JSP HEADER EXCEPTION: Could not retrieve a connection:: " + e.getMessage());
	e.printStackTrace();
}
%>