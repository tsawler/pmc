<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><!-- InstanceBegin template="/Templates/AdminTemplate.dwt.jsp" codeOutsideHTMLIsLocked="true" -->
<%@include file="/AdminSecurity.jsp" %>
<%@ taglib uri="/WEB-INF/vtags.tld" prefix="v" %>
<%@include file="/admin/checkLogin.jsp" %>
<%
String error = "";
String errorMessage = "";
try {
%>
<head>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<v:gtag />

<!-- InstanceBeginEditable name="doctitle" -->
<title>vMaintain Admin tool</title>
<!-- InstanceEndEditable -->
<link href="/css/stylesheet.css" rel="stylesheet" type="text/css" />
<script type='text/javascript' src='/js/editor/fckeditor.js'></script>
<script type='text/javascript' src='/js/ajax/engine.js'></script>
<script type='text/javascript' src='/js/ajax/util.js'></script>
<script type='text/javascript' src='/js/ajax/Validator.js'></script>
<script type='text/javascript' src='/js/dragsortcmp.js'></script>
<script type='text/javascript' src='/js/tabber.js'></script>
<link rel="stylesheet" type="text/css" href="/css/ajax.css" />
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/ajaxtags-1.1.js"></script>

<script type="text/javascript">
/* <![CDATA[ */
document.write('<style type="text/css">.tabber{display:none;}<\/style>');
/* ]]> */
</script>
<link rel="stylesheet" href="/admin/adminstyles.css" type="text/css"  />
<script type="text/javascript">
/* <![CDATA[ */
var persistmenu="yes" 
var persisttype="sitewide"

if (document.getElementById){ //DynamicDrive.com change
document.write('<style type="text/css">\n')
document.write('.submenu{display: none;}\n')
document.write('</style>\n')
}

function SwitchMenu(obj){
	if(document.getElementById){
	var el = document.getElementById(obj);
	var ar = document.getElementById("masterdiv").getElementsByTagName("span"); 
		if(el.style.display != "block"){ 
			for (var i=0; i<ar.length; i++){
				if (ar[i].className=="submenu") 
				ar[i].style.display = "none";
			}
			el.style.display = "block";
		}else{
			el.style.display = "none";
		}
	}
}

function get_cookie(Name) { 
var search = Name + "="
var returnvalue = "";
if (document.cookie.length > 0) {
offset = document.cookie.indexOf(search)
if (offset != -1) { 
offset += search.length
end = document.cookie.indexOf(";", offset);
if (end == -1) end = document.cookie.length;
returnvalue=unescape(document.cookie.substring(offset, end))
}
}
return returnvalue;
}

function onloadfunction(){
if (persistmenu=="yes"){
var cookiename=(persisttype=="sitewide")? "switchmenu" : window.location.pathname
var cookievalue=get_cookie(cookiename)
if (cookievalue!="")
document.getElementById(cookievalue).style.display="block"
}
}

function savemenustate(){
var inc=1, blockid=""
while (document.getElementById("sub"+inc)){
if (document.getElementById("sub"+inc).style.display=="block"){
blockid="sub"+inc
break
}
inc++
}
var cookiename=(persisttype=="sitewide")? "switchmenu" : window.location.pathname
var cookievalue=(persisttype=="sitewide")? blockid+";path=/" : blockid
document.cookie=cookiename+"="+cookievalue
}

if (window.addEventListener)
window.addEventListener("load", onloadfunction, false)
else if (window.attachEvent)
window.attachEvent("onload", onloadfunction)
else if (document.getElementById)
window.onload=onloadfunction

if (persistmenu=="yes" && document.getElementById)
window.onunload=savemenustate
/* ]]> */
</script>
<!-- InstanceBeginEditable name="head" -->

<!-- InstanceEndEditable -->
</head>

<body class="treenavpage" style="height: 100%;">
<!-- InstanceBeginEditable name="BeforeHTML" -->
<%
		int id = 0;
		int gallery_id = 0;
		int a = 0;
		XDisconnectedRowSet drs = new XDisconnectedRowSet();
		String title = "";
		String img = "";
		String picture = "";
		String imageset = "";
		boolean submitting = false;
		String thePath = "/home/httpd/pacemakerclub.com/html/gallery";
		String filename = "";
		GenericTable myGt = new GenericTable();
		int newCatId = 0;
		
		try {
			id = Integer.parseInt((String) request.getParameter("id"));
		} catch (Exception e){
			id = 0;
		}
		
		try {
			gallery_id = Integer.parseInt((String) session.getAttribute("gallery_id"));
			thePath += "/" + gallery_id + "/";
		} catch (Exception e){
			e.printStackTrace();
		}
		
		try {
			MultipartRequest multi = new MultipartRequest(request,
               thePath, 50000 * 1024);
			id = Integer.parseInt((String) multi.getParameter("id"));
			newCatId = Integer.parseInt((String) multi.getParameter("gallery_id"));
			gallery_id = newCatId;
			if (multi.getParameter("a") != null) {
			try {
				a = Integer.parseInt((String) multi.getParameter("a"));
			} catch (Exception e) {
				a = 0;
			}
			
			if (a > 0) {
				// deleting
				PreparedStatement pst = null;
				pst = conn.prepareStatement("delete from gallery_detail where gallery_detail_id = " + id);
				try {
					pst.executeUpdate();
				} catch (Exception e) {
				
				}
				pst.close();
				pst = null;
				session.setAttribute("Error", "Image deleted.");
				response.sendRedirect("/browsegallery/jpage/1/p/gallery/admin/1/content.do?id=" + gallery_id);
				return;
			}
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
						File theFile = new File(thePath + filename);
						Thumbnail myThumb = new Thumbnail();
						String tmpString = filename.substring(0, (filename.length() - 4));
						myThumb.createThumbnail(thePath + filename, thePath + tmpString + "_thumb.jpg", 100);
						myGt.setConn(conn);
						myGt.setUpdateWhat("gallery_detail");
						myGt.addUpdateFieldNameValuePair("img", filename, "string");
						myGt.setSCustomWhere(" and gallery_detail_id = " + id);
						myGt.updateRecord();
					}
					
				} catch (Exception e) {
					System.out.println(e.toString());
					e.printStackTrace();
				}
				
				session.setAttribute("Error", "Changes saved.");
				response.sendRedirect("/browsegallery/jpage/1/p/gallery/admin/1/content.do?id=" + gallery_id);
				return;
			}
		}
			
		} catch (Exception e) {

		}
		
		if (id > 0) {
				myGt.setSTable("gallery_detail gd left join gallery g on (g.gallery_id = gd.gallery_id)");
				myGt.setConn(conn);
				myGt.setSSelectWhat(" gd.*, g.imageset ");
				myGt.setSCustomWhere(" and gd.gallery_detail_id = " + id);
				drs = myGt.getAllRecordsDisconnected();
				while (drs.next()){
					title = drs.getString("title");
					img = drs.getString("img");
					gallery_id = drs.getInt("gallery_id");
					imageset = drs.getString("imageset");
				}
				String tmpString = img.substring(0, (img.length() - 4));
				picture = "/gallery/" + gallery_id + "/" +  tmpString + "_thumb.jpg";
			}
		%>
