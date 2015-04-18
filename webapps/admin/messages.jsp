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
<script language="JavaScript" type="text/javascript">
<!--
function confirmDelete(theId)
{
var agree=confirm("Are you sure you wish to delete this message?");
	if (agree) {
		var myLoc = "/messages/jpage/1/p/messages/admin/1/content.do?maction=delete&id=" + theId;
		location.href= myLoc;
	}
	else
		return false;
}
-->
</script>
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
<jsp:useBean id="msg" scope="request" class="com.verilion.database.CustomerMessages" />
<%
String lastName = "";
String query = "";
int pagesize = 10;
String tablepager = "";
int message_id = 0;
int message_sent_id = 0;
String to = "";
String subject = "";

msg.setConn(conn);

try {
	message_id = Integer.parseInt((String) request.getParameter("message_id"));
} catch (Exception e) {
	message_id = 0;
}

try {
	message_sent_id = Integer.parseInt((String) request.getParameter("message_sent_id"));
} catch (Exception e) {
	message_sent_id= 0;
}

if (request.getParameter("maction") != null) {
	if (request.getParameter("maction").equalsIgnoreCase("send")) {
		// we are sending a message
		to = (String) request.getParameter("to");
		subject = (String) request.getParameter("thesubject");
		String mes = (String) request.getParameter("themessage");
		
		msg.setFrom_id(Integer.parseInt((String) session.getAttribute("customer_id")));
		msg.setUsername(to);
		msg.setSubjectText(subject);
		msg.setMessageText(mes);
		msg.setIsReadYn("n");
		msg.addMessageForUsername();
		
		msg.addSentMessageForUsername();
		
		session.setAttribute("Error", "Message sent.");
		response.sendRedirect("/messages/jpage/1/p/messages/admin/1/content.do");
		return;
	} else if (request.getParameter("maction").equalsIgnoreCase("delete")){
		msg.setCustomer_messages_id(Integer.parseInt((String) request.getParameter("id")));
		msg.setTo_id(Integer.parseInt((String) session.getAttribute("customer_id")));
		msg.deleteMessage();
		
		session.setAttribute("Error", "Message deleted.");
		response.sendRedirect("/messages/jpage/1/p/messages/admin/1/content.do");
		return;
	}
}
if (request.getParameter("d-4019015-p") != null) {
	tablepager = request.getParameter("d-4019015-p");
	session.setAttribute("d-4019015-p", tablepager + "");
}

if (request.getParameter("pagesize") != null) {
	pagesize = Integer.parseInt((String) request.getParameter("pagesize"));
	session.setAttribute("messagesPageSize", pagesize + "");
} else if (session.getAttribute("messagesPageSize") != null) {
	pagesize = Integer.parseInt((String) session.getAttribute("messagesPageSize"));
}

if (request.getParameter("pagesize") != null) {
	pagesize = Integer.parseInt((String) request.getParameter("pagesize"));
}

