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
<script type='text/javascript' src='/js/tabber.js'></script>

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
<script type="text/javascript" src="/ck/ckeditor.js"></script>

<!-- InstanceEndEditable -->
</head>

<body class="treenavpage" style="height: 100%;">
<!-- InstanceBeginEditable name="BeforeHTML" -->
<%
String from = "";
String to = "";
String subject = "";
String message_text = "";
Statement st = null;
ResultSet rs = null;
XDisconnectedRowSet drs = new XDisconnectedRowSet();

if (request.getParameter("subject") != null) {
	// sending a message
	message_text = request.getParameter("message_text");
	subject = request.getParameter("subject");
	from = request.getParameter("from_email");
	st = conn.createStatement();
	rs = st.executeQuery("select distinct customer_email from v_pmc_customer where customer_add_to_mailing_list = 1 and customer_active_yn = 'y'");
	drs.populate(rs);
	rs.close();
	rs = null;
	st.close();
	st = null;
	while (drs.next()){
		to = drs.getString("customer_email");
		GenericTable myTable = new GenericTable("message_queue");
		myTable.setConn(conn);
		myTable.addUpdateFieldNameValuePair(
			"message_queue_message",
			message_text,
			"String");
		myTable.addUpdateFieldNameValuePair(
			"message_queue_from",
			from,
			"String");
		myTable.addUpdateFieldNameValuePair(
			"message_queue_to",
			to,
			"String");
		myTable.addUpdateFieldNameValuePair(
			"message_queue_subject",
			subject,
			"String");
		myTable.insertRecord();
	}
	session.setAttribute("Error", "Messages entered into queue successfully");
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
        <td class="tableheader"><!-- InstanceBeginEditable name="Title" -->Create & Send Email<!-- InstanceEndEditable --></td>
        </tr>
        <tr style="height: 15px;"><td class="tabledata">
        <v:message />
        </td></tr>
        <tr><td class="tabledata" valign="top">
		<!-- InstanceBeginEditable name="WorkArea" -->
<script type='text/javascript'>
function validateForm() {
	var okay = true;
	var result = "";
	result = checkRequired("from_email");
	result = checkRequired("subject");
	if (result != "") {
		okay = false;
	}
	return okay;
}

function checkRequired(fieldName) {
	var theReply = "";
	if (dwr.util.getValue(fieldName) == "") {
		processReply(false, fieldName, fieldName + "-error", " *Value required");
		theReply = "Missing field";
	}
	return theReply;
}

function processReply(valid, id, errid, error) {
	if (valid)
	{
		dwr.util.setValue(errid, "");
	}
	else
	{
		dwr.util.setValue(errid, error);
	}
}

function performAction ( selectedtype ) {
	if (selectedtype == 0) {
		var okay = true;
		okay = validateForm();
		if (okay) {
			document.emailform.action.value = selectedtype ;
			document.emailform.submit() ;
		}
	} else {
		document.emailform.action.value = selectedtype ;
		document.emailform.submit() ;
	}
}

</script>
<style>
.error { color: red; }
</style>

		<table class="content" style="width: 100%">
	<tr>
		<td style="text-align: right;">
			<a href="javascript:performAction('0')">Send Message</a> ::
			<a href="/admin/jpage/1/p/Welcome/admin/1/content.do">Cancel</a> 
			
		</td>
	</tr>
</table>
		<div class="content">
		<form name="emailform" id="emailform" action="/createmessage/jpage/1/p/createmessage/admin/1/content.do" method="post">
			<table class="tabledatacollapse" width="100%">
			<tr class="tableheader">
			<td colspan="2">Create and send a message</td>
			</tr>
			<tr>
			<td>From</td>
			<td>
			<input type="text" class="inputbox" size="50" id="from_email" name="from_email" value="info@pacemakerclub.com" />
			<span id="from_email-error" class="error"></span>
			</td>
			</tr>
			<tr>
			<td>Subject</td>
			<td>
			<input type="text" class="inputbox" size="50" id="subject" name="subject" value="" />
			<span id="subject-error" class="error"></span>
			</td>
			</tr>
			<tr>
			<td colspan="2">
			<textarea name="message_text" id="message_text"></textarea>
			</td>
			</tr>
			</table>
			<input type="hidden" name="action" />
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
<script type="text/javascript">
   CKEDITOR.replace( 'message_text');
</script>
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
