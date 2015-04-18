<%@include file="/PageSecurity.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="verify-v1" content="A5xkTQ0bspKfqaBtBk7aUmDKbfBusd+ztamKEOpi5HE=" />

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

<link rel="stylesheet" type="text/css" href="/styles.css">

<script type='text/javascript' src='/js/ajax/Validator.js'> </script>
<script type='text/javascript' src='/js/ajax/engine.js'> </script>
<script type='text/javascript' src='/js/ajax/util.js'> </script>
<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.0/jquery.validate.min.js"></script>
<script>
$(document).ready(function () {
	$("#cform").validate();
});
</script>
<%=sJavaScript%>

</head>
<body id="yahoo-com">
<div id="doc" class="yui-t1">
<v:banner position_id="1" conn="<%=conn%>"  />
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

							<%
Random diceRoller = new Random();
int roll = diceRoller.nextInt(6) + 1;
if (roll > 4){%>
	<div class="googlead">
	<script type="text/javascript"><!--
	google_ad_client = "ca-pub-7933180114017223";
	/* PMC */
	google_ad_slot = "0456005590";
	google_ad_width = 234;
	google_ad_height = 60;
	//-->
	</script>
	<script type="text/javascript"
	src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
	</script>
	</div>
	<%
} else {%>
	<div class="googlead">
	<script type="text/javascript"><!--
	google_ad_client = "pub-8849439696468095";
	google_ad_width = 234;
	google_ad_height = 60;
	google_ad_format = "234x60_as";
	google_ad_type = "text_image";
	google_ad_channel = "";
	google_color_border = "b30000";
	google_color_bg = "ffffff";
	google_color_link = "b30000";
	google_color_text = "000000";
	google_color_url = "b30000";
	//--></script>
	<script type="text/javascript"
	  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
	</script>
	</div>
	<%
}
%>
							
							<br />
							<%=page_detail_contents%>
							<br />
							<br />
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