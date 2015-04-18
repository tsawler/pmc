<%@include file="/PageSecurity.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<%@taglib uri="/WEB-INF/vtags.tld" prefix="v"%>
<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="oscache" %>
<v:gtag />
	<title>Pacemaker Club: Support &amp; Information For Pacemaker &amp; Defibrillator Patients</title>
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.2.0/build/reset-fonts-grids/reset-fonts-grids.css"> 
<script type="text/javascript">
    var GB_ROOT_DIR = "http://www.pacemakerclub.com/greybox/";
</script>
<script type="text/javascript" src="/greybox/AJS.js"></script>
<script type="text/javascript" src="/greybox/AJS_fx.js"></script>
<script type="text/javascript" src="/greybox/gb_scripts.js"></script>
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/yahoo-dom-event/yahoo-dom-event.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/container/container_core-min.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/animation/animation-min.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/menu/menu-min.js"></script> 
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.2.0/build/menu/assets/menu.css"> 
<link rel="stylesheet" type="text/css" href="/styles.css">
<link href="/greybox/gb_styles.css" rel="stylesheet" type="text/css">
<%=sJavaScript%>
</head>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ page import="org.displaytag.sample.*,
                 org.displaytag.tags.TableTag,
                 org.apache.commons.beanutils.*" %>
<%
String username = "";
String fromWhere = "";
String customwhere = "where true ";
Statement st = null;
ResultSet rs = null;
RowSetDynaClass resultset = null;
String query = "";
int cid = 0;
String model = "";
int ct_country_id = 0;
String city = "";
String theUserName = "";
int ct_province_state_id = 0;
String interest = "";
int device_type = -1;

try {
	cid = Integer.parseInt((String) request.getParameter("id"));
} catch (Exception e) {
	cid = 0;
}
if (request.getParameter("username") != null) {
	username = request.getParameter("username");
	customwhere += " and username ilike '" + username + "%' ";
}
if (request.getParameter("ct_country_id") != null) {
	try {
		ct_country_id = Integer.parseInt((String) request.getParameter("ct_country_id"));
		if (ct_country_id > 0)
			customwhere += " and ct_country_id =" + ct_country_id;
	} catch (Exception e) {
		ct_country_id = 0;
	}
}
if (request.getParameter("ct_province_state_id") != null) {
	ct_province_state_id = Integer.parseInt((String) request.getParameter("ct_province_state_id"));
	if (ct_province_state_id > 0) {
		customwhere += " and ct_province_state_id = " + ct_province_state_id;
	}
}
if (request.getParameter("city") != null) {
	city = (String) request.getParameter("city");
	customwhere += " and customer_town_city ilike '" + city + "%' ";
}
if (request.getParameter("model") != null) {
	model = (String) request.getParameter("model");
	customwhere += " and model ilike '" + model + "%' ";
}
if (request.getParameter("from") != null) {
	fromWhere = request.getParameter("from");
	customwhere += " and from_where ilike '%" + fromWhere + "%' ";
}
if (request.getParameter("device_type") != null) {
	device_type = Integer.parseInt((String) request.getParameter("device_type"));
	if (device_type >= 0) {
		customwhere += " and device_type = " + device_type;
	}
}
if (request.getParameter("interest") != null) {
	interest = (String) request.getParameter("interest");
	if (interest.length() > 0) {
		customwhere += " and interests ilike '%" + interest + "%' ";
	}
}
if (request.getParameter("newest") == null) {
	query = "select customer_id, username, "
		+ "implant_year, from_where, device_brand, avatar,"
		+ "number_of_devices "
		+ "from v_pmc_customer "
		+ customwhere
		+ " order by username";
		//System.out.println("query: " + query);
} else {
	query = query = "select customer_id, username, "
		+ "implant_year, from_where, device_brand, avatar,"
		+ "number_of_devices "
		+ "from v_pmc_customer "
		+ "order by customer_registration_date desc limit 20";
}
st = conn.createStatement();
rs = st.executeQuery(query);
resultset = new RowSetDynaClass(rs, false);
rs.close();
rs = null;
st.close();
st = null;
request.setAttribute("results", resultset);

