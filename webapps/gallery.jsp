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
								<div>
							<%=page_detail_contents%>
							<%@ page import="org.displaytag.sample.*,
		org.displaytag.tags.TableTag,
		org.apache.commons.beanutils.*,
		com.verilion.object.GalleryObject" %>
	<%@taglib uri="/WEB-INF/displaytag-11.tld" prefix="display"%>
	<%
	int gallery_id = 1;
	try {
		gallery_id = Integer.parseInt((String) request.getParameter("id"));
	} catch (Exception e) {
		gallery_id = 1;
	}
	Statement st = null;
	ResultSet rs = null;
	st = conn.createStatement();

	rs = st.executeQuery("select "
		+ "'<div class=\"thumbwrapper\"><div align=\"center\"><a href=\"/gallery/'"
		+ "|| g.gallery_id "
		+ "|| '/' "
		+ "|| img "
		+ "|| '\" rel=\"gb_image[]\" title=\"' "
		+ "|| title "
		+ "|| '\">'"
		+ "|| '<img alt=\"\" src=\"/gallery/'"
		+ "|| g.gallery_id "
		+ "|| '/'"
		+ "|| replace(img, '.', '_thumb.')" 
		+ "|| '\" /></a></div></div>'"
		+ " as thehtml ,"
		+ " gd.img "
		+ " from" 
		+ " gallery_detail gd left join gallery g on (g.gallery_id = gd.gallery_id) "
		+ " where g.gallery_id = "
		+ gallery_id 
		+ " and gd.img <> '' "
		+ " order by gd.datetime desc");
	
	ArrayList myList = new ArrayList();
	String theImages = "";
	String suffix = "";
	while (rs.next()) {
		GalleryObject myObject = new GalleryObject();
		theImages += rs.getString("thehtml").replaceAll("_thumb.JPG", "_thumb.jpg");
		if (rs.next()) {
			theImages += rs.getString("thehtml").replaceAll("_thumb.JPG", "_thumb.jpg");
		}
		
		if (rs.next()) {
			theImages += rs.getString("thehtml").replaceAll("_thumb.JPG", "_thumb.jpg");
		}
		
		myObject.setGallery(theImages);
		myList.add(myObject);
		theImages = "";
	}
	rs.close();
	rs = null;
	st.close();
	st = null;
	request.setAttribute("results", myList);

	%>
			
			<display:table name="results" style="text-align: center" pagesize="10" requestURI="/gallery/jpage/1/p/gallery/content.do">
				<display:column property="gallery" />
				<display:setProperty name="paging.banner.item_name" value="row" />
				<display:setProperty name="paging.banner.items_name" value="rows" />
				<display:setProperty name="paging.banner.some_items_found">
					<span class="pagebanner">{0} {1} found, displaying {2} to {3}</span>
				</display:setProperty>
			</display:table>
			
			
	
							<br /><br />
							</div>
							<div style="clear: both">
							<form name="newsform" id="newsform" action="/addtogallery/jpage/1/p/MemberGallery/content.do" method="post" enctype="multipart/form-data">
    <input type="hidden" name="edit" value="true" />  		<input type="hidden" name="a" />  		<input type="hidden" name="id" value="0" />  		<input type="hidden" name="gallery_id" value="1" />  		<fieldset>  		<legend>Add Image to Member&rsquo;s Gallery</legend>  		<label for="title">Title (max 50 characters)</label>  		<input type="text" name="title" class="inputbox" value="" maxlength="50" />  		<label for="uploadedfile">Choose your image</label>  		<input type="file" size="20" name="uploadedfile" class="inputbox" />  		  		  		</fieldset><br />
    <input type="submit" class="inputbox" value="Add my photo!" />
</form>
<br />
Your image must be in JPG format (and end with .jpg). Type in a short description for your picture, and then click on the "browse" button to find the file on your computer. Click the button to upload it and your image will be added to the gallery. 
							<br />
							</div>
					</div>

					<div class="yui-u rightcol" style="margin-right: 4px;"><!-- rightmost -->
						<v:moduletag conn="<%=conn%>" position="1" />
						<v:banner position_id="2" conn="<%=conn%>" numberOfBanners="3" />
						<br />
						<br />
						<v:googlead 
							publisher_id="pub-8849439696468095"
							w="120"
							h="240"
							ad_format="120x240_as"
							border_color="b30000"
							bg_color="ffffff"
							link_color="b30000"
							text_color="000000"
							url_color="b30000" />
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
				<v:banner position_id="10" conn="<%=conn%>" numberOfBanners="3" />
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
