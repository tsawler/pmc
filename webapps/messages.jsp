<%@include file="/PageSecurity.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@taglib uri="/WEB-INF/vtags.tld" prefix="v"%>
<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="oscache" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ page import="org.displaytag.sample.*,
                 org.displaytag.tags.TableTag,
                 org.apache.commons.beanutils.*" %>
<v:gtag />
	<title>Pacemaker Club: Support &amp; Information For Pacemaker &amp; Defibrillator Patients</title>
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.2.0/build/reset-fonts-grids/reset-fonts-grids.css"> 



<%
String theTab = "";

if (request.getParameter("tab") == null) {%>
<script type="text/javascript">
/* <![CDATA[ */
document.write('<style type="text/css">.tabber{display:none;}<\/style>');
/* ]]> */
/*==================================================
  Set the tabber options (must do this before including tabber.js)
  ==================================================*/
var tabberOptions = {

  'cookie':"tabber", /* Name to use for the cookie */

  'onLoad': function(argsObj)
  {
    var t = argsObj.tabber;
    var i;

    /* Optional: Add the id of the tabber to the cookie name to allow
       for multiple tabber interfaces on the site.  If you have
       multiple tabber interfaces (even on different pages) I suggest
       setting a unique id on each one, to avoid having the cookie set
       the wrong tab.
    */
    if (t.id) {
      t.cookie = t.id + t.cookie;
    }

    /* If a cookie was previously set, restore the active tab */
    i = parseInt(getCookie(t.cookie));
    if (isNaN(i)) { return; }
    t.tabShow(i);
  },

  'onClick':function(argsObj)
  {
    var c = argsObj.tabber.cookie;
    var i = argsObj.index;
    setCookie(c, i);
  }
};

/*==================================================
  Cookie functions
  ==================================================*/
function setCookie(name, value, expires, path, domain, secure) {
    document.cookie= name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires.toGMTString() : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

function getCookie(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    } else {
        begin += 2;
    }
    var end = document.cookie.indexOf(";", begin);
    if (end == -1) {
        end = dc.length;
    }
    return unescape(dc.substring(begin + prefix.length, end));
}
function deleteCookie(name, path, domain) {
    if (getCookie(name)) {
        document.cookie = name + "=" +
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

</script>
<%
} else {
	theTab = (String) request.getParameter("tab");
}
%>

<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/yahoo-dom-event/yahoo-dom-event.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/container/container_core-min.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/animation/animation-min.js"></script> 
<script type="text/javascript" src="http://yui.yahooapis.com/2.2.0/build/menu/menu-min.js"></script> 
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.2.0/build/menu/assets/menu.css"> 

<!--
<script type='text/javascript' src='/js/ajax/engine.js'> </script>
<script type='text/javascript' src='/js/ajax/Validator.js'> </script>
<script type='text/javascript' src='/js/ajax/util.js'> </script>
-->
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/ajaxtags-1.1.js"></script> 
<script type='text/javascript' src='/js/tabber.js'></script>
<link rel="stylesheet" type="text/css" href="/styles.css">
<link href="/roundtabs.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
<!--
function confirmDelete(theId)
{
var agree=confirm("Are you sure you wish to delete this message?");
	if (agree) {
		var myLoc = "/messages/jpage/1/p/messages/content.do?maction=delete&id=" + theId;
		location.href= myLoc;
	}
	else
		return false;
}
function confirmDeleteSent(theId)
{
var agree=confirm("Are you sure you wish to delete this message?");
	if (agree) {
		var myLoc = "/messages/jpage/1/p/messages/content.do?maction=deletesent&id=" + theId;
		location.href= myLoc;
	}
	else
		return false;
}
</script>

<%=sJavaScript%>
<style type="text/css">
.first {
margin-left: -20px;
}
</style>

</head>
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
int thecustomer_id = 0;
String mes = "";
//String theTab = "";
msg.setConn(conn);

try {
	thecustomer_id = Integer.parseInt((String) session.getAttribute("customer_id"));
} catch (Exception e) {
	thecustomer_id = 0;
}

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

if (request.getParameter("repto") != null) {
	if (((String) request.getParameter("repto")).length() > 0) {
		to = request.getParameter("repto");
	} else {
		to = "";
	}
} else {
	to = "";
}

if (request.getParameter("subject") != null) {
	if (((String) request.getParameter("subject")).length() > 0) {
		subject = request.getParameter("subject");
	} else {
		subject = "";
	}
} else {
	subject = "";
}

boolean isValid = true;
if (request.getParameter("maction") != null) {
	if (request.getParameter("maction").equalsIgnoreCase("send")) {
		// we are sending a message
		String captcha_response = request.getParameter("j_captcha_response");
		String correctAnswer = (String) session
                  .getAttribute(com.verilion.object.captcha.servlet.Constants.SIMPLE_CAPCHA_SESSION_KEY);
		if (!(correctAnswer.equalsIgnoreCase(captcha_response))) {
               isValid = false;
        }
		if (isValid) {
			String serverResponse = "";
			to = (String) request.getParameter("to");
			subject = (String) request.getParameter("subject");
			mes = (String) request.getParameter("themessage");
			mes = mes.replaceAll("\n", "<br />");
			msg.setFrom_id(thecustomer_id);
			msg.setUsername(to.trim());
			msg.setSubjectText(subject);
			msg.setMessageText(mes);
			msg.setIsReadYn("n");
			serverResponse = msg.addMessageForUsernamePublic();
			if (serverResponse.length() > 0) {
				theTab = "compose";
				if (to.length() > 0) {
					session.setAttribute("Error", to.trim() + " is not a valid user. Try again...");
				} else {
					session.setAttribute("Error", "You must supply a username");
				}
			} else {
				msg.addSentMessageForUsername();
				
				// notify the recipient that they have received a pm, if they accept that kind of stuff
				
				
				GenericTable myGt = new GenericTable();
					myGt.setConn(conn);
					myGt.setSTable("v_pmc_customer");
					myGt.setSSelectWhat("customer_email, notify_on_pm");
					myGt.setSCustomWhere(" and username = '" + to + "'");
					
					XDisconnectedRowSet drs = new XDisconnectedRowSet();
					drs = myGt.getAllRecordsDisconnected();
					while (drs.next()) {
						if (drs.getString("notify_on_pm").equalsIgnoreCase("y")) {
							String toadd = drs.getString("customer_email");
							GenericTable myTable = new GenericTable("message_queue");
							myTable.setConn(conn);
							myTable.addSet(
								"message_queue_message",
								"Hello!<br /><br />"
								+ "You have received a private message on the Pacemaker Club website!"
								+ "<br /><br />"
								+ "To view your message, go to "
								+ "<a href=\"http://www.pacemakerclub.com\">"
								+ "http://www.pacemakerclub.com</a> and log in.",
								"String");
							myTable.addUpdateFieldNameValuePair(
								"message_queue_from",
								"donotreply@pacemakerclub.com",
								"String");
							myTable.addUpdateFieldNameValuePair(
								"message_queue_to",
								toadd,
								"String");
							myTable.addUpdateFieldNameValuePair(
								"message_queue_subject",
								"You've received a private message on the Pacemaker Club website!",
								"String");
							myTable.insertRecord();
						}
					}
					drs.close();
					drs = null;
					
					
				session.setAttribute("Error", "Message sent.");
				response.sendRedirect("/messages/jpage/1/p/messages/content.do");
				return;
			}
		} else {
		to = (String) request.getParameter("to");
			subject = (String) request.getParameter("subject");
			mes = (String) request.getParameter("themessage");
			theTab = "compose";
			session.setAttribute("Error", "Incorrect spam code entered. Try again...");
			//response.sendRedirect("/messages/jpage/1/p/messages/content.do");
			//return;
		}
		
		
	} else if (request.getParameter("maction").equalsIgnoreCase("delete")){
		msg.setCustomer_messages_id(Integer.parseInt((String) request.getParameter("id")));
		msg.setTo_id(thecustomer_id);
		msg.deleteMessage();
		session.setAttribute("Error", "Message deleted.");
		response.sendRedirect("/messages/jpage/1/p/messages/content.do");
		return;
	} else if (request.getParameter("maction").equalsIgnoreCase("deletesent")){
		GenericTable myTable = new GenericTable();
		myTable.setConn(conn);
		myTable.setSTable("customer_messages_sent");
		myTable.setSPrimaryKey("customer_message_sent_id");
		myTable.setIPrimaryKey(Integer.parseInt((String) request.getParameter("id")));
		myTable.deleteRecord();
		session.setAttribute("Error", "Message deleted.");
		response.sendRedirect("/messages/jpage/1/p/messages/content.do");
		return;
	}
}
msg.setTo_id(thecustomer_id);
RowSetDynaClass resultset = msg.getAllMessagesForCustomerIdDyaBean();
request.setAttribute("results", resultset);
RowSetDynaClass resultset_sent = msg.getAllSentMessagesForCustomerIdDyaBean();
request.setAttribute("results_sent", resultset_sent);
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
							<h1 style="margin-left: 2.5em"><%=page_detail_title%></h1>
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
<!-- begin message tabs -->
<div id="messagetabs" class="tabber" style="margin-left: 2.5em;">
		<div class="tabbertab<%if (theTab.equals("inbox")){%> tabbertabdefault<%}%>">
		<h2>Inbox</h2>
		<%
		if (message_id == 0) {%>
			<form action="/deleteinbox.jsp" method="post">
			<display:table name="requestScope.results.rows" requestURI="/messages/jpage/1/p/messages/content.do" export="false" defaultsort="4" id="msgTable" pagesize="10"  class="tabledatacollapse" defaultorder="descending" style="width: 100%" >
			 <display:column property="checkbox" title="" />
			 <display:column property="subject" title="Subject" href="/messages/jpage/1/p/messages/content.do" paramId="message_id" paramProperty="customer_message_id" sortable="true" headerClass="sortable" />
			  <display:column property="from_name" title="From" sortable="true" headerClass="sortable" />
			  <display:column property="status" title="Status" />
			  <display:column property="date_sent" title="Date" sortable="true" headerClass="sortable"/>
			  <display:column property="time_sent" title="Time" sortable="true" headerClass="sortable" />
			  <display:setProperty name="export.pdf" value="false" />
			</display:table>
			<div align="center"><input type="submit" value="Delete checked messages" class="inputbox" /></div>
			</form>
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
			<a href="/messages/jpage/1/p/messages/content.do?tab=compose&reply=1&repto=<%=drs.getString("from_name")%>&subject=RE:<%=drs.getString("subject")%>&mid=<%=message_id%>">Reply to this message</a>&nbsp;&nbsp;
			<a href="#" onclick="confirmDelete(<%=message_id%>)">Delete this message</a>&nbsp;&nbsp;
			<a href="/messages/jpage/1/p/messages/content.do">Back to inbox</a>

		<%
		}
		}
		%>
		</div> <!-- end of tab 1 -->
        <!-- start of tab 2 -->
		<div class="tabbertab<%if ((request.getParameter("reply") != null) || (theTab.equals("compose"))) {%> tabbertabdefault<%}%>">
		<h2>Compose</h2>
		<%
		String respMsg = "== Begin quoted message ==\n\n";
		if (request.getParameter("repto") != null) {
			to = (String) request.getParameter("repto");
			if (request.getParameter("subject") != null) {
				if (((String) request.getParameter("subject")).length() > 0) {
					subject = request.getParameter("subject");
				} else {
					subject = "";
				}
			} else {
				subject = "";
			}
			GenericTable myRt = new GenericTable("customer_messages");
			XDisconnectedRowSet drs = new XDisconnectedRowSet();
			myRt.setConn(conn);
			myRt.setSSelectWhat("*");
			myRt.setSCustomWhere("and customer_message_id = " + request.getParameter("mid"));
			drs = myRt.getAllRecordsDisconnected();
			while (drs.next()) {
				respMsg += drs.getString("message") + "\n\n== End quoted message ==\n";
			}
			drs.close();
			drs = null;
		}
		%>
		<form name="sendmessage" id="sendmessage" action="/messages/jpage/1/p/messages/content.do" method="post">
		<input type="hidden" name="maction" value="send" />
		<input type="hidden" name="tab" value="inbox" />
		<table style="width: 100%">
		<tr>
		<td colspan="2">
		<div>&nbsp;</div>
		<h2>Compose Message</h2>
		<div>&nbsp;</div>
		</td>
		</tr>
		<tr>
		<td>To:</td>
		<td><input type="text" name="to" id="to" value="<%=to%>" class="form-autocomplete required" size="30"/>
		
		</td>
		</tr>
		<tr>
		<td>
		Subject:
		</td>
		<td>
		<input type="text" id="subject" name="subject" value="<%=subject%>" class="inputbox required" size="30" />
		
		</td>
		</tr>
		<tr>
		<td colspan="2">
		Message
		</td>
		</tr>
		<tr>
		<td colspan="2">
		<textarea class="inputbox required" style="width: 98%; height: 250px" name="themessage"><%=mes%><%=respMsg.replaceAll("<br />", "\n")%></textarea>
		</td>
		</tr>
		</table>
		<br />Spam filter:<br /><img src="/Captcha.jpg"><br />
        Enter the letters you see above: <input type="text" name="j_captcha_response" class="inputbox required" size="10" id="j_captcha_response" />
		<span id="j_captcha_response-error" class="error"></span>
		<br />
		<input type="submit" value="Send message" class="inputbox" />
		</form>
		
		<ajax:autocomplete
			  source="to"
			  target="to"
			  baseUrl="/AutoComplete.jsr?ai=1"
			  className="autocomplete"
			  parameters="searchname={to},table=customer,field=username"
			  progressStyle="throbbing"
			  minimumCharacters="1" />
		</div> <!-- end of tab 2 -->
        <!-- start of tab 3 -->
		<div class="tabbertab<%if (message_sent_id > 0) {%> tabbertabdefault<%}%>">
		<h2>Sent</h2>
		<%
		if (message_sent_id == 0) {%>
		
		<form action="/deletesent.jsp" method="post">
		<display:table name="requestScope.results_sent.rows" requestURI="/messages/jpage/1/p/messages/content.do" export="false" defaultsort="4" id="msgTableSent" pagesize="10"  class="tabledatacollapse" defaultorder="descending" style="width: 100%" >
			 <display:column property="checkbox" title="" />
			 <display:column property="subject" title="Subject" href="/messages/jpage/1/p/messages/content.do" paramId="message_sent_id" paramProperty="customer_message_sent_id" sortable="true" headerClass="sortable" />
			  <display:column property="to_name" title="To" sortable="true" headerClass="sortable" />
			  <display:column property="date_sent" title="Date" sortable="true" headerClass="sortable"/>
			  <display:column property="time_sent" title="Time" sortable="true" headerClass="sortable" />
			  <display:setProperty name="export.pdf" value="false" />
			</display:table>
			<div align="center"><input type="submit" value="Delete checked messages" class="inputbox" /></div>
		</form>
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
			<h2 style="color: black;">Message</h2>
			<div>&nbsp;</div>
			<%=drs.getString("message")%>
			<div>&nbsp;</div>
		<br />
		<a href="#" onclick="confirmDeleteSent(<%=message_sent_id%>)">Delete this message</a>&nbsp;&nbsp;
		<a href="/messages/jpage/1/p/messages/content.do?viewsent=1">Back to sent messages</a>
		<%
		}
		}
		%>
		</div> <!-- end of tab 3 -->
    </div>					
