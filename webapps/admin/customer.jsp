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
<jsp:useBean id="myCustomer" scope="request" class="com.verilion.database.Customer" />
<%
String lastname = "";
String stat = "z";
String query = "";
String cwhere = "";
int pagesize = 10;
String email = "";
String username = "";
String tablepager = "";
boolean searching = false;

if (request.getParameter("d-49385-p") != null) {
	tablepager = request.getParameter("d-49385-p");
	session.setAttribute("d-49385-p", tablepager + "");
}

if (request.getParameter("pagesize") != null) {
	searching = true;
	pagesize = Integer.parseInt((String) request.getParameter("pagesize"));
	session.setAttribute("custPageSize", pagesize + "");
} else if (session.getAttribute("custPageSize") != null) {
	pagesize = Integer.parseInt((String) session.getAttribute("custPageSize"));
}

if (request.getParameter("pagesize") != null) {
	pagesize = Integer.parseInt((String) request.getParameter("pagesize"));
}
if (request.getParameter("stat") != null) {
	stat = (String) request.getParameter("stat");
	if (stat.equals("z")) {
	
	} else if (stat.equals("p")) {
		cwhere += " and customer_active_yn = 'p' ";
	} else {
		cwhere += " and customer_active_yn = '" + stat + "' ";
	}
}
//myCustomer.setConn(conn);
if (request.getParameter("searchname") != null) {
	cwhere += " and customer_last_name ilike '" + request.getParameter("searchname") + "%' ";
	lastname = request.getParameter("searchname");
}

if (request.getParameter("email") != null) {
	cwhere += " and customer_email ilike '" + request.getParameter("email") + "%' ";
	email = request.getParameter("email");
} 

if (request.getParameter("username") != null) {
	cwhere += " and username ilike '" + request.getParameter("username") + "%' ";
	username = request.getParameter("username");
}
if (searching) {
//myCustomer.setSCustomWhere(cwhere);
GenericTable myT = new GenericTable("v_pmc_customer");
myT.setConn(conn);
myT.setSSelectWhat("*");
myT.setSCustomWhere(cwhere);

RowSetDynaClass resultset = myT.getAllRecordsDynaBean();
request.setAttribute("results", resultset);
}
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
        <td class="tableheader"><!-- InstanceBeginEditable name="Title" --><%=page_detail_title%><!-- InstanceEndEditable --></td>
        </tr>
        <tr style="height: 15px;"><td class="tabledata">
        <v:message />
        </td></tr>
        <tr><td class="tabledata" valign="top">
		<!-- InstanceBeginEditable name="WorkArea" -->
		<div align="center">
		<fieldset>
		<legend>Maintain members </legend>
		<form method="post" id="searchform" action="/customer/jpage/1/p/SearchCustomers/admin/1/content.do">
		<table class="tabledata">
		  <tr>
		    <td>Last Name</td>
			<td>Username</td>
			<td>Email</td>
			<td>Status</td>
			<td>Paging</td>
		  </tr>
		  <tr>
		    <td>
			<input type="text" name="searchname" id="searchname" class="form-autocomplete" size="20" value="<%=lastname%>" />
			</td>
			<td><input type="text" name="username" id="username" class="form-autocomplete" size="20" value="<%=username%>" /></td>
			<td><input type="text" name="email" id="email" class="form-autocomplete" size="20" value="<%=email%>" /></td>
			<td><select class="inputbox" name="stat">
			<option value="z" <%if (stat.equals("z")){%> selected="selected" <%}%>>Any</option> 
			<option value="y" <%if (stat.equals("y")){%> selected="selected" <%}%>>Active</option> 
			<option value="n" <%if (stat.equals("n")){%> selected="selected" <%}%>>Inactive</option> 
			<option value="p" <%if (stat.equals("p")){%> selected="selected" <%}%>>Pending</option>
			</select></td>
			<td>
			<select onChange="this.form.submit();" class="inputbox" name="pagesize">
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
			  source="searchname"
			  target="searchname"
			  baseUrl="/AutoComplete.jsr"
			  className="autocomplete"
			  progressStyle="throbbing"
			  parameters="searchname={searchname},table=v_customer,field=customer_last_name"
			  minimumCharacters="1" />
			<ajax:autocomplete
			  source="username"
			  target="username"
			  baseUrl="/AutoComplete.jsr"
			  className="autocomplete"
			  progressStyle="throbbing"
			  parameters="searchname={username},table=v_customer,field=username"
			  minimumCharacters="1" />
			<ajax:autocomplete
			  source="email"
			  target="email"
			  baseUrl="/AutoComplete.jsr"
			  className="autocomplete"
			  progressStyle="throbbing"
			  parameters="searchname={email},table=v_customer,field=customer_email"
			  minimumCharacters="1" />
</fieldset></div>
		  
		
		
		<div>
			<display:table name="requestScope.results.rows" requestURI="/customer/jpage/1/p/SearchCustomers/admin/1/class/customer/content.do" 
				export="true" 
				defaultsort="1" 
				id="cust"  
				pagesize="<%=pagesize%>"  
				class="tabledatacollapse" 
				style="width: 100%"  >
			  <display:column property="customer_last_name" title="Last name" href="/admin/jpage/1/p/DisplayCustomer/a/displaycustomerpmc/admin/1/content.do?cancelPage=/customer/jpage/1/p/SearchCustomers/admin/1/content.do&edit=false" paramId="id" paramProperty="customer_id" sortable="true" headerClass="sortable" />
			  <display:column property="customer_first_name" title="First name" href="/admin/jpage/1/p/DisplayCustomer/a/displaycustomerpmc/class/customer/admin/1/content.do?cancelPage=/customer/jpage/1/p/SearchCustomers/admin/1/content.do&edit=false" paramId="id" paramProperty="customer_id" />
			  <display:column property="username" title="Username" sortable="true" headerClass="sortable" />
			  <display:column property="customer_email" title="Email" media="html" autolink="true" />
			  <display:column property="customer_email" title="Email" media="excel pdf" autolink="false" />
			  <display:column property="interests" media="excel pdf" title="Interests" />
			  <display:column property="bio" media="excel pdf" title="Bio" />
			  <display:column property="implant_year" media="excel pdf" title="Implant Year" />
			  <display:column property="device_brand" media="excel pdf" title="Manufacturer" />
			  <display:column property="model" media="excel pdf" title="Model" />
			  <display:column property="birth_year" media="excel pdf" title="Birth Year" />
			  <display:column property="occupation" media="excel pdf" title="Occupation" />
			  <display:column property="device_type_text" media="excel pdf" title="Device Type" />
			  <display:column property="add_to_mailing_list" media="excel pdf" title="Mailing list" />
			  <display:column property="number_of_devices" media="excel pdf" title="No. Devices" />
			  <display:column property="customer_town_city" media="excel pdf" title="City" />
			  <display:column property="ct_province_state_name" media="excel pdf" title="State" />
			  <display:column property="ct_country_name" media="excel pdf" title="Country" />
			  <display:setProperty name="export.pdf" value="true" />
			  <display:caption>Customer List</display:caption>
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
