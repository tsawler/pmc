<%@include file="/PageSecurity.jsp"%>
<%
String username = "";
if (session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
} else {
        username = "guest";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Pacemaker Club - Chat</title>
<script type="text/javascript" src="/js/mt.js"></script>
<script type='text/javascript' src='/js/ajax/engine.js'> </script>
<script type='text/javascript' src='/js/ajax/Chat.js'> </script>
<script type='text/javascript' src='/js/ajax/util.js'> </script>


<script type="text/javascript">
window.addEvent('domready', function(){
        /* DomReady Event fires when all Elements are ready, but not images. */
        window.addEvent('domready', function() {
                init();
        });
});

function sendMessage() {
  Chat.addMessage("<%=username%>" + ": " + dwr.util.getValue("text"));
}
</script>

<link rel="stylesheet" href="/pmc.css" type="text/css" />
<style type="text/css">
#chatlog{
border:none; padding:5px; height: 330px; overflow: auto; text-align: left;
        color:#b30000;
        text-decoration:none;
        font-family:Verdana, Arial, Helvetica, sans-serif;
        font-size:11px;
        margin-left: 5px;
        padding-left: 0;
}
#userlist{
border:none; padding:5px; height: 330px; overflow: auto; text-align: left;
        color:#b30000;
        text-decoration:none;
        font-family:Verdana, Arial, Helvetica, sans-serif;
        font-size:11px;
        margin-left: 5px;
        padding-left: 0;
}
.ctable, .ctable td {
        border:solid #b30000 1px;
        border-collapse:collapse;
}
.chatbox {
        font-family:Verdana, Arial, Helvetica, sans-serif;
        font-size:11px;
        font-weight:normal;
        color:#333333;
        background:white;
        border:1px solid #b30000;
}
</style>
<style>
.old { background: #FEFEFE; }
.new { background: #FFFFE0; }
</style>
<script type="text/javascript" src="/js/jquery-1.2.6.min.js"></script>

<script type="text/javascript">
var t;
function getTimeFromAjax(){
 t = $.ajax({
  url: "gettime.jsp",
  async: false
 }).responseText;
 return t;
}
 </script>
<script type="text/javascript">

var needToConfirm = true;

function init(){
	dwr.engine.setActiveReverseAjax(true);
	var rightnow = getTimeFromAjax();
	
	Chat.addUser('<%=username%>', processResponse());
	Chat.initSession();
	Chat.addMessage("[ <%=username%>" + " entered the chat room on " + rightnow + " ]");
}
function endChat(){
        Chat.removeUser('<%=username%>');
		 Chat.addMessage("[<%=username%>" + " left the chat room at " + getTimeFromAjax() + "]");
}
function processResponse() {

}

window.onbeforeunload = confirmExit;

function doUnload() {
 if (window.event.clientX < 0 && window.event.clientY < 0) {
	 if (needToConfirm) {
		var rightnow = getTimeFromAjax();
		Chat.addMessage("[ <%=username%>" + " left the chat room on " + rightnow + " ]", processResponse());
		Chat.removeUser('<%=username%>', processResponse());
	 }
 }
}

function confirmExit()
  {
  if (needToConfirm) 
    return "You are trying to close the window without logging out. You will appear to to be in chat even though you are not. Please cancel this, and use the 'log out of chat' button instead";
  }

function killChat() {
	needToConfirm = false;
	var rightnow = getTimeFromAjax();
	Chat.addMessage("[ <%=username%>" + " left the chat room on " + rightnow + " ]", processResponse());
	//Chat.removeUser('<%=username%>', processResponse());
	Chat.removeUser("<%=username%>", function() { location.href = "http://www.pacemakerclub.com/public/jpage/1/p/Home/content.do"; })
}

</script>
</head>

<body onunload="doUnload()">

<div id="content" style="border: none;">
<table style="width: 100%" class="ctable">
		<tr>
			<td colspan="2">
			<img src="/images/pmclogochat.gif" height="60" width="204" alt="logo" />
			</td>
		</tr>
        <tr>
                <td style="width: 80%;">
                        Chat log
                </td>
                <td style="width: 20%;">
                        Who's online
                </td>
        </tr>
        <tr>
                <td style="width: 80%;">
                        <ul id="chatlog" style="list-style-type:none;"></ul>
                </td>
                <td style="width: 20%;">
                        <ul id="userlist" style="list-style-type:none;"></ul>
                </td>
        </tr>
</table>
<p><br />
    <br />
  Your Message:<br />
  <input id="text" class="chatbox" maxsize="255" style="width: 70%;" onkeypress="dwr.util.onReturn(event, sendMessage)"/>
  <input type="button" value="Send Message" class="chatbox" onclick="sendMessage()"/><br /><br />
  <input type="button" onclick="killChat()" value="Logout of Chat"/>
</p>
<p>Informal daily chat times are 10:00 and 22:00 AST.  Members are encouraged to meet at these times or use the Shoutbox to co-ordinate impromptu chats with others who are online.</p>
<script>
document.write("It is currently " + Date()+".")
</script>
</div>
<%
if (((String)session.getAttribute("customer_access_level")).equalsIgnoreCase("3")) {
%>
Remove user: <input type="text" name="theuser" id="theuser" size="20" />&nbsp;<input type="button" value="Remove user" onclick="javascript:Chat.removeUser((document.getElementById('theuser')).value)" />
<%
}
%>

</body>
</html>
<%@include file="/footer.jsp" %>