<!-- end message tabs -->
					</div>

					<div class="yui-u rightcol" style="margin-right: 4px;"><!-- rightmost -->
						<v:moduletag conn="<%=conn%>" position="1" />
						<v:banner position_id="2" conn="<%=conn%>" numberOfBanners="1" /><br>
						<v:banner position_id="11" conn="<%=conn%>" numberOfBanners="1" />
						<br />
						<br />
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
				<v:banner position_id="10" conn="<%=conn%>" numberOfBanners="1" />
				<br />
				<v:mainmenutag conn="<%=conn%>" menutag="Messages Menu" />
				<v:banner position_id="9" conn="<%=conn%>" numberOfBanners="1" />
				<v:moduletag conn="<%=conn%>" position="2" />
		</div>
	</div>
	<div id="ft" class="bottom">
		<div id="copyrightmenu"><v:mainmenutag conn="<%=conn%>" menutag="Copyright" /></div>
	</div>
	<div class="bottombanner"><v:banner position_id="4" conn="<%=conn%>" /></div>
	<%
	int this_year = Calendar.getInstance().get(Calendar.YEAR);
	%>
	<div style="text-align: center; font-size: 80%">Site content and design &copy; 2000-<%=this_year%> Pacemaker Club Inc. <br />All rights reserved.</div>
</div>
</body>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-15057244-1");
pageTracker._trackPageview();
} catch(err) {}</script>
</html>
<%@include file="/footer.jsp" %>
