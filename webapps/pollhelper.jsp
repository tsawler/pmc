<%@include file="/PageSecurity.jsp"%>
<%
int id = 0;
String thePoll = "";
int number_voters = 0;
XDisconnectedRowSet drs = new XDisconnectedRowSet();
XDisconnectedRowSet crs = new XDisconnectedRowSet();
NumberFormat pf = DecimalFormat.getPercentInstance(); 
pf.setMaximumFractionDigits(2);

try {
	id = Integer.parseInt((String) request.getParameter("id"));
} catch (Exception e){
	id = 0;
}

if (id == 0) {
	Statement st = null;
	st = conn.createStatement();
	ResultSet rs = null;
	rs = st.executeQuery("select max(poll_id) from polls");
	if (rs.next()) {
		id = rs.getInt(1);
	}
	rs.close();
	rs = null;
	st.close();
	st = null;
}
GenericTable myPoll = new GenericTable("polls");
myPoll.setConn(conn);
myPoll.setSSelectWhat("number_voters, title");
myPoll.setSCustomWhere("and poll_id = " + id);
crs = myPoll.getAllRecordsDisconnected();
while (crs.next()) {
	number_voters = crs.getInt("number_voters");
	thePoll = crs.getString("title");
}
crs.close();
crs = null;

GenericTable myTableObject = new GenericTable(" polls_data ");
myTableObject.setConn(conn);
myTableObject.setSSelectWhat(" * ");
myTableObject.setSCustomOrder(" order by polls_data_id");
myTableObject.setSCustomWhere(" and poll_id =" + id);

drs = myTableObject.getAllRecordsDisconnected();
%>
<div style="text-align: center">
<strong><%=thePoll%></strong> (<%=number_voters%> votes)<br /><br />
<table align="center">
<%
while (drs.next()) {%>
	<tr>
	<td style="text-align: left; width:156px;" valign="middle"><%=drs.getString("poll_option_text")%>&nbsp;&nbsp;</td>
	<td style="width: 270px; text-align: left;" valign="middle">
	<%
	int width = 220;
	float floatWidth = width;
	if (number_voters > 0) {
		float pct = 0.0f;
		float voteCount = drs.getInt("poll_option_count");
		float voteTotal = number_voters;
		pct = voteCount / voteTotal;
		float pctWidth = floatWidth * pct;
		width = (int) pctWidth;
		%>
		<img src="/images/onepixel.gif" height="15" width="<%=width%>" /> <%=pf.format(pct)%>
		<%
	} else {
		%>
		<img src="/images/onepixel.gif" height="15" width="1" /> 0.0%
		<%
	}
	%>
	</td>
	</tr>
	<%
 }
 drs.close();
 drs = null;
%>
</table>
</div>
<div>&nbsp;</div>
<%@include file="/footer.jsp"%>
