<%@include file="/PageSecurity.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<%@taglib uri="/WEB-INF/vtags.tld" prefix="v"%>
<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="oscache" %>
<v:gtag />
	<title>
    <%
	if (browser_title.length() > 0) {
	%>
	<%=browser_title%>
	<%
	} else {
	%>
	Pacemaker Club: Support &amp; Information For Pacemaker &amp; Defibrillator Patients
	<%
	}
	%>
    </title>
    <%
if (meta_tags.length() > 0) {
%>
<meta name="description" value="<%=meta_tags%>" />
<%
}
%>
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.2.0/build/reset-fonts-grids/reset-fonts-grids.css"> 
<script type="text/javascript">
    var GB_ROOT_DIR = "http://www.pacemakerclub.com/greybox/";
</script>
<script type="text/javascript" src="/greybox/AJS.js"></script>
<script type="text/javascript" src="/greybox/AJS_fx.js"></script>
<script type="text/javascript" src="/greybox/gb_scripts.js"></script>
<script type='text/javascript' src='/js/ajax/Validator.js'></script>
<script type='text/javascript' src='/js/ajax/engine.js'></script>
<script type='text/javascript' src='/js/ajax/util.js'></script>
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/yahoo-dom-event/yahoo-dom-event.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/container/container_core-min.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/animation/animation-min.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/menu/menu-min.js"></script> 
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.2.0/build/menu/assets/menu.css"> 
<link rel="stylesheet" type="text/css" href="/styles.css">
<link href="/greybox/gb_styles.css" rel="stylesheet" type="text/css">
<%=sJavaScript%>
<script language="JavaScript" type="text/javascript">
function validateForm()
{
	var okay = true;
	var result = "";
	result = checkRequired("st");
	if (result != "") {
		okay = false;
	}
	return okay;
}
function checkRequired(fieldName)
{
	var theReply = "";
	if (dwr.util.getValue(fieldName) == "") {
		processReply(false, fieldName, fieldName + "-error", " *required");
		theReply = "Missing field";
	}
  return theReply;
}

function processReply(valid, id, errid, error)
{
	if (valid)
	{
		dwr.util.setValue(errid, "");
	}
	else
	{
		dwr.util.setValue(errid, error);
	}
}
function performAction ( )
{
	var okay = true;
	okay = validateForm();
	if (okay) {
	  document.searchform.submit() ;
	}
}

</script>
</head>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ page import="org.displaytag.sample.*,
                 org.displaytag.tags.TableTag,
                 org.apache.commons.beanutils.*" %>
<%
String searchterms = "";
boolean searching = false;
PreparedStatement pst = null;
ResultSet rs = null;
XDisconnectedRowSet drs = new XDisconnectedRowSet();

if (request.getParameter("st") != null) {
	searchterms = (String) request.getParameter("st");
	pst = conn.prepareStatement("select story_id, title, story from pmc_stories where story ilike ? or title ilike ?");
	pst.setString(1, "%" + searchterms + "%");
	pst.setString(2, "%" + searchterms + "%");
	rs = pst.executeQuery();
	drs.populate(rs);
	searching = true;
	rs.close();
	rs = null;
	pst.close();
	pst = null;
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

								<form method="post" name="searchform" id="searchform" action="/search/jpage/1/p/Search/content.do">
								<fieldset>
									  <legend>Search</legend>
									
									<label for="st">Enter search terms:</label>
									<input class="inputbox" name="st" id="st" type="text" value="<%=searchterms%>" />
									<input type="button" onclick="performAction()" value="Search!" class="inputbox" />
									<span id="st-error" class="error"></span>
								</fieldset>
								</form>
							<br />
							<br />
							<%
							if (searching) {
								if (drs.next()) {
									drs.previous();
									while (drs.next()) {
										String theStory = drs.getString("story");
										if (theStory.length() > 750) {
											theStory = theStory.substring(0, 749) + "...";
										}
										
										theStory = theStory.replaceAll("<br />", "186282ytrrdsdf");
										theStory = theStory.replaceAll("<br", "");
										theStory = theStory.replaceAll("<b", "");
										theStory = theStory.replaceAll("<p", "");
										theStory = theStory.replaceAll("<", "&lt;");
										theStory = theStory.replaceAll("186282ytrrdsdf", "<br />");
										theStory = theStory.replaceAll(searchterms, "<span style=\"background: yellow;\">" + searchterms + "</span>");
										%>
										<div class="storyheader">
										<a class="storyheader" style="font-weight: bold;" href="/public/jpage/1/p/story/a/storypage/sid/<%=drs.getInt("story_id")%>/content.do" title="Click to read message and comments">
										<%=drs.getString("title")%></a>
										</div>
										<div><%=theStory%></div>
										<div>&nbsp;</div>
										<%
									}
								} else {
								%>
								No results found.
								<%
								}
								
								drs.close();
								drs = null;
							}
							%>
					</div>

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
