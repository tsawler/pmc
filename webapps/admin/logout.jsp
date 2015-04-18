<%
session.removeAttribute("loginError");
session.removeAttribute("loginErrorMessage"); 
session.removeAttribute("userAdminId");
session.removeAttribute("userAdminName");
response.sendRedirect("/admin/index.jsp");          
%>
