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
<%
String lastName = "";
String stat = "z";
String query = "";
String cwhere = " where true ";
int pagesize = 10;
String tablepager = "";
String cdatewhere = "";
int startMonth = 0;
int endMonth = 0;
int startYear = 0;
int endYear = 0;

int month = 0;
int year = 0;

GregorianCalendar x = new GregorianCalendar();
int thisyear = x.get(Calendar.YEAR);

boolean limitSearch = false;

if (request.getParameter("d-3569243-p") != null) {
	tablepager = request.getParameter("d-3569243-p");
	session.setAttribute("d-3569243-p", tablepager + "");
}

if (request.getParameter("pagesize") != null) {
	pagesize = Integer.parseInt((String) request.getParameter("pagesize"));
	session.setAttribute("banPageSize", pagesize + "");
} else if (session.getAttribute("banPageSize") != null) {
	pagesize = Integer.parseInt((String) session.getAttribute("banPageSize"));
}

if (request.getParameter("pagesize") != null) {
	pagesize = Integer.parseInt((String) request.getParameter("pagesize"));
}

if (request.getParameter("searchName") != null) {
	cwhere += " and banner_name ilike '" + request.getParameter("searchName") + "%' ";
	lastName = request.getParameter("searchName");
}

if (request.getParameter("start_month") != null) {
	if (request.getParameter("start_month").length() > 0) {
		limitSearch = true;
		startMonth = Integer.parseInt((String) request.getParameter("start_month"));
	}
}

if (request.getParameter("start_year") != null) {
	if (request.getParameter("start_year").length() > 0) {
		limitSearch = true;
		startYear = Integer.parseInt((String) request.getParameter("start_year"));
	}
}

if (request.getParameter("end_month") != null) {
	if (request.getParameter("end_month").length() > 0) {
		limitSearch = true;
		endMonth = Integer.parseInt((String) request.getParameter("end_month"));
	}
}

if (request.getParameter("end_year") != null) {
	if (request.getParameter("end_year").length() > 0) {
		limitSearch = true;
		endYear = Integer.parseInt((String) request.getParameter("end_year"));
	}
}


/*if (!limitSearch) {
	query = "select b.*, bbi.banner_impressions, bbc.banner_clicks "
		+ "from banners b "
		+ "left join banner_banner_impressions bbi on (b.banner_id = bbi.banner_id) "
		+ "left join banner_banner_clicks bbc on (b.banner_id = bbc.banner_id) " 
		+ " order by banner_name";
} else {
*/

	if (endYear == 0)
		endYear = 3000;
		
	String queryLimitStart = "";
	String queryLimitEnd = "";
	String queryLimitStartClick = "";
	String queryLimitEndClick = "";
	
		if (startMonth > 0) {
			queryLimitStart = "and ((impression_month >= " 
				+ startMonth
				+ " and impression_year >= "
				+ startYear
				+ ") or (impression_year > "
				+ startYear
				+ ")) ";
		}
		
		if (endMonth > 0) {
			queryLimitEnd = "and ((impression_month <= " 
				+ endMonth
				+ " and impression_year <= "
				+ endYear
				+ ") or (impression_year < "
				+ endYear
				+ ")) ";
		}
		if (startMonth > 0) {
			queryLimitStartClick = "and ((click_month >= " 
				+ startMonth
				+ " and click_year >= "
				+ startYear
				+ ") or (click_year > "
				+ startYear
				+ ")) ";
		}
		
		if (endMonth > 0) {
			queryLimitEndClick = "and ((click_month <= " 
				+ endMonth
				+ " and click_year <= "
				+ endYear
				+ ") or (click_year < "
				+ endYear
				+ ")) ";
		}
		
	query = "select b.*, (select sum(banner_impressions) from pmc.banner_banner_impressions_by_month bibm where bibm.banner_id = b.banner_id "
		+ queryLimitStart
		+ queryLimitEnd
		+ ") as banner_impressions, "
		+ "(select sum(banner_clicks) from pmc.banner_banner_clicks_by_month bcbm where bcbm.banner_id = b.banner_id "
		+ queryLimitStartClick
		+ queryLimitEndClick
		+ ") as banner_clicks "
		+ "from pmc.banners b order by banner_name";

		//System.out.println("query: \n" + query);