if (request.getParameter("searchName") != null) {
	msg.setSCustomWhere(" where true and subject ilike '" + request.getParameter("searchName") + "%' ");
	lastName = request.getParameter("searchName");
}
msg.setTo_id(Integer.parseInt((String) session.getAttribute("customer_id")));
RowSetDynaClass resultset = msg.getAllMessagesForCustomerIdDyaBean();
request.setAttribute("results", resultset);
RowSetDynaClass resultset_sent = msg.getAllSentMessagesForCustomerIdDyaBean();
request.setAttribute("results_sent", resultset_sent);
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
        <td class="tableheader"><!-- InstanceBeginEditable name="Title" -->Private Messages<!-- InstanceEndEditable --></td>
        </tr>
        <tr style="height: 15px;"><td class="tabledata">
        <v:message />
        </td></tr>
        <tr><td class="tabledata" valign="top">
		<!-- InstanceBeginEditable name="WorkArea" -->
		<div id="messagetabs" class="tabber">
		<div class="tabbertab">
		<h2>Inbox</h2>
		
		<div>
		<%
		if (message_id == 0) {%>
		<div align="center">
		<fieldset><legend>Read Private Messages</legend>
		<form method="post" action="/messages/jpage/1/p/messages/a/messages/admin/1/content.do">
		<table class="tabledata">
		  <tr>
		    <td>Subject  (all or partial)</td>
			<td>Paging</td>
		  </tr>
		  <tr>
		    <td>
			<input type="text" name="searchName" id="searchName" class="inputbox" size="40" value="<%=lastName%>" />
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
		</fieldset>
		</div>
			<display:table name="requestScope.results.rows" requestURI="/messages/jpage/1/p/messages/a/messages/admin/1/content.do" export="false" defaultsort="4" id="msgTable" pagesize="<%=pagesize%>"  class="tabledatacollapse" style="width: 100%" >
			 <display:column property="subject" title="Subject" href="/messages/jpage/1/p/messages/admin/1/content.do" paramId="message_id" paramProperty="customer_message_id" sortable="true" headerClass="sortable" />
			  <display:column property="from_name" title="From" sortable="true" headerClass="sortable" />
			  <display:column property="status" title="Status" />
			  <display:column property="date_sent" title="Date" sortable="true" headerClass="sortable"/>
			  <display:column property="time_sent" title="Time" sortable="true" headerClass="sortable" />
			  <display:setProperty name="export.pdf" value="false" />
			</display:table>
		<%
		} else {
		XDisconnectedRowSet drs = new XDisconnectedRowSet();
		msg.setCustomer_messages_id(message_id);
		drs = msg.getOneMessageById();
		if (drs.next()) {
		msg.setMessageToRead(message_id);
		%>
		<br /><br />
		<table class="tabledatacollapse" style="width: 80%">
			<tr class="tableheader">
			<td colspan="2">
			<strong>Read message</strong>
			</td>
			</tr>
			<tr>
			<td>From:</td>
			<td><%=drs.getString("from_name")%></td>
			</tr>
			<tr>
			<td>Subject</td>
			<td><%=drs.getString("subject")%></td>
			</tr>
			<tr>
			<td>Date:</td>
			<td><%=drs.getString("date_sent")%>&nbsp;<%=drs.getString("time_sent")%></td>
			</tr>
			</table>
			<br /><br  />
			<strong>Message</strong><br /><br />

			<%=drs.getString("message")%>
			<br /><br />
			<a href="/messages/jpage/1/p/messages/admin/1/content.do?reply=1&repto=<%=drs.getString("from_name")%>&subject=RE:<%=drs.getString("subject")%>">Reply to this message</a>&nbsp;&nbsp;
			<a href="#" onclick="confirmDelete(<%=message_id%>)">Delete this message</a>&nbsp;&nbsp;
			<a href="/messages/jpage/1/p/messages/admin/1/content.do">Back to inbox</a>

		<%
		}
		}
		%>
		</div>
		</div>
		<div class="tabbertab<%if (request.getParameter("reply") != null) {%> tabbertabdefault<%}%>">
		<h2>Compose</h2>
		<%
		if (request.getParameter("repto") != null) {
			to = (String) request.getParameter("repto");
			subject = (String) request.getParameter("subject");
		} else {
			to = "";
		}
		%>
		<form action="/messages/jpage/1/p/messages/admin/1/content.do" method="post">
		<input type="hidden" name="maction" value="send" />
		<table class="tabledatacollapse" style="width: 75%">
		<tr class="tableheader">
		<td colspan="2">
		Compose Message
		</td>
		</tr>
		<tr>
		<td>To:</td>
		<td><input type="text" name="to" id="to" value="<%=to%>" class="form-autocomplete" size="30"/></td>
		</tr>
		<tr>
		<td>
		Subject:
		</td>
		<td>
		<input type="text" name="thesubject" value="<%=subject%>" class="inputbox" size="30" />
		</td>
		</tr>
		<tr>
		<td colspan="2">
		Message
		</td>
		</tr>
		<tr>
		<td colspan="2">
		<textarea class="inputbox" rows="8" cols="80" name="themessage"></textarea>
		</td>
		</tr>
		</table>
		<br />
		<input type="submit" value="Send message" class="inputbox" />
		</form>
		
		<ajax:autocomplete
			  source="to"
			  target="to"
			  baseUrl="/AutoComplete.jsr"
			  className="autocomplete"
			  parameters="searchname={to},table=customer,field=username"
			  progressStyle="throbbing"
			  minimumCharacters="1" />
		</div>
		<div class="tabbertab<%if (message_sent_id > 0) {%> tabbertabdefault<%}%>">
		<h2>Sent</h2>
		<%
		if (message_sent_id == 0) {%>
		<display:table name="requestScope.results_sent.rows" requestURI="/messages/jpage/1/p/messages/a/messages/admin/1/content.do" export="false" defaultsort="4" id="msgTable" pagesize="<%=pagesize%>"  class="tabledatacollapse" style="width: 100%" >
			 <display:column property="subject" title="Subject" href="/messages/jpage/1/p/messages/admin/1/content.do" paramId="message_sent_id" paramProperty="customer_message_sent_id" sortable="true" headerClass="sortable" />
			  <display:column property="to_name" title="From" sortable="true" headerClass="sortable" />
			  <display:column property="date_sent" title="Date" sortable="true" headerClass="sortable"/>
			  <display:column property="time_sent" title="Time" sortable="true" headerClass="sortable" />
			  <display:setProperty name="export.pdf" value="false" />
			</display:table>
		<%
		} else {
		XDisconnectedRowSet drs = new XDisconnectedRowSet();
		msg.setCustomer_message_sent_id(message_sent_id);
		drs = msg.getOneSentMessageById();
		if (drs.next()) {
		%>
		<br /><br />
		<table class="tabledatacollapse" style="width: 80%">
			<tr class="tableheader">
			<td colspan="2">
			<strong>Sent message</strong>
			</td>
			</tr>
			<tr>
			<td>To:</td>
			<td><%=drs.getString("to_name")%></td>
			</tr>
			<tr>
			<td>Subject</td>
			<td><%=drs.getString("subject")%></td>
			</tr>
			<tr>
			<td>Date:</td>
			<td><%=drs.getString("date_sent")%>&nbsp;<%=drs.getString("time_sent")%></td>
			</tr>
			</table>
			<br /><br  />
			<strong>Message</strong><br /><br />

			<%=drs.getString("message")%>
		
		<%
		}
		}
		%>
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
