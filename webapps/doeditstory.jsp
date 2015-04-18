<%@page language="java" import="com.verilion.database.*, java.sql.*,java.util.*,java.text.*,
org.sourceforge.jxutil.sql.XDisconnectedRowSet, com.verilion.display.HTMLTemplateDb,
java.lang.reflect.Method, com.verilion.utility.*,com.oreilly.servlet.MultipartRequest,
java.io.*, javax.imageio.ImageIO, java.awt.image.BufferedImage"%>

<%

Connection conn = null;
int story_id = 0;
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
	 
	 
	story_id = Integer.parseInt((String) request.getParameter("story_id"));
	category_id = Integer.parseInt((String) request.getParameter("story_cat_id"));
	title = (String) request.getParameter("subject");
	story = (String) request.getParameter("comment");
	story = story.replaceAll("\n","<br />");
	del = Integer.parseInt((String) request.getParameter("del"));
	if (del == 0){
		GenericTable myTable = new GenericTable();
		myTable.setConn(conn);
		myTable.setUpdateWhat("pmc_stories");
		myTable.addSet("title", title, "string");
		myTable.addSet("story_topic_id", category_id + "", "int");
		myTable.addSet("story", story, "string");
		myTable.setSCustomWhere("and story_id = " + story_id);
		myTable.updateRecord();
		
		try {
			// close connection
			DbBean.closeDbConnection(conn);
			conn = null;
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		
		session.setAttribute("Error", "Changes saved");
		response.sendRedirect("/postings/jpage/1/p/Postings/content.do");
	} else {
		GenericTable myTable = new GenericTable();
		myTable.setConn(conn);
		myTable.setSTable("pmc_stories_comments");
		myTable.setSCustomWhere("and story_id = " + story_id);
		myTable.deleteRecords();
		
		myTable.setSTable("pmc_stories");
		myTable.setSCustomWhere("and story_id = " + story_id);
		myTable.deleteRecords();
		
		try {
			// close connection
			DbBean.closeDbConnection(conn);
			conn = null;
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		
		session.setAttribute("Error", "Deleted");
		response.sendRedirect("/postings/jpage/1/p/Postings/content.do");
	}
} catch (Exception e){
	e.printStackTrace();
}
%>