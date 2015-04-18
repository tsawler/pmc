<%@include file="header.jsp"%>
<html>
<head>
<title>
Data conversion
</title>
</head>
<body>
<%
String query2 = "";
try {
FileInputStream fstream = new FileInputStream("/home/httpd/dev.pacemakerclub.com/html/convert/countries.txt");
DataInputStream in = new DataInputStream(fstream);

while (in.available() !=0) {
  String theCountry = in.readLine();
  PreparedStatement ppst = null;
	ppst = conn.prepareStatement("insert into ct_country (ct_country_name) values (?)");
	ppst.setString(1, theCountry);
	ppst.executeUpdate();
	ppst.close();
	ppst = null;
}
in.close();



} catch (Exception e) {
	e.printStackTrace();
}
%>
Done.
</body>
</html>
<%@include file="footer.jsp"%>