if (request.getParameter("uname") != null) {
	String uname = request.getParameter("uname");
	query = "select customer_id from customer where username = '"
		+ uname
		+ "'";
	st = conn.createStatement();
	rs = st.executeQuery(query);
	if (rs.next()){
		cid = rs.getInt(1);
	}
	rs.close();
	rs = null;
	st.close();
	st = null;
}
%>
<body id="yahoo-com">
<div id="doc" class="yui-t1">
<v:banner position_id="1" conn="<%=conn%>" />
	<div id="hd" class="topofpage"><!--header-->
		<div id="topmenu"><v:mainmenutag conn="<%=conn%>" menutag="Top Menu" /></div>
	</div>
	<div id="bd" class="middle">
		<div id="yui-main">
			<div class="yui-b">
				<div class="yui-ge">
					<div class="yui-u first"><!-- content div -->
							<v:message />
							<h1><%=page_detail_title%></h1>
							<br />
							<v:googlead 
								publisher_id="pub-8849439696468095"
								w="234"
								h="60"
								ad_format="234x60_as"
								border_color="b30000"
								bg_color="ffffff"
								link_color="b30000"
								text_color="000000"
								url_color="b30000" />
								<br />
		<%
		if (cid == 0) {
		%>
							<div align="center">
		<fieldset>
		<legend>Find Members</legend>
		<form method="post" id="searchform" action="/members/jpage/1/p/MemberDirectory/content.do">
		<table class="tabledata" style="width: 90%">
		  <tr>
		    <td>Username</td>
			<td>Model</td>
			<td>City</td>
			<td>State/Prov</td>
		  </tr>
		  <tr>
		    <td><input type="text" name="username" id="username" class="inputbox" size="15" value="<%=username%>" /></td>
			<td><input type="text" class="inputbox" name="model" size="10" value="<%=model%>" /></td>
			<td><input type="text" name="city" value="<%=city%>" class="inputbox" /></td>
			<td>
			<%
			st = conn.createStatement();
			rs = st.executeQuery("select * from ct_province_state");
			%>
			<select class="inputbox" name="ct_province_state_id">
			<option value="0" <%if (ct_province_state_id == 0){%> selected <%}%>></option>
			<%
			while (rs.next()){
			%>
			<option value="<%=rs.getInt("ct_province_state_id")%>" <%if (rs.getInt("ct_province_state_id") == ct_province_state_id){%> selected <%}%>><%=rs.getString("ct_province_state_abb")%></option>
			<%
			}
			%>
			</select>
			</td>
			</tr>
			<tr>
			<td colspan="4">Interests</td>
			</tr>
			<tr>
			<td colspan="3"><input type="text" name="interest" value="<%=interest%>" size="40" class="inputbox"></td>
			</tr>
			<tr>
			<td colspan="3">Country</td>
			<td>&nbsp;</td>
			</tr>
			<tr>
			<td colspan="3">
			<%
			st = conn.createStatement();
			rs = st.executeQuery("select * from ct_country");
			%>
			<select name="ct_country_id" class="inputbox">
			<option value="0"  <%if (ct_country_id == 0){%> selected <%}%>>Any</option>
			<%
			while (rs.next()){
			%>
			<option value="<%=rs.getInt("ct_country_id")%>" <%if (rs.getInt("ct_country_id") == ct_country_id){%> selected <%}%>><%=rs.getString("ct_country_name")%></option>
			<%
			}
			rs.close();
			rs = null;
			st.close();
			st = null;
			%>
			</select>
			</td>
			<td>&nbsp;<input type="submit" value="Search" class="inputbox" /></td>
		  </tr>
		  </table>
		  <br />
		  <a href="/members/jpage/1/p/MemberDirectory/content.do?newest=1">Show 20 newest members</a>
		  </form>
		  </fieldset>
</div>
							<div>&nbsp;</div>
							<display:table name="requestScope.results.rows" requestURI="/members/jpage/1/p/MemberDirectory/content.do" export="false" defaultsort="4" id="msgTable" pagesize="20"  class="tabledatacollapse" style="width: 100%" >
			 <display:column property="username" title="Username" href="#" paramId="id" paramProperty="customer_id" sortable="true" headerClass="sortable" />
			  <display:column property="number_of_devices" title="No. Devices" />
			  <display:column property="implant_year" title="Implant Year"  />
			  <display:column property="device_brand" title="Manufacturer"  />
			  <display:setProperty name="export.pdf" value="false" />
			</display:table>
			<%
			} else {
				query = "select customer_id, username, occupation, interests, bio, ct_country_name, ct_province_state_name, customer_town_city, birth_year, "
					+ "implant_year, from_where, avatar, device_brand, device_type, model, "
					+ "number_of_devices "
					+ "from v_pmc_customer "
					+ "where customer_id = "
					+ cid;
				st = conn.createStatement();
				rs = st.executeQuery(query);
				if (rs.next()) {
			%>
			<h2>Member Profile for <%=rs.getString("username")%></h2>
			<a href="/messages/jpage/1/p/messages/content.do?reply=1&tab=compose&repto=<%=rs.getString("username")%>&subject=enter subject">&nbsp;<img src="/images/sendpm.gif" border="0" height="17" width="24" alt="pm" title="Send a private message to <%=rs.getString("username")%>"> Send a private message to <%=rs.getString("username")%></a>.
			<div>&nbsp;</div>
			<div>
			<%
			theUserName = rs.getString("username");
			if (rs.getString("avatar").equalsIgnoreCase("default_avatar.png")) {%>
            <img src="/avatars/default_avatar.png" height="48\" width="48" alt="avatar image" /><br /><br />
			<%
         } else {
		 %>
            <img src="/avatars/<%=rs.getString("avatar")%>" alt="avatar image" /><br /><br />
				  <%
         }%>
		 		<strong>Device Type:</strong>
				<%
				if (rs.getInt("device_type") == 0) {
					%>
					n/a
					<%
				} else if (rs.getInt("device_type") == 2) {
					%>
					Defibrillator
					<%
				} else {
					%>
					Pacemaker
					<%
				}
				%><br />
				<strong>Manufacturer:</strong> <%=rs.getString("device_brand")%><br />
				<strong>Model:</strong> <%=rs.getString("model")%><br />
				<strong>Implant Year:</strong> <%=rs.getString("implant_year")%><br />
				<strong>Number of Devices:</strong> <%=rs.getString("number_of_devices")%><br />
				<strong>Country:</strong> <%=rs.getString("ct_country_name")%><br />
				<strong>Province/State:</strong> <%=rs.getString("ct_province_state_name")%><br />
				<strong>Town/City:</strong> <%=rs.getString("customer_town_city")%><br />
				<strong>Year of Birth:</strong> <%=rs.getString("birth_year")%><br />
				<strong>Occupation:</strong> <%=rs.getString("occupation")%><br />
				<strong>Interests:</strong><br />
				<%=rs.getString("interests")%><br />
				<div>&nbsp;</div>
				<strong>Bio:</strong><br/>
				<%=rs.getString("bio")%>
			</div>
			<%
			} 
			rs.close();
			rs = null;
			st.close();
			st = null;
			}
			%>
			<%
			if (cid > 0){
			%>
			<br /><br />
			<strong>Member's Photos</strong>: <a href="/membergallery/jpage/1/p/MemberGallery/content.do?id=1&username=<%=theUserName%>&exact=1">View photos</a>
			<br />
			<br />
			Most recent messages  by this member:
			<%
			GenericTable myTable = new GenericTable("pmc_stories");
			myTable.setConn(conn);
			myTable.setSSelectWhat("'<a href=\"/public/jpage/1/p/story/a/storypage/sid/' || story_id || '/content.do\">' || title || '</a>' as url");

			myTable.setSCustomWhere("and posted_by = (select username from customer where customer_id = '"
				+ cid
				+ "')");
			myTable.setSCustomOrder(" order by datetime desc");
			myTable.setSCustomLimit(" limit 10 " );
			RowSetDynaClass resultset2 = myTable.getAllRecordsDynaBean();
			request.setAttribute("results2", resultset2);
			%>
			
			<display:table name="requestScope.results2.rows" export="false" id="postTable" pagesize="10"  class="tabledatacollapse" style="width: 100%" >
			 <display:column property="url" title="Message Subject" />
			  <display:setProperty name="export.pdf" value="false" />
			</display:table>
							<br />
							<br />
			Most recent comments by this member:
			<%
			myTable.setConn(conn);
			myTable.setSTable("pmc_stories_comments");
			myTable.setSSelectWhat("'<a href=\"/public/jpage/1/p/story/a/storypage/sid/' || story_id || '/content.do\">' || subject || '</a>' as url");
	
			//myTable.setSCustomWhere("and username = '" + username + "'");
			myTable.setSCustomWhere("and username = '" + theUserName + "'");
			myTable.setSCustomOrder(" order by datetime desc");
			myTable.setSCustomLimit(" limit 10 " );
			RowSetDynaClass resultset3 = myTable.getAllRecordsDynaBean();
			request.setAttribute("results3", resultset3);
			%>
			<display:table name="requestScope.results3.rows" export="false" id="commentTable" pagesize="10"  class="tabledatacollapse" style="width: 100%" >
			 <display:column property="url" title="Comment" />
			  <display:setProperty name="export.pdf" value="false" />
			</display:table>
			
							<%
							}
							%>
					</div><!-- hello -->

					<div class="yui-u rightcol" style="margin-right: 4px;"><!-- rightmost -->
						<v:moduletag conn="<%=conn%>" position="1" />
						<v:banner position_id="2" conn="<%=conn%>" numberOfBanners="1" /><br>
						<v:banner position_id="11" conn="<%=conn%>" numberOfBanners="1" />
						<br />
						<br />
					</div>
				</div>
			</div>
		</div>
		<div class="yui-b leftmost"><!-- leftmost column -->
			<v:mainmenutag conn="<%=conn%>" menutag="Main Menu" />
				<br />
				<v:banner position_id="3" conn="<%=conn%>" numberOfBanners="1" />
				<br />
				<v:mainmenutag conn="<%=conn%>" menutag="Information Menu" />
				<br />
				<v:banner position_id="10" conn="<%=conn%>" numberOfBanners="1" />
				<br />
				<v:mainmenutag conn="<%=conn%>" menutag="Messages Menu" />
				<v:banner position_id="9" conn="<%=conn%>" numberOfBanners="1" />
				<v:moduletag conn="<%=conn%>" position="2" />
		</div>
	</div>
	<div id="ft" class="bottom">
		<div id="copyrightmenu"><v:mainmenutag conn="<%=conn%>" menutag="Copyright" /></div>
	</div>
	<div class="bottombanner"><v:banner position_id="4" conn="<%=conn%>" /></div>
	<%
	int this_year = Calendar.getInstance().get(Calendar.YEAR);
	%>
	<div style="text-align: center; font-size: 80%">Site content and design &copy; 2000-<%=this_year%> Pacemaker Club Inc. <br />All rights reserved.</div>
</div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-15057244-1");
pageTracker._trackPageview();
} catch(err) {}</script>
</body>
</html>
<%@include file="/footer.jsp" %>