//}
	
ResultSet rs = null;
Statement st = null;
st = conn.createStatement();
rs = st.executeQuery(query);

RowSetDynaClass resultset = null;
resultset = new RowSetDynaClass(rs, false);
rs.close();
rs = null;
st.close();
st = null;
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
        <td class="tableheader"><!-- InstanceBeginEditable name="Title" -->Banner Reports<!-- InstanceEndEditable --></td>
        </tr>
        <tr style="height: 15px;"><td class="tabledata">
        <v:message />
        </td></tr>
        <tr><td class="tabledata" valign="top">
		<!-- InstanceBeginEditable name="WorkArea" -->
			<script language="JavaScript" src="/admin/js/CalendarPopup.js"></script>
	<script language="JavaScript" id="jscal1xx">
		var cal1xx = new CalendarPopup();
		cal1xx.showNavigationDropdowns();
		var cal2xx = new CalendarPopup();
		cal2xx.showNavigationDropdowns();
		</script>
		<div align="center">
		<fieldset><legend>Banner Reports</legend>
		<form method="post" id="searchform" name="searchform" action="/bannerreports/jpage/1/p/bannerreports/admin/1/content.do">
		<table class="tabledata">
		  <tr>
		    <td>Banner</td>
			<td>From</td>
			<td>To</td>
			<td>Paging</td>
		  </tr>
		  <tr>
		    <td>
			<input type="text" name="searchName" id="searchName" class="form-autocomplete" size="10" value="<%=lastName%>" />
			</td>
			<td>
			<select name="start_month" class="inputbox">
			<option value="0">Any month</option>
			<%
			for (int i = 1; i<=12;i++){
				String[] themonths = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
				%>
				<option value="<%=i%>" <%if (startMonth == i){%> selected <%}%>><%=themonths[i - 1]%></option>
				<%
			}
			%>
			</select>
			<select name="start_year" class="inputbox">
			<option value="0">Any year</option>
			<%
			for (int i=2002; i<=2020; i++){
				%>
				<option value="<%=i%>" <%if (startYear == i){%> selected <%}%>><%=i%></option>
				<%
			}
			%>
			</select>
			</td>
			<td>
			<select name="end_month" class="inputbox">
			<option value="0">Any month</option>
			<%
			for (int i = 1; i<=12;i++){
			String[] themonths = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
				%>
				<option value="<%=i%>" <%if (endMonth == i){%> selected <%}%>><%=themonths[i - 1]%></option>
				<%
			}
			%>
			</select>
			<select name="end_year" class="inputbox">
			<option value="0">Any year</option>
			<%
			for (int i=2002; i<=2020; i++){
				%>
				<option value="<%=i%>" <%if (endYear == i){%> selected <%}%>><%=i%></option>
				<%
			}
			%>
			</select>
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
</fieldset></div>
		  <ajax:autocomplete
			  source="searchName"
			  target="searchName"
			  baseUrl="/AutoComplete.jsr"
			  className="autocomplete"
			  parameters="searchname={searchName},table=banners,field=banner_name"
			  progressStyle="throbbing"
			  minimumCharacters="1" />
		
		
		<div>
			<display:table name="requestScope.results.rows" requestURI="/bannerreports/jpage/1/p/bannerreports/admin/1/content.do" 
				export="true" 
				defaultsort="6" 
				id="bannerrep"  
				pagesize="<%=pagesize%>"  
				class="tabledatacollapse" 
				style="width: 100%"  >
			  <display:column property="banner_name" title="Banner" sortable="true" headerClass="sortable" />
			  <display:column property="banner_impressions" title="Impressions" />
			  <display:column property="banner_clicks" title="Clicks" />
			  <display:column property="banner_id" title="ID" sortable="true" headerClass="sortable" />
			  <display:setProperty name="export.pdf" value="true" />
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
