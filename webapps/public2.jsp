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
<script type='text/javascript' src='/js/ajax/Validator.js'> </script>
<script type='text/javascript' src='/js/ajax/engine.js'> </script>
<script type='text/javascript' src='/js/ajax/util.js'> </script>
<link href="/greybox/gb_styles.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="/styles2.css">
<%=sJavaScript%>
</head>
<body id="yahoo-com">
<div id="doc" class="yui-t1">
<v:banner position_id="1" conn="<%=conn%>" />
	<div id="hd" class="topofpage"><!--header-->
		<img src="/pmcimages/header.gif">
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
							<%=page_detail_contents%>
							<br />
							<br />
					</div>

					<div class="yui-u rightcol" style="margin-right: 4px;"><!-- rightmost -->
						<v:moduletag conn="<%=conn%>" position="1" />
						<v:banner position_id="2" conn="<%=conn%>" numberOfBanners="3" />
					</div>
				</div>
			</div>
		</div>
		<div class="yui-b leftmost"><!-- leftmost column -->
				<v:mainmenutag conn="<%=conn%>" menutag="Main Menu" />
				<br />
				<v:banner position_id="3" conn="<%=conn%>" numberOfBanners="1" />
				<br />
				<v:mainmenutag conn="<%=conn%>" menutag="Messages Menu" />
				<v:banner position_id="9" conn="<%=conn%>" numberOfBanners="3" />
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
