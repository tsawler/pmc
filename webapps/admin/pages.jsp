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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ page import="org.displaytag.sample.*,
                 org.displaytag.tags.TableTag,
                 org.apache.commons.beanutils.*" %>
<%@ taglib uri="/WEB-INF/vtags.tld" prefix="v" %>
<%@ page language="java" import="com.fredck.FCKeditor.*" %>
<jsp:useBean id="pages" scope="request" class="com.verilion.database.PageTemplate" />
<%
String lastName = "";
String query = "";
int pagesize = 30;

String tablepager = "";

if (request.getParameter("d-4014121-p") != null) {
	tablepager = request.getParameter("d-4014121-p");
	session.setAttribute("d-4014121-p", tablepager + "");
}

if (request.getParameter("pagesize") != null) {
	pagesize = Integer.parseInt((String) request.getParameter("pagesize"));
	session.setAttribute("pagesPageSize", pagesize + "");
} else if (session.getAttribute("pagesPageSize") != null) {
	pagesize = Integer.parseInt((String) session.getAttribute("pagesPageSize"));
}

if (request.getParameter("pagesize") != null) {
	pagesize = Integer.parseInt((String) request.getParameter("pagesize"));
}
pages.setConn(conn);
if (request.getParameter("searchName") != null) {
	pages.createCustomWhere(" where page_name ilike '" + request.getParameter("searchName") + "%' and page_immutable = 'n'");
	lastName = request.getParameter("searchName");
} else {
	pages.createCustomWhere(" where page_immutable = 'n'");
}

RowSetDynaClass resultset = pages.getPageNamesIdsStatusesDynaBean();
request.setAttribute("results", resultset);
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
        <td class="tableheader"><!-- InstanceBeginEditable name="Title" -->Maintain Pages<!-- InstanceEndEditable --></td>
        </tr>
        <tr style="height: 15px;"><td class="tabledata">
        <v:message />
        </td></tr>
        <tr><td class="tabledata" valign="top">
		<!-- InstanceBeginEditable name="WorkArea" -->
		<div align="center">
		<fieldset><legend>Maintain pages</legend>
		<form method="post" action="/pages/jpage/1/p/EditPageChoose/admin/1/content.do">
		<table class="tabledata">
		  <tr>
		    <td>Page Name (all or partial)</td>
			<td>Paging</td>
		  </tr>
		  <tr>
		    <td>
			<input type="text" name="searchName" id="searchName" class="form-autocomplete" size="40" value="<%=lastName%>" />
			</td>
			<td>
			<select onchange="this.form.submit();" class="inputbox" name="pagesize">
		  <option value="5" <% if (pagesize == 5){%> selected="selected" <%}%>>5 per page</option>
		  <option value="10" <% if (pagesize == 10){%> selected="selected" <%}%>>10 per page</option>
		  <option value="20" <% if (pagesize == 20){%> selected="selected" <%}%>>20 per page</option>
		  <option value="30" <% if (pagesize == 30){%> selected="selected" <%}%>>30 per page</option>
		  <option value="40" <% if (pagesize == 40){%> selected="selected" <%}%>>40 per page</option>
		  <option value="50" <% if (pagesize == 50){%> selected="selected" <%}%>>50 per page</option>
		  </select>
			&nbsp;<input type="submit" class="inputbox" value="Go" /></td>
		  </tr>
		  </table>
		  </form>
		  <ajax:autocomplete
			  source="searchName"
			  target="searchName"
			  baseUrl="/AutoComplete.jsr"
			  className="autocomplete"
			  parameters="searchname={searchName},table=page,field=page_name"
			  progressStyle="throbbing"
			  minimumCharacters="1" />
		  </fieldset>
		  </fieldset>
		
		</div>
		<div>
			<display:table name="requestScope.results.rows" requestURI="/pages/jpage/1/p/EditPageChoose/admin/1/content.do" export="false" defaultsort="1" id="pagesObj" pagesize="<%=pagesize%>"  class="tabledatacollapse" style="width: 100%" >
			 <display:column property="page_name" title="Page" href="/admin/jpage/1/p/EditPage/a/editpage/language_id/1/class/page/admin/1/content.do?edit=false&cancelPage=/pages/jpage/1/p/EditPageChoose/admin/1/content.do" paramId="id" paramProperty="page_id" sortable="true" headerClass="sortable" />
			 <display:column property="page_detail_title" title="Title" />
			 <display:column property="page_status" title="Status" />
			</display:table>
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
