<%@include file="/PageSecurity.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@taglib uri="/WEB-INF/vtags.tld" prefix="v"%>
<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="oscache" %>

<%@ page import="org.displaytag.sample.*,
		org.displaytag.tags.TableTag,
		org.apache.commons.beanutils.*,
		com.verilion.object.GalleryObject" %>
<%@taglib uri="/WEB-INF/displaytag-11.tld" prefix="display"%>
<v:gtag />
	<title>Pacemaker Club: Support &amp; Information For Pacemaker &amp; Defibrillator Patients</title>
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.2.0/build/reset-fonts-grids/reset-fonts-grids.css"> 
<script type='text/javascript' src='/js/ajax/Validator.js'> </script>
<script type='text/javascript' src='/js/ajax/engine.js'> </script>
<script type='text/javascript' src='/js/ajax/util.js'> </script>
<link rel="stylesheet" type="text/css" href="/styles.css">
<%=sJavaScript%>
<script type="text/javascript">
function deleteImage(x){
	var r=confirm("Are you sure you want to delete this photo?");
	if (r==true) {
		window.location.assign("/deleteimage/jpage/1/p/delete/content.do?id=" + x);
	} else {
		return false;
	}
}

</script>
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
							<h1>My Photos</h1>
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
							GenericTable myTable = new GenericTable("gallery_detail");
							myTable.setConn(conn);
							myTable.setSSelectWhat("'<img alt=\"\" width=\"100\" src=\"/gallery/1/' "
								+ "|| img" 
								+ "|| '\" />' as theimg, '<a href=\"#\" onclick=\"deleteImage(' || gallery_detail_id || ')\">Delete</a>' as editcmt");
							
							myTable.setSCustomWhere("and username = '"
								+ session.getAttribute("username")
								+ "' and img <> '' ");
							myTable.setSCustomOrder(" order by datetime desc");
							
							/*XDisconnectedRowSet drs = new XDisconnectedRowSet();
							drs = myTable.getAllRecordsDisconnected();
							
							ArrayList myList = new ArrayList();
							String theImages = "";
							String suffix = "";
							while (drs.next()) {
								GalleryObject myObject = new GalleryObject();
								theImages += drs.getString("editcmt").replaceAll("_thumb.JPG", "_thumb.jpg");
								if (drs.next()) {
									theImages += drs.getString("editcmt").replaceAll("_thumb.JPG", "_thumb.jpg");
								}
								
								if (drs.next()) {
									theImages += drs.getString("editcmt").replaceAll("_thumb.JPG", "_thumb.jpg");
								}
								
								myObject.setGallery(theImages);
								myList.add(myObject);
								theImages = "";
							}

							request.setAttribute("results", myList);*/
							
							
							RowSetDynaClass resultset = myTable.getAllRecordsDynaBean();
							request.setAttribute("results", resultset);
							%>
							
							<display:table name="requestScope.results.rows" requestURI="/comments/jpage/1/p/comments/content.do" export="false" id="commTable" pagesize="50"  class="tabledatacollapse" style="width: 100%" >
			 <display:column property="theimg" title="Image" />
			 <display:column property="editcmt" title="Edit" />
			  <display:setProperty name="export.pdf" value="false" />
			</display:table>
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
