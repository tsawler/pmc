<%
int k = 1;
%>
<div id="masterdiv">
<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Members</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/customer/jpage/1/p/SearchCustomers/admin/1/content.do">Maintain members</a><br />
<!--
- <a href="/admin/jpage/1/p/AddCustomer/a/addcustomer/admin/1/content.do">New member</a><br />
-->
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Member Communication</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/createmessage/jpage/1/p/createmessage/admin/1/content.do">Create & send message</a><br />
- <a href="/viewqueue/jpage/1/p/viewqueue/admin/1/content.do">View message queue</a><br />
- <a href="/aemail/jpage/1/p/AutoEmail/admin/1/content.do">Maintain auto email messages</a><br />
- <a href="/feedbackchoose/jpage/1/p/Feedback/admin/1/content.do">Member feedback responses</a><br />
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Messages</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/stories/jpage/1/p/searchstories/admin/1/content.do">Maintain messages</a><br />
- <a href="/admin/jpage/1/p/DisplayStory/a/displaystory/admin/1/content.do?cancelPage=/stories/jpage/1/p/searchstories/admin/1/content.do&id=0&edit=false">New message</a><br />
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Comments</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/comments/jpage/1/p/comments/admin/1/content.do">Maintain comments</a><br />
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Banners</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/banners/jpage/1/p/MaintainBanners/admin/1/content.do">Maintain banners</a><br />
- <a href="/admin/jpage/1/p/EditBanner/a/editbanner/admin/1/content.do?cancelPage=/banners/jpage/1/p/MaintainBanners/admin/1/content.do&id=0&edit=false">Add banner</a><br />
- <a href="/bannerreports/jpage/1/p/bannerreports/admin/1/content.do">Banner Reports</a><br />
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">News</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/news/jpage/1/p/NewsItemChoice/admin/1/content.do">Maintain news items</a><br />
- <a href="/admin/jpage/1/p/NewsItemDetail/a/newsitemdetail/admin/1/content.do?id=-1&amp;edit=false&amp;cancelPage=/news/jpage/1/p/NewsItemChoice/a/newsitemchoice/admin/1/content.do">Add news item</a><br />
- <a href="/admin/jpage/1/p/NewsCategoriesChoice/a/newscategorieschoice/class/newscategories/clear/1/admin/1/content.do">Maintain news categories</a><br />
- <a href="/admin/jpage/1/p/NewsCategoriesDetail/a/newscategorydetail/admin/1/content.do?id=-1&amp;edit=false&amp;cancelPage=/admin/jpage/1/p/NewsCategoriesChoice/a/newscategorieschoice/class/newscategories/clear/1/admin/1/content.do">New category</a><br />
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Pages</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/pages/jpage/1/p/EditPageChoose/admin/1/content.do">Maintain pages</a><br />
- <a href="/admin/jpage/1/p/EditPage/a/editpage/language_id/1/admin/1/content.do?id=-1&amp;edit=false&amp;cancelPage=/pages/jpage/1/p/EditPageChoose/class/page/admin/1/content.do">Add page</a><br />
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Menus</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/menu/jpage/1/p/MenuChoose/class/menu/admin/1/content.do">Maintain menus</a><br />
</span>
<%
k++;
%>
<!--
<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Templates</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/templates/jpage/1/p/JspTemplateBrowse/admin/1/content.do">Maintain Templates</a><br />
- <a href="/admin/jpage/1/p/EditJspTemplate/a/editjsptemplate/class/jsptemmplate/admin/1/content.do?cancelPage=/templates/jpage/1/p/JspTemplateBrowse/admin/1/content.do&id=0&edit=false">Add JSP template</a><br />
</span>
<%
//k++;
%>
-->

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Galleries</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/gallerychoose/jpage/1/p/gallery/admin/1/content.do">Maintain galleries</a><br />
<!--
- New gallery<br />
-->
- <a href="/galleryadd/jpage/1/p/gallery/admin/1/content.do?id=0">Add image to gallery</a><br />
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Components</div>
<span class="submenu" id="sub<%=k%>">
&nbsp;&nbsp;<strong>FAQ</strong><br />
- <a href="/faq/jpage/1/p/FaqChoose/admin/1/content.do">Maintain FAQ entries</a><br />
- <a href="/admin/jpage/1/p/EditFaqEntry/a/editfaqentry/class/faq/admin/1/content.do?cancelPage=/faq/jpage/1/p/FaqChoose/admin/1/content.do&id=0&edit=false">New FAQ entry</a><br />
- <a href="/faqcategories/jpage/1/p/FaqChooseCategory/admin/1/content.do">Maintain FAQ categories</a><br />
- <a href="/admin/jpage/1/p/EditFaqCategory/a/editfaqcategory/class/faqcat/admin/1/content.do?cancelPage=/faqcategories/jpage/1/p/FaqChooseCategory/admin/1/content.do&id=0&edit=false">New FAQ category</a><br />
&nbsp;&nbsp;<strong>Web Links</strong><br />
- <a href="/linkscategories/jpage/1/p/LinkCategory/admin/1/content.do">Maintain Web Links categories</a><br />
- <a href="/admin/jpage/1/p/EditWebLinksCat/a/editweblinkscategories/class/linkcat/admin/1/content.do?cancelPage=/linkscategories/jpage/1/p/LinkCategory/admin/1/content.do&id=0&edit=false">New Web Links category</a><br />
- <a href="/linkschoose/jpage/1/p/LinksChoose/admin/1/content.do">Maintain Web links</a><br />
- <a href="/admin/jpage/1/p/EditLinks/a/editlinks/class/links/admin/1/content.do?id=0&edit=false&cancelPage=/linkschoose/jpage/1/p/LinksChoose/admin/1/content.do">New web link</a><br />
&nbsp;&nbsp;<strong>Polls</strong><br />
- <a href="/pollschoose/jpage/1/p/PollsChoose/admin/1/content.do">Maintain Polls</a><br />
- <a href="/admin/jpage/1/p/EditPoll/a/editpoll/class/polls/admin/1/content.do?id=0&edit=false&cancelPage=/pollschoose/jpage/1/p/PollsChoose/admin/1/content.do">New poll</a><br />
&nbsp;&nbsp;<strong>Quotes</strong><br />
- <a href="/quoteschoose/jpage/1/p/QuotesChoose/admin/1/content.do">Maintain Quotes</a><br />
- <a href="/admin/jpage/1/p/EditQuote/a/editquote/class/quotes/admin/1/content.do?id=0&edit=false&cancelPage=/quoteschoose/jpage/1/p/QuotesChoose/admin/1/content.do">New quote</a><br />
- <a href="/memberquoteschoose/jpage/1/p/QuotesChoose/admin/1/content.do">Maintain Member Quotes</a><br />
- <a href="/admin/jpage/1/p/EditMemberQuote/a/editmemberquote/class/quotes/admin/1/content.do?id=0&edit=false&cancelPage=/memberquoteschoose/jpage/1/p/QuotesChoose/admin/1/content.do">New member quote</a><br />
</span>
<%
k++;
%>

<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">Modules</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/moduleschoose/jpage/1/p/ModulesChoose/admin/1/content.do">Maintain modules</a><br />
<!--
- <a href="/admin/jpage/1/p/ModuleAdd/admin/1/content.do">New module</a><br />
-->
</span>
<%
k++;
%>


<div class="menutitle" onClick="SwitchMenu('sub<%=k%>')">User Admin</div>
<span class="submenu" id="sub<%=k%>">
- <a href="/users/jpage/1/p/UsersChoose/admin/1/content.do">Maintain users</a><br />
- <a href="/admin/jpage/1/p/RolesChoose/a/roleschoose/class/roles/clear/1/admin/1/content.do?filter=1">Maintain roles</a><br />
- <a href="/admin/jpage/1/p/RoleEdit/a/roleedit/admin/1/content.do?cancelPage=/admin/jpage/1/p/RolesChoose/a/roleschoose/class/roles/admin/1/content.do&amp;id=-1&amp;edit=false">New role</a><br />
</span>
<%
k++;
%>

<br />
<a href="/">To public site</a>
<br /><br />
<a href="/admin/logout.jsp">Logout</a>
</div>