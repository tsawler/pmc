<%@page language="java" import="com.verilion.database.*, java.sql.*,java.util.*,java.text.DecimalFormat,
org.sourceforge.jxutil.sql.XDisconnectedRowSet, com.verilion.display.HTMLTemplateDb,
java.lang.reflect.Method, com.verilion.database.SingletonObjects,com.verilion.utility.*,com.oreilly.servlet.MultipartRequest,
java.io.*"%>
<%
HTMLTemplateDb MasterTemplate;
String theError = "";
boolean redirect = false;
int myLanguageId = 1;
Connection conn = null;
String page_detail_contents = "";
int page_access_level = 0;
String page_detail_title = "";
int page_id = 0;
int template_id = 0;
String page_active_yn = "";
String secure_page_yn = "";
session = request.getSession();
HashMap hm = null;
String sPageName = "";
String sDate = "";
String sAction = "";
long lPageGenTime = 0;
long lPageGenTimeEnd = 0;
boolean okay = false;

lPageGenTime = System.currentTimeMillis();

try {
	// get our hashmap from session; if it's not there,
	// we shouldn't even be here.
	try {
			hm = (HashMap) session.getAttribute("pHm");
			sPageName = (String) hm.get("p");
	} catch (Exception e) {
			theError = "The requested page cannot be accessed directly";
			redirect = true;
	}
	
	// make sure they are logged in
	try {
		int myId = Integer.parseInt((String)session.getAttribute("userAdminId"));
	} catch (Exception e) {
			theError = "You must log in before accessing the requested page";
			redirect = true;
	}
	
	// Get a database connection
	try {
			conn = DbBean.getDbConnection();
	 } catch (Exception e2) {
			e2.printStackTrace();
			theError = "Unable to connect to database.";
			redirect = true;
	 }
		
	// just to be sure, make certain that our referer includes "content.do"
	/*
	try {
			if (request.getHeader("referer") != null) {
					if (request.getHeader("referer").indexOf("content.do") < 0) {
							theError = "The requested page cannot be accessed directly.";
							redirect = true;
					}
			}
	} catch (Exception e) {
			theError = "The requested page cannot be accessed directly";
			redirect = true;
	}
	*/
	// get our last page
	String lastPage = (String) request.getHeader("referer");
	session.setAttribute("lastPage", lastPage);
	
	// if our hashmap has an entry for "a", we have a custom page
	// processing action of some sort
	try {
			sAction = (String)hm.get("a");
	} catch (Exception e) {
			sAction = "";
	}
	
	if (!redirect) {
			// generate date
			java.util.Date today = new java.util.Date();
			sDate = today.toString();
	
			AdminPageRoutines myPage = new AdminPageRoutines();
			myPage.setConn(conn);
			myPage.setPage_name(sPageName);
	
			try {
					if (myPage.isValidPageName()) {
					  myPage.setConn(conn);
					  myPage.setPage_name(sPageName);
					  myPage.setCt_language_id(myLanguageId);
	
					  try {
							myPage.PageInfoByPageName();
					  } catch (SQLException e1) {
							e1.printStackTrace();
							theError = "Invalid request " + e1.toString();
							redirect = true;
					  } catch (Exception e1) {
							e1.printStackTrace();
							theError = "Invalid request " + e1.toString();
							redirect = true;
					  }
	
					  page_id = myPage.getPage_id();
					  template_id = myPage.getTemplate_id();
					  page_access_level = myPage.getPage_access_level();
					  page_detail_contents = myPage.getPage_detail_contents();
					  page_detail_title = myPage.getPage_detail_title();
					  page_active_yn = myPage.getPage_active_yn();
					  
					  // make sure they have a role that permits them to see this page
					int[] roles = new int[10];
					
					try {
						Role myRole = new Role();
						myRole.setConn(conn);
						String[] sRoles = (String[]) session.getAttribute("roles");
						okay = false;
						
						for (int i = 0; i < sRoles.length; i++) {
							int testRoleId = Integer.parseInt(sRoles[i]);
							//System.out.println("checking role id " + sRoles[i] + " against page id " + page_id);
							if (myRole.CheckPageForRole(page_id, testRoleId)) {
								okay = true;
								break;
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					//okay = true;

					//okay = true;
					if (okay) {
						if (sAction != null) {
							if (sAction.length() > 0) {
								MasterTemplate = new HTMLTemplateDb("$BODY$ <!--ResultsTable-->");
								MasterTemplate.searchReplace("$BODY$", page_detail_contents);
								try {
									String className = ((String) (SingletonObjects.getInstance().getHmClassMap()).get(sAction));
									//System.out.println("Class: " + className);
									Class myClass = null;
									Class c = Class.forName(className);
									Object instance = c.newInstance();
									Method m = c.getMethod("ChooseAction", new Class[] {
									HttpServletRequest.class, HttpServletResponse.class,
									HttpSession.class, Connection.class,
									HTMLTemplateDb.class, HashMap.class });
									m.invoke(instance, new Object[] { request, response, session,
									conn, MasterTemplate, hm });
									page_detail_contents = MasterTemplate.getSb().toString();
								} catch (Exception e) {
									e.printStackTrace();
								}
							}
						} 
					} else {
						//System.out.println("Does not have access to this page!");
						//theError += "You do not have access to the requested page.";
						session.setAttribute("Error", "You do not have access to the requested page");
						response.sendRedirect("/admin/jpage/1/p/Welcome/admin/1/content.do");
						return;
					}
				} else {
					//System.out.println("Invalid page requested!");
					//theError = "Invalid page requested!";
					session.setAttribute("Error", "You do not have access to the requested page");
					response.sendRedirect("/admin/jpage/1/p/Welcome/admin/1/content.do");
					return;
				}
			} catch (SQLException e) {
			   e.printStackTrace();
			} catch (Exception e) {
			   e.printStackTrace();
			}
	} else {
	  session.setAttribute("Error", theError);
	  response.sendRedirect("/public/jpage/1/p/Home/content.do");
	  return;
	}
	response.setHeader("P3P", "CP=\"CAO DSP COR CURa ADMa DEVa OUR IND PHY ONL UNI COM NAV INT DEM PRE\"");
%>

