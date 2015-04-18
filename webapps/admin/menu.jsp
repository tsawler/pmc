<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><!-- InstanceBegin template="/Templates/AdminTemplate.dwt.jsp" codeOutsideHTMLIsLocked="true" -->
<%@include file="/AdminSecurity.jsp" %>
<%@ taglib uri="/WEB-INF/vtags.tld" prefix="v" %>
<%@include file="/admin/checkLogin.jsp" %>
<%
String error = "";
String errorMessage = "";
//session = request.getSession(true);
try {
%>
<head>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<v:gtag />

<!-- InstanceBeginEditable name="doctitle" -->
<title>vMaintain Admin tool</title>
<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="oscache" %>
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
<script type="text/javascript"><!--
var dragsort = ToolMan.dragsort()
var junkdrawer = ToolMan.junkdrawer()
window.onload = function() {
	dragsort.makeListSortable(document.getElementById("themenus"),
		verticalOnly, saveOrder);
		
	myFadeSize = new fx.FadeSize('popmenuitemadd', {duration: 400});
	myHeight = new fx.Height('popmenuitemadd', {duration: 400});
	myFadeSize.hide();
	myHeight.hide();
	
	myFadeSize2 = new fx.FadeSize('popmenuadd', {duration: 400});
	myHeight2 = new fx.Height('popmenuadd', {duration: 400});
	myFadeSize2.hide();
	myHeight2.hide();
	
	myFadeSize3 = new fx.FadeSize('popheaderadd', {duration: 400});
	myHeight3 = new fx.Height('popheaderadd', {duration: 400});
	myFadeSize3.hide();
	myHeight3.hide();
}
function verticalOnly(item) {
item.toolManDragGroup.verticalOnly()
}
function showListOrder(listID) {
	var list = document.getElementById(listID);
	var items = list.getElementsByTagName("li");
	var itemsString = "";
	for (var i = 0; i < items.length; i++) {
	    if (itemsString.length > 0) itemsString += ":";
	    itemsString += items[i].getAttribute("id");
	}
	//alert('itemstring in showListOrder: ' + itemsString);
	return itemsString;
}
function saveOrder(item) {
	var group = item.toolManDragGroup
	var list = group.element.parentNode
	var id = list.getAttribute("id")
	if (id == null) return
	group.register('dragend', function() {
		ToolMan.cookies().set("list-" + id, 
				junkdrawer.serializeList(list), 365)
	})
}
function submitForm ( ){
	document.menuform.action.value = 0;
	document.menuform.submit() ;
}
function confirmDelete() {
	var agree=confirm("Are you sure you wish to delete this menu? This action cannot be undone!");
	if (agree) {
		document.menuform.action.value = 8;
		document.menuform.submit();
	} else
		return false;
}

function performAction() {
	//alert('calling performacation');
	document.menusortform.postval.value = showListOrder('themenus');
	var myString = showListOrder('themenus');
	///alert('myString: ' + myString);
	//Validator.UpdateMenuItemOrder(reply, myString)
	Validator.UpdateMenuItemOrder(myString);
}
function reply (valid) {
}
//-->
</script>
<!-- InstanceEndEditable -->
</head>

<body class="treenavpage" style="height: 100%;">
<!-- InstanceBeginEditable name="BeforeHTML" -->
<%@ taglib uri="/WEB-INF/vtags.tld" prefix="v" %>
<%@ page language="java" import="com.fredck.FCKeditor.*" %>
<jsp:useBean id="ddlb" scope="request" class="com.verilion.object.html.HTMLFormDropDownList" />
<jsp:useBean id="menu" scope="request" class="com.verilion.database.Menu" />
<jsp:useBean id="menuitem" scope="request" class="com.verilion.database.MenuItem" />
<jsp:useBean id="menuitemdetail" scope="request" class="com.verilion.database.MenuItemDetail" />

<%
String lastName = "";
XDisconnectedRowSet drs = new XDisconnectedRowSet();
String theMenu = "";
String query = "";
int menu_id = 1;
String menu_detail_name = "";
String menuname = "";
String menudivider = "";
int ct_menu_alignment_type = 0;
int ct_menu_type = 0;

if (request.getParameter("menu_id") != null) {
	menu_id = Integer.parseInt((String) request.getParameter("menu_id"));
}
if (hm.get("menu_id") != null) {
	menu_id = Integer.parseInt((String) hm.get("menu_id"));
}

if (request.getParameter("deletespacer") != null) {
	menuitem.setConn(conn);
	menuitem.setMenu_item_id(Integer.parseInt((String) request.getParameter("miid")));
	menuitem.deleteRecord();
}
// adding a new menu
if (request.getParameter("menuname") != null) {
	if (((String)request.getParameter("menuname")).length() > 0) {
		menu.setConn(conn);
		menu.setMenu_name((String) request.getParameter("menuname"));
		menu.setCt_menu_type_id(1);
		menu.setMenu_divider("");
		menu.setCt_menu_alignment_type_id(1);
		menu.setMenu_active_yn("y");
		menu.setMenu_tag("$" + request.getParameter("menuname") + "$");
		menu_id = menu.addMenu();
	}
}

// changing order of items
if (request.getParameter("action") != null) {
	if (request.getParameter("action").equals("6")) {
		int rid = Integer.parseInt((String)request.getParameter("rid"));
		int mid = Integer.parseInt((String)request.getParameter("mid"));
		menuitem.setConn(conn);
		menuitem.ChangeItemOrderUp(rid, mid);
	} else if (request.getParameter("action").equals("7")) {
		int rid = Integer.parseInt((String)request.getParameter("rid"));
		int mid = Integer.parseInt((String)request.getParameter("mid"));
		menuitem.setConn(conn);
		menuitem.ChangeItemOrderDown(rid, mid);
	} else if (request.getParameter("action").equals("8")) {
		// deleting a menu!
		if (Integer.parseInt((String) request.getParameter("menu_id")) > 1) {
			menu.setConn(conn);
			menu.setMenu_id(Integer.parseInt((String) request.getParameter("menu_id")));
			menu.deleteRecord();
		}	
	}
}

// processing form request for menu selection
if (request.getParameter("menu_id") != null) {
	menu_id = Integer.parseInt((String) request.getParameter("menu_id"));
}

// adding a menu item
if (request.getParameter("menuitemname") != null) {
	if (((String)request.getParameter("menuitemname")).length() > 0) {
		menu_detail_name = (String) request.getParameter("menuitemname");
		menuitem.setConn(conn);
		menuitem.setMenu_item_action("");
		menuitem.setMenu_item_description("");
		//menuitem.setMenu_item_order(0);
		menuitem.setMenu_id(Integer.parseInt((String) request.getParameter("menu_id")));
		menuitem.setMenu_item_active_yn("n");
		menuitem.setPage_id(0);
		menuitem.setMenu_item_is_heading("n");
		menuitem.setMenu_item_is_spacer("n");
		int tempId = menuitem.addMenuItem();
		menuitemdetail.setConn(conn);
		menuitemdetail.setMenu_item_id(tempId);
		menuitemdetail.setCt_language_id(1);
		menuitemdetail.setMenu_item_detail_name(menu_detail_name);
		menuitemdetail.addMenuItemDetail();
	}
}

// adding spacer
if (request.getParameter("addspacer") != null) {
	menu_detail_name = "spacer";
	menuitem.setConn(conn);
	menuitem.setMenu_item_action("");
	menuitem.setMenu_item_description("");
	//menuitem.setMenu_item_order(0);
	menuitem.setMenu_id(Integer.parseInt((String) request.getParameter("menu_id")));
	menuitem.setMenu_item_active_yn("y");
	menuitem.setPage_id(0);
	menuitem.setMenu_item_is_heading("n");
	menuitem.setMenu_item_is_spacer("y");
	int tempId = menuitem.addMenuItem();
	menuitemdetail.setConn(conn);
	menuitemdetail.setMenu_item_id(tempId);
	menuitemdetail.setCt_language_id(1);
	menuitemdetail.setMenu_item_detail_name(menu_detail_name);
	menuitemdetail.addMenuItemDetail();
}

// adding a menu heading
if (request.getParameter("headingname") != null) {
	if (((String)request.getParameter("headingname")).length() > 0) {
		menu_detail_name = (String) request.getParameter("headingname");
		menuitem.setConn(conn);
		menuitem.setMenu_item_action("");
		menuitem.setMenu_item_description("");
		//menuitem.setMenu_item_order(0);
		menuitem.setMenu_id(Integer.parseInt((String) request.getParameter("menu_id")));
		menuitem.setMenu_item_active_yn("n");
		menuitem.setPage_id(0);
		menuitem.setMenu_item_is_heading("y");
		menuitem.setMenu_item_is_spacer("n");
		int tempId = menuitem.addMenuItem();
		menuitemdetail.setConn(conn);
		menuitemdetail.setMenu_item_id(tempId);
		menuitemdetail.setCt_language_id(1);
		menuitemdetail.setMenu_item_detail_name(menu_detail_name);
		menuitemdetail.addMenuItemDetail();
	}
}

menu.setConn(conn);
drs = menu.getAllMenuNamesIds();
theMenu = ddlb.makeDropDownListSnippet(
	"menu_id",
	menu_id,
	drs,
	"menu_id",
	"menu_name",
	0,
	"",
	"onChange=\"this.form.submit();\"");

menuitem.setConn(conn);
menuitem.setMenu_id(menu_id);
menuitem.setCt_language_id(1);
//RowSetDynaClass resultset = menuitem.getAllMenuItemsDynaBean();

if (request.getParameter("ct_menu_type") != null) {
	//System.out.println("Trying to update menu.");
	menuname = request.getParameter("menu_name");
	menudivider = request.getParameter("menudivider");
	ct_menu_alignment_type = Integer.parseInt((String) request.getParameter("ct_menu_alignment_type"));
	ct_menu_type = Integer.parseInt((String) request.getParameter("ct_menu_type"));
	
	menu.setMenu_id(menu_id);
	menu.setMenu_name(menuname);
	menu.setMenu_divider(menudivider);
	menu.setCt_menu_alignment_type_id(ct_menu_alignment_type);
	menu.setCt_menu_type_id(ct_menu_type);
	menu.setMenu_active_yn("y");
	//System.out.println("menu id : " + menu_id + "\nalignment type " + ct_menu_alignment_type);
	menu.updateMenu();
	session.setAttribute("Error", "Changes saved.");
}
XDisconnectedRowSet crs = new XDisconnectedRowSet();

if (menu_id > 0) {
menu.setMenu_id(menu_id);
crs = menu.getMenu();
while (crs.next()) {
	menuname = crs.getString("menu_name");
	menudivider = crs.getString("menu_divider");
	ct_menu_alignment_type = crs.getInt("ct_menu_alignment_type_id");
	ct_menu_type = crs.getInt("ct_menu_type_id");
}
crs.close();
crs = null;
}

crs = menuitem.getAllMenuItems();



//request.setAttribute("results", resultset);
%>

<!-- InstanceEndEditable -->
<table style="padding: 0; border: 1px solid silver; height: 95%; width: 100%;">
  <tr style="height: 15px;">
    <td class="treetoplevel" style="border: 1px solid silver;">vMaintain
      Admin tool<br />
      <%=session.getAttribute("userAdminName")%>
	  </td>
	  <td class="treetoplevel" style="text-align: right;">&nbsp;<v:messagecount admin="true" style="headerlinks" /><v:usercount conn="<%=conn%>" /></td>
  </tr>
  <tr>
    <td width="17%" class="tableheader" style="text-align: left; border: 1px solid silver;" valign="top"><strong>Main Menu</strong><br />
        <br />
		<%@include file="/admin/nav_menu.jsp"%>
    </td>
    <td class="tabledata" style="border: 1px solid silver;" valign="top" width="83%" cellpadding="0" cellspacing="0">
        <table style="border-bottom: 1px solid silver; height: 100%; width: 100%"  cellpadding="2" cellspacing="0">
        <tr style="height: 15px;">
        <td class="tableheader"><!-- InstanceBeginEditable name="Title" -->Menu Items<!-- InstanceEndEditable --></td>
        </tr>
        <tr style="height: 15px;"><td class="tabledata">
        <v:message />
        </td></tr>
        <tr><td class="tabledata" valign="top">
		<!-- InstanceBeginEditable name="WorkArea" -->
		<div align="center">
		<fieldset><legend>Maintain menus</legend>
		<form method="post" action="/menu/jpage/1/p/MenuChoose/class/menu/admin/1/content.do" name="menuform" id="menuform">
		<table class="tabledata">
		  <tr>
		    <td>Menu</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
		    <td>
			<%=theMenu%>
			</td>
			<td>
			&nbsp;
			<input type="submit" class="inputbox" value="Go" /><input type="hidden" name="action" /></td>
		  </tr>
		  </table>
		  
		  </form>
		  
		  </fieldset>
		
		</div>

		  
		
		<div>
		<br />
		<table class="tabledatacollapse" style="width: 100%;">
		<tr class="rowheader">
		<td style="width: 50%;">Menu Items</td>
		<td>Menu options</td>
		</tr>
		<tr>
		<td valign="top">
		<div style="text-align: right;">
		<a href="#" onClick="document.spacerform.submit();">add spacer</a> ::
		<a href="#" onClick="myFadeSize3.toggle('height');">add heading</a> ::
		<a href="#" onClick="myFadeSize.toggle('height');">add menu item</a> ::
		</div>
		<div id="popmenuitemadd">
		  <br />
		  <form action="/menu/jpage/1/p/MenuChoose/admin/1/content.do" method="post" name="imf" id="imf">
		  <table class="tabledatacollapse" align="right" style="padding-top: 1em">
		  <tr class="rowheader">
		  <td colspan="2">Add item</td>
		  </tr>
		  <tr>
		  <td>Name:</td>
		  <td>
		  <input type="hidden" name="menu_id" value="<%=menu_id%>" />
		  <input type="text" class="inputbox" name="menuitemname" />&nbsp;<input type="submit" value="go" class="inputbox" /></td></tr>
		  </table>
		  </form>
		</div>
		<div id="popheaderadd">
		  <br />
		  <form action="/menu/jpage/1/p/MenuChoose/admin/1/content.do" method="post" name="heading" id="heading">
		  <table class="tabledatacollapse" align="right" style="padding-top: 1em">
		  <tr class="rowheader">
		  <td colspan="2">Add heading</td>
		  </tr>
		  <tr>
		  <td>Heading:</td>
		  <td>
		  <input type="hidden" name="menu_id" value="<%=menu_id%>" />
		  <input type="text" class="inputbox" name="headingname" />&nbsp;<input type="submit" value="go" class="inputbox" /></td></tr>
		  </table>
		  </form>
		</div>
		<div>
		<form name="spacerform" method="post">
		<input type="hidden" name="menu_id" value="<%=menu_id%>" />
		<input type="hidden" name="addspacer" value="true" />
		</form>
		<form name="menusortform" id="menusortform" action="">
		<input type="hidden" name="postval" id="postval" value="" />
		<ul id="themenus" class="tabledata">
		<%
		while (crs.next()) {
		%>
		<li onMouseUp="performAction()" id="<%=crs.getInt("menu_item_id")%>" style="list-style: none; padding-bottom: 3px;">
		<%if (crs.getString("menu_item_is_heading").equalsIgnoreCase("y")) {%>
		<div class="handle" style="border: 1px solid gray; max-width: 50%;">&nbsp;&nbsp;&nbsp;
			<a href="/admin/jpage/1/p/MenuItemDetail/a/menuitemdetail/class/menuitem/admin/1/content.do?edit=false&amp;cancelPage=/menu/jpage/1/p/MenuChoose/menu_id/<%=crs.getInt("menu_id")%>/admin/1/content.do&amp;id=<%=crs.getInt("menu_item_id")%>"><%=crs.getString("menu_item_detail_name")%></a> (heading)&nbsp; <%=crs.getString("status")%></div>
		<%} else if (crs.getString("menu_item_is_spacer").equalsIgnoreCase("y")) {%>
		<div class="handle" style="border: 1px solid gray; max-width: 50%; text-align: right;"><a href="/menu/jpage/1/p/MenuChoose/class/menu/admin/1/content.do?deletespacer=1&menu_id=<%=menu_id%>&miid=<%=crs.getInt("menu_item_id")%>">delete</a>&nbsp;&nbsp;&nbsp;</div>
		<%} else {%><div class="handle" style="border: 1px solid gray; max-width: 50%;">&nbsp;&nbsp;&nbsp;<a href="/admin/jpage/1/p/MenuItemDetail/a/menuitemdetail/class/menuitem/admin/1/content.do?edit=false&amp;cancelPage=/menu/jpage/1/p/MenuChoose/menu_id/<%=crs.getInt("menu_id")%>/admin/1/content.do&amp;id=<%=crs.getInt("menu_item_id")%>"><%=crs.getString("menu_item_detail_name")%></a>&nbsp; <%=crs.getString("status")%></div> <%}%>
		</li>
		<%
		}
		%>
		</ul>
		</form>
		</div>
		</td>
		<td valign="top">
		<div style="text-align: right;">
		<% if (menu_id > 1) {%><a href="#" onClick="return confirmDelete()">delete this menu</a> ::<%}%>
		<a href="#" onClick="myFadeSize2.toggle('height');">new menu</a> ::
		<a href="#" onClick="document.formdetails.submit()">save</a> ::
		</div>
		<div id="popmenuadd">
		  <br />
		  <form action="/menu/jpage/1/p/MenuChoose/admin/1/content.do" method="post" name="imf" id="imf">
		  <table class="tabledatacollapse" align="right" style="padding-top: 1em;">
		  <tr class="rowheader">
		  <td colspan="2">Add menu</td>
		  </tr>
		  <tr>
		  <td>Menu Name:</td>
		  <td>
		  <input type="text" class="inputbox" name="menuname" />&nbsp;<input type="submit" value="go" class="inputbox" /></td></tr>
		  </table>
		  </form>
		</div>
		<form action="/menu/jpage/1/p/MenuChoose/admin/1/content.do" method="post" name="formdetails" id="formdetails">
		<table class="tabledata">
		<tr>
		<td>Menu name</td>
		<td><input class="inputbox" name="menu_name" value="<%=menuname%>"/></td>
		</tr>
		<tr>
		<td>Menu divider (horiz. only)</td>
		<td><input class="inputbox" name="menudivider" id="menudivider" value="<%=menudivider%>" /></td>
		</tr>
		<tr>
		<td>Menu type</td>
		<td><select class="inputbox" name="ct_menu_type" id="ct_menu_type">
		<option value="1"<%if(ct_menu_type == 1){%> selected <%}%>>Horizontal</option>
		<option value="2"<%if(ct_menu_type == 2){%> selected <%}%>>Vertical</option>
		<option value="3"<%if(ct_menu_type == 3){%> selected <%}%>>Collapsible</option>
		</select></td>
		</tr>
		<tr>
		<td>Menu alignment</td>
		<td><select class="inputbox" name="ct_menu_alignment_type">
		<option value="1"<%if(ct_menu_alignment_type == 1){%> selected <%}%>>Left</option>
		<option value="2"<%if(ct_menu_alignment_type == 2){%> selected <%}%>>Right</option>
		<option value="3"<%if(ct_menu_alignment_type == 3){%> selected <%}%>>Centre</option>
		</select></td>
		</tr>
		</table>
		<input type="hidden" name="menu_id" value="<%=menu_id%>" />


		</form>
		</td>
		</tr>
		</table>
		</div>
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
