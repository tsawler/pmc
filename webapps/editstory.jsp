<%@include file="/PageSecurity.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@taglib uri="/WEB-INF/vtags.tld" prefix="v"%>
<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="oscache" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ page import="org.displaytag.sample.*,
                 org.displaytag.tags.TableTag,
                 org.apache.commons.beanutils.*" %>
<v:gtag />
<title>Pacemaker Club: Support &amp; Information For Pacemaker &amp; Defibrillator Patients</title>
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.2.0/build/reset-fonts-grids/reset-fonts-grids.css"> 

<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.0/jquery.validate.min.js"></script>
<script type='text/javascript'>
$(document).ready(function () {
	setInterval(function(){keepAlive();}, 120000);
	$("#bookform").validate();
});

function keepAlive(){
	$.ajax({
		url: '/keepalive.jsp',
		cache: false
	});
}

function submitForm() {
	var okay = false;
	okay = $("#bookform").validate().form();
	if (okay){
		document.bookform.submit();
	}
}

function handledelete(){
	var r=confirm("Are you sure you want to delete this post?");
	if (r==true) {
		$("#del").val(1);
		$("#subject").removeClass("required");
		$("#comment").removeClass("required");
		$("#bookform").submit();
	}
}
</script>
<style>
	.error { color: red; }
</style>
<link rel="stylesheet" type="text/css" href="/styles.css">
<%=sJavaScript%>
</head>
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
							<h1>Edit Post</h1>
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
							int story_id = 0;
							story_id = Integer.parseInt((String) request.getParameter("id"));
							GenericTable myTable = new GenericTable("pmc_stories");
							myTable.setConn(conn);
							myTable.setSSelectWhat("*");

							myTable.setSCustomWhere("and story_id = " + story_id);
							myTable.setSCustomOrder(" order by datetime desc");
							XDisconnectedRowSet rs = new XDisconnectedRowSet();
							rs = myTable.getAllRecordsDisconnected();
							String title = "";
							String message = "";
							int category_id = 0;
							while (rs.next()){
								title = rs.getString("title");
								message = rs.getString("story");
								category_id = rs.getInt("story_topic_id");
							}
							message = message.replaceAll("<br />", "\n");
							message = message.replaceAll("\t", "");
							%>
							
	
							<form name="bookform" id="bookform" method="post" action="/doeditstory.jsp">
							<input type="hidden" name="story_id" value="<%=story_id%>">
							<input type="hidden" name="del" value="0" id="del">
							<table style="width: 100%">
							<tr>
							<td style="width: 25%">Title:</td>
							<td><input type="text" class="inputbox required" name="subject" maxlength="50" id="subject" size="30" value="<%=title%>">
							</td>
							</tr>
							<tr>
							<td>Post in:</td>
							<td>
							<select class="inputbox" name="story_cat_id" id="story_cat_id">
							<%
							myTable.clearUpdateVectors();
							myTable = new GenericTable("pmc_story_category");
							myTable.setConn(conn);
							myTable.setSSelectWhat("story_category_id, category_text");
							myTable.setSCustomWhere("and story_category_active_yn = 'y'");
							myTable.setSCustomOrder("order by category_text");
							rs = myTable.getAllRecordsDisconnected();
							while (rs.next()){
								%>
								<option value="<%=rs.getInt("story_category_id")%>"
									<% if (rs.getInt("story_category_id") == category_id){%> selected <% } %>>
									<%=rs.getString("category_text")%></option>
								<%
							}
							%>
							</select>
							</td>
							</tr>
							<tr>
							<td colspan="2">
							Message:<br />
							<textarea class="inputbox required" name="comment" style="width: 90%; height: 200px;"><%=message%></textarea>
							</td>
							</tr>
							
							</table>
							<input type="button" value="Save Changes" onclick="submitForm()" class="inputbox" />
							<input type="button" value="Delete" onclick="handledelete()" class="inputbox" />
							<input type="button" value="Cancel" onclick="location.href='/postings/jpage/1/p/Postings/content.do'" class="inputbox" />
							</form>
							<br />
							<br />
					</div>

					<div class="yui-u rightcol" style="margin-right: 4px;"><!-- rightmost -->
						<v:moduletag conn="<%=conn%>" position="1" />
						<v:banner position_id="2" conn="<%=conn%>" numberOfBanners="1" /><br>
						<v:banner position_id="11" conn="<%=conn%>" numberOfBanners="1" />
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
		<div id="copyrightmenu">
		<v:mainmenutag conn="<%=conn%>" menutag="Copyright" />
		</div>
	</div>
	<div class="bottombanner"><v:banner position_id="4" conn="<%=conn%>" /></div>
	<%
	int this_year = Calendar.getInstance().get(Calendar.YEAR);
	%>
	<div style="text-align: center; font-size: 80%">Site content and design &copy; 2000-<%=this_year%> Pacemaker Club Inc. <br />All rights reserved.</div>
</div>
</body>
</html>
<%@include file="/footer.jsp" %>