<!-- InstanceEndEditable -->
<table style="padding: 0; border: 1px solid silver; width: 100%;">
  <tr style="height: 15px;">
    <td class="treetoplevel" style="border: 1px solid silver;">vMaintain
      Admin tool<br />
      <%=session.getAttribute("userAdminName")%>
	  </td>
	  <td class="treetoplevel" style="text-align: right;">&nbsp;<v:usercount conn="<%=conn%>" /></td>
  </tr>
  <tr>
    <td width="17%" class="tableheader" style="text-align: left; border: 1px solid silver;" valign="top"><strong>Main Menu</strong><br />
        <br />
		<%@include file="/admin/nav_menu.jsp"%>
    </td>
    <td class="tabledata" style="border: 1px solid silver;" valign="top" width="83%" cellpadding="0" cellspacing="0">
        <table style="border-bottom: 1px solid silver; height: 100%; width: 100%"  cellpadding="2" cellspacing="0">
        <tr style="height: 15px;">
        <td class="tableheader"><!-- InstanceBeginEditable name="Title" -->Add/Edit Gallery Image<!-- InstanceEndEditable --></td>
        </tr>
        <tr style="height: 15px;"><td class="tabledata">
        <v:message />
        </td></tr>
        <tr><td class="tabledata" valign="top">
		<!-- InstanceBeginEditable name="WorkArea" -->
