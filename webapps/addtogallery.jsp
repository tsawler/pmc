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
<%
int id = 0;
int gallery_id = 1;
int a = 0;
XDisconnectedRowSet drs = new XDisconnectedRowSet();
String title = "";
String img = "";
String picture = "";
String imageset = "";
boolean submitting = false;
String thePath = "/home/httpd/pacemakerclub.com/http/tmp";
String theGalleryPath = "";
String filename = "";
GenericTable myGt = new GenericTable();
int newCatId = 0;


theGalleryPath = "/home/httpd/pacemakerclub.com/http/gallery/" + gallery_id + "/";


try {
	MultipartRequest multi = new MultipartRequest(request,
	   thePath, 5000000 * 1024);
	id = Integer.parseInt((String) multi.getParameter("id"));
	newCatId = Integer.parseInt((String) multi.getParameter("gallery_id"));
	System.out.println("gallery id" + newCatId);
	gallery_id = newCatId;

	if (multi.getParameter("title") != null) {
		// updating or adding
		try {
			title=(String) multi.getParameter("title");
			myGt.setConn(conn);
			myGt.setUpdateWhat("gallery_detail");
			myGt.addUpdateFieldNameValuePair("title", title, "string");
			myGt.addUpdateFieldNameValuePair("gallery_id", newCatId + "", "int");
			if (id > 0) {
				myGt.setSCustomWhere("and gallery_detail_id = " + id);
				myGt.updateRecord();
			} else {
			  myGt.setSTable("gallery_detail");
			  myGt.insertRecord();
			  myGt.setSSequence("gallery_detail_gallery_detail_id_seq");
			  id = myGt.returnCurrentSequenceValue();
			}
			myGt.clearUpdateVectors();
			
			// now check for uploaded file
			Enumeration files = multi.getFileNames();
			String theFileName = "";
			while (files.hasMoreElements()) {
				theFileName = (String) files.nextElement();
				filename = multi.getFilesystemName(theFileName);
			}
			if (filename == null) {
				filename = "";
			} else {
				// there was a picture included in the post request
				// generate a thumbnail
				System.out.println("********** " + thePath + "/" + filename);
				File theFile = new File(thePath + "/" + filename);
				BufferedImage inImage = ImageIO.read(theFile);
				if (inImage.getWidth(null) > 600) {
					Thumbnail myThumb2 = new Thumbnail();
					myThumb2.createThumbnailUsingJpgtn(thePath + "/" + filename, theGalleryPath + customer_id + "_" + filename, 600);
				} else {
					Thumbnail myThumb2 = new Thumbnail();
					myThumb2.createThumbnailUsingJpgtn(thePath + "/" + filename, theGalleryPath + customer_id + "_" + filename, inImage.getWidth(null));
				}
				Thumbnail myThumb = new Thumbnail();
				String tmpString = filename.substring(0, (filename.length() - 4));
				myThumb.createThumbnailUsingJpgtn(thePath + "/" + filename, theGalleryPath + customer_id + "_" + tmpString + "_thumb.jpg", 100);
				myGt.setConn(conn);
				myGt.setUpdateWhat("gallery_detail");
				myGt.addUpdateFieldNameValuePair("img", customer_id + "_" + filename, "string");
				myGt.addUpdateFieldNameValuePair("customer_id", customer_id + "", "int");
				myGt.addUpdateFieldNameValuePair("username", (String) session.getAttribute("username"), "string");
				myGt.setSCustomWhere(" and gallery_detail_id = " + id);
				myGt.updateRecord();
			}
			
		} catch (Exception e) {
			System.out.println(e.toString());
			e.printStackTrace();
		}
		
		session.setAttribute("Error", "Your image has been added!");
		response.sendRedirect("/membergallery/jpage/1/p/MemberGallery/content.do?id=1");
		return;
	}
	
} catch (Exception e) {

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
		Use this form to add your image to the member's gallery. Your image <strong>must</strong> be in JPG format (and end with .jpg). Type in a short description for your picture, and then click on the "browse" button to find the file on your computer. Click the button to upload it, and if all goes well, your image will have been added to the gallery.
		<br /><br />				
		<form name="newsform" id="newsform" action="/addtogallery/jpage/1/p/MemberGallery/content.do" method="post" enctype="multipart/form-data">
		<input type="hidden" name="edit" value="true" />
		<input type="hidden" name="a" />
		<input type="hidden" name="id" value="0" />
		<input type="hidden" name="gallery_id" value="1">
		<fieldset>
		<legend>Add Image to Member's Gallery</legend>
		<label for="title">Title (max 50 characters)</label>
		<input type="text" name="title" class="inputbox" value="" maxlength="50" />
		<label for="uploadedfile">Choose your image</label>
		<input type="file" size="20" name="uploadedfile" class="inputbox">
		
		
		</fieldset><br /><input type="submit" class="inputbox" value="Add my image to the gallery!" />
		</form>
							<br />
							<br />
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
