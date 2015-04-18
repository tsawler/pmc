<%@include file="/PageSecurity.jsp"%>
<%
int id = 0;
int a = 0;
XDisconnectedRowSet drs = new XDisconnectedRowSet();

try {
	id = Integer.parseInt((String) request.getParameter("id"));
} catch (Exception e){
	id = 0;
}
GenericTable myTableObject = new GenericTable(" links ");
myTableObject.setConn(conn);
myTableObject.setSSelectWhat(" * ");
myTableObject.setSCustomOrder(" order by title");
myTableObject.setSCustomWhere(" and active_yn = 'y' and link_cat_id = " + id + " ");

drs = myTableObject.getAllRecordsDisconnected();

 while (drs.next()) {%>
	<div>&nbsp;</div><h2><a href="<%=drs.getString("url")%>" target="_blank" title="Click to open site in a new browser window"><%=drs.getString("title")%></a></h2>
	<div><%=drs.getString("description")%></div>
	<%
 }
 drs.close();
 drs = null;
%>
<%@include file="/footer.jsp"%>
