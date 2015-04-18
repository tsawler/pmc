<%@include file="header.jsp"%>
<html>
<head>
<title>
Data conversion
</title>
</head>
<body>
<%
String query = "select * from career";
Statement mysqlSt = null;
mysqlSt = mysql_conn.createStatement();
ResultSet mysqlRs = null;
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	String location = "";
	String type = "";
	String title = "";
	String text = "";
	int location_id = 0;
	int type_id = 0;
	location = mysqlRs.getString("Career_Location");
	type = mysqlRs.getString("Career_Type");
	title = mysqlRs.getString("Career_Title");
	text = mysqlRs.getString("Career_Text");
	
	if (location.equalsIgnoreCase("NGL")) {
		location_id = 3;
	} else if (location.equalsIgnoreCase("")) {
		location_id = 1;
	} else if (location.equalsIgnoreCase("NGI")) {
		location_id = 12;
	} else if (location.equalsIgnoreCase("NGV")) {
		location_id = 4;
	} else if (location.equalsIgnoreCase("NGC")) {
		location_id = 8;
	} else if (location.equalsIgnoreCase("NGR")) {
		location_id = 6;
	} else if (location.equalsIgnoreCase("NGO")) {
		location_id = 5;
	} else if (location.equalsIgnoreCase("NGLC")) {
		location_id = 7;
	}
	
	if (type.equalsIgnoreCase("Engineer")) {
		type_id = 1;
	} else if (type.equalsIgnoreCase("Support")) {
		type_id = 3;
	} else {
		type_id = 2;
	}
	String query2 = "insert into careers (career_title, career_text, career_locations_id, career_type) values (?, ?, ?, ?)";
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	String theStrippedText = title.replaceAll("<br>", " ");
	theStrippedText = title.replaceAll("<br />", " ");
	theStrippedText = title.replaceAll("\\<.*?\\>", "");
	theStrippedText = title.replaceAll("&#39;", "'");
	theStrippedText = title.replaceAll("&nbsp;" ," ");
	theStrippedText = title.replaceAll("\n", " ");
	pst.setString(1, title);
	pst.setString(2, text);
	pst.setInt(3, location_id);
	pst.setInt(4, type_id);
	pst.executeUpdate();
	pst.close();
	pst = null;
	%>
	Doing <%=theStrippedText%><br />
	<%
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;
%>
</body>
</html>
<%@include file="footer.jsp"%>