<script language="JavaScript" type="text/javascript">
<!--
function performAction ( )
{
  document.newsform.submit() ;
}

function confirmDelete()
{
var agree=confirm("Are you sure you wish to delete this image?");
if (agree) {
	document.newsform.a.value = 1 ;
  	document.newsform.submit() ;
	}
else
	return false ;
}
// -->
</script>
		<div class="content">
		<table style="width: 100%">
			<tr>
				<td class="content" style="text-align: right;">
					<a href="javascript:performAction()">Save</a> ::
					<% if (id > 0) {%>
					<a href="#" onclick="return confirmDelete()">Delete</a> ::
					<%}%>
					<a href="/browsegallery/jpage/1/p/gallery/admin/1/content.do?id=<%=gallery_id%>">Cancel</a>
				</td>
			</tr>
		</table>

		<form name="newsform" id="newsform" action="/galleryitemdetail/jpage/1/p/gallery/admin/1/content.do" method="post" enctype="multipart/form-data">
		<input type="hidden" name="edit" value="true" />
		<input type="hidden" name="a" />
		<input type="hidden" name="id" value="<%=id%>" />
		<table class="tabledatacollapse">
		<tr class="tableheader">
		<td colspan="2">Edit Gallery Image</td>
		</tr>
		<tr>
		<td>Title</td>
		<td><input type="text" name="title" class="inputbox" value="<%=title%>" /></td>
		</tr>
		<tr>
		<td>Put in gallery...</td>
		<td>
		<select class="inputbox" name="gallery_id">
		<%
		GenericTable myGt2 = new GenericTable();
		myGt2.setConn(conn);
		myGt2.setSTable("gallery");
		myGt2.setSSelectWhat("*");
		myGt2.setSCustomOrder("order by gallery_name");
		drs = myGt2.getAllRecordsDisconnected();
		while (drs.next()){
		%>
		<option <%if (gallery_id == drs.getInt("gallery_id")){%> selected <%}%> value="<%=drs.getInt("gallery_id")%>"><%=drs.getString("gallery_name")%></option>
		<%
		}
		%>
		</select>
		</td>
		</tr>
		<tr>
		<td>Image</td>
		<td>
		<%
		if (picture.length() > 0) {
		%>
		<img src="<%=picture%>" />
		<%
		} else {
		%>
		&nbsp;
		<%
		}
		%>
		</td>
		</tr>
		<tr>
		<td>Browse for new image</td>
		<td><input type="file" size="20" name="uploadedfile" class="inputbox"></td>
		</tr>
		</table>
		</form>
		</div>
		<!-- InstanceEndEditable --></td>
        </tr></table>
    </td>
  </tr>
  <tr style="height: 15px">
    <td class="treetoplevel" colspan="2" style="text-align: right; border: 1px solid silver;">Copyright &copy; Verilion
      Inc.</td>
  </tr>
</table>

</body>
<!-- InstanceEnd --></html>
<%
}
catch (Exception e){
	e.printStackTrace();
   error = "true";
   errorMessage = "Please login";
   session.setAttribute("loginError", error);
   session.setAttribute("loginErrorMessage", errorMessage);
   response.sendRedirect("/admin/Error.jsp");
}
%>
<%@include file="/admin/footer.jsp" %>
