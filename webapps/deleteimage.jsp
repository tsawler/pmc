<%@page language="java" import="com.verilion.database.*, java.sql.*,java.util.*,java.text.*,
org.sourceforge.jxutil.sql.XDisconnectedRowSet, com.verilion.display.HTMLTemplateDb,
java.lang.reflect.Method, com.verilion.utility.*,com.oreilly.servlet.MultipartRequest,
java.io.*, javax.imageio.ImageIO, java.awt.image.BufferedImage"%>

<%

Connection conn = null;
int image_id = 0;
int category_id = 0;
String title = "";
String story = "";
int del = 0;
session = request.getSession();

try {
	try {
		conn = DbBean.getDbConnection();
	 } catch (Exception e2) {
		e2.printStackTrace();
	 }
	 
	image_id = Integer.parseInt((String) request.getParameter("id"));
	GenericTable myTable = new GenericTable();
	myTable.setConn(conn);
	myTable.setSTable("gallery_detail");
	myTable.setSCustomWhere("and gallery_detail_id = " + image_id);
	myTable.deleteRecords();
	
	try {
			// close connection
			DbBean.closeDbConnection(conn);
			conn = null;
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		
		session.setAttribute("Error", "Deleted");
		response.sendRedirect("/images/jpage/1/p/images/content.do");


} catch (Exception e){
	e.printStackTrace();
}
%>