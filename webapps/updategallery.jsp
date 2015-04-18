<%@include file="/PageSecurity.jsp"%>
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
String delete = "";
int id = 0;
GenericTable gt = new GenericTable("gallery_detail");
gt.setConn(conn);
gt.setSSelectWhat("*");

XDisconnectedRowSet drs = new XDisconnectedRowSet();
drs = gt.getAllRecordsDisconnected();
while (drs.next()){
	%>
	<br />
	<%
	try {
		id = 0;
		String username = "";
		id = drs.getInt("gallery_detail_id");
		String img = drs.getString("img");
		
		String tst = img;
		int pos = tst.indexOf("_");
		String myId = tst.substring(0, pos);
		%>
		ID: <%=id%><br />
		img: <%=img%><br />
		customer_id = <%=myId%>
		<%
		GenericTable myGt = new GenericTable("customer");
		myGt.setConn(conn);
		myGt.setSSelectWhat("*");
		myGt.setSCustomWhere("and customer_id = " + myId);
		XDisconnectedRowSet crs = new XDisconnectedRowSet();
		crs = myGt.getAllRecordsDisconnected();
		while (crs.next()) {
			username = crs.getString("username");
		}
		crs.close();
		crs = null;
		myGt.setUpdateWhat("gallery_detail");
		myGt.setSCustomWhere(" and gallery_detail_id = " + id);
		myGt.addSet("username", username, "string");
		myGt.addSet("customer_id", myId + "", "int");
		//myGt.updateRecord();
		myGt.clearUpdateVectors();
		%>
		<br />
Username to use for update: <%=username%><br />
		Id to use for update: <%=myId%><br />
		Id of record to update: <%=id%><br />
		<%
		
	} catch (Exception e) {
		delete += " or gallery_detail_id = " + id + " ";
	}
}
%>
<br /><br />
delete from gallery_detail_test where true <%=delete%>
<%
Statement st = null;
//st.executeUpdate("delete from gallery_detail_test where " + delete);
st.close();
st = null;
%>
</body>
</html>
<%@include file="/footer.jsp"%>
