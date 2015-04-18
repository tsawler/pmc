<%@page language="java" import="com.verilion.database.*, java.sql.*,java.util.*,java.text.*,
org.sourceforge.jxutil.sql.XDisconnectedRowSet, com.verilion.display.HTMLTemplateDb,
java.lang.reflect.Method, com.verilion.utility.*,com.oreilly.servlet.MultipartRequest,
java.io.*, javax.imageio.ImageIO, java.awt.image.BufferedImage"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<%
HTMLTemplateDb MasterTemplate;
String theError = "";
boolean redirect = false;
int myLanguageId = 1;
Connection conn = null;
String page_detail_contents = "";
int page_access_level = 0;
int customer_access_level = 0;
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
int customer_id = 0;
String sJavaScript = "";
String browser_title = "";
String meta_tags = "";

try {
if (session.getAttribute("customer_id") != null) {
	customer_id = Integer.parseInt((String) session.getAttribute("customer_id"));
	customer_access_level = Integer.parseInt((String) session.getAttribute("customer_access_level"));
}

lPageGenTime = System.currentTimeMillis();

// get our hashmap from session; if it's not there,
// we shouldn't even be here.
try {
	try {
		hm = (HashMap) session.getAttribute("pHm");
		sPageName = (String) hm.get("p");
	} catch (Exception e) {
		theError = "The requested page cannot be accessed directly";
		redirect = true;
	}
	
	// just to be sure, make certain that our referer includes "content.do"
	/*try {
		if (request.getHeader("referer") != null) {
			if (request.getHeader("referer").indexOf("content.do") < 0) {
				theError = "The requested page cannot be accessed directly.";
				System.out.println("setting to true on 42");
				redirect = true;
			}
		}
	} catch (Exception e) {
		theError = "The requested page cannot be accessed directly";
		System.out.println("setting to true on 48");
		redirect = true;
	}
	*/
	
	// if our hashmap has an entry for "a", we have a custom page
	// processing action of some sort
	try {
		sAction = (String)hm.get("a");
	} catch (Exception e) {
		sAction = "";
	}
	
	// Get a database connection
	try {
		conn = DbBean.getDbConnection();
	 } catch (Exception e2) {
		e2.printStackTrace();
		theError = "Unable to connect to database.";
		redirect = true;
	 }

	if (!redirect) {
		// generate date
		java.util.Date today = new java.util.Date();
		sDate = today.toString();
		
		PageRoutines myPage = new PageRoutines();
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
		   theError = "Invalid request" + e1.toString();
		   redirect = true;
			  } catch (Exception e1) {
		   e1.printStackTrace();
		   theError = "Invalid request" + e1.toString();
		   redirect = true;
			  }
			
			  page_id = myPage.getPage_id();
			  template_id = myPage.getTemplate_id();
			  page_access_level = myPage.getPage_access_level();
			  page_detail_contents = myPage.getPage_detail_contents();
			  page_detail_title = myPage.getPage_detail_title();
			  page_active_yn = myPage.getPage_active_yn();
			  secure_page_yn = myPage.getSecure_page_yn();
			  browser_title = myPage.getBrowser_title();
			  meta_tags = myPage.getMeta_tags();
			  
			  if (sPageName.equals("story")) {
			  	// it's a story page. Check get meta tags
				GenericTable myGts = new GenericTable("pmc_stories");
				myGts.setConn(conn);
				myGts.setSSelectWhat("browser_title, meta_tags");
				myGts.setSCustomWhere(" and story_id = " + hm.get("sid"));
				XDisconnectedRowSet sdrs = new XDisconnectedRowSet();
				sdrs = myGts.getAllRecordsDisconnected();
				while (sdrs.next()) {
					String browser_title_tmp = "";
					String meta_tags_tmp = "";
					browser_title_tmp = sdrs.getString("browser_title");
					meta_tags_tmp = sdrs.getString("meta_tags");
					if (browser_title_tmp.length() > 0) {
						browser_title = browser_title_tmp;
					}
					if (meta_tags_tmp.length() > 0) {
						meta_tags = meta_tags_tmp;
					} 
				}
				sdrs.close();
				sdrs = null;
			  }
			  
			  if (sPageName.equals("News")) {
			  	// it's a story page. Check get meta tags
				GenericTable myGts = new GenericTable("news");
				myGts.setConn(conn);
				myGts.setSSelectWhat("browser_title, meta_tags");
				myGts.setSCustomWhere(" and news_id = " + hm.get("id"));
				XDisconnectedRowSet sdrs = new XDisconnectedRowSet();
				sdrs = myGts.getAllRecordsDisconnected();
				while (sdrs.next()) {
					String browser_title_tmp = "";
					String meta_tags_tmp = "";
					browser_title_tmp = sdrs.getString("browser_title");
					meta_tags_tmp = sdrs.getString("meta_tags");
					if (browser_title_tmp.length() > 0) {
						browser_title = browser_title_tmp;
					}
					if (meta_tags_tmp.length() > 0) {
						meta_tags = meta_tags_tmp;
					} 
				}
				sdrs.close();
				sdrs = null;
			  }
			  
			  // generate javascript
			  JspTemplateMenu mJTM = new JspTemplateMenu();
			  mJTM.setConn(conn);
			  XDisconnectedRowSet jrs = new XDisconnectedRowSet();
			  jrs = mJTM.getMenusForTemplateName((String)(hm.get("page_name")));
			  sJavaScript = "<!-- auto generated javascript -->\n<script type=\"text/javascript\">\n";
			  int i = 0;
			  String cfgString = "";
			  String renderString = "";
			  String subscribeString = "";
			  String renderMenuString = "";
			  String initializeMenuString = "";
			  boolean wroteHeader = false;
			  boolean justHeading = false;
			  
			  while (jrs.next()) {
			  	if (jrs.getInt("ct_menu_type_id") == 3) {
					Menu myMenu = new Menu();
					myMenu.setMenu_id(jrs.getInt("menu_id"));
					myMenu.setConn(conn);
					myMenu.setCt_language_id(1);
					XDisconnectedRowSet mrs = new XDisconnectedRowSet();
					mrs = myMenu.getMenuForDisplay();
					
					if (mrs.next()) {
						if (!wroteHeader) {
							sJavaScript += "YAHOO.example.onMenuReady = function(p_oEvent) {\n";
							wroteHeader = true;
						}
						
						sJavaScript += "function onMenuBeforeRender"
							+ jrs.getInt("menu_id")
							+ "(p_sType, p_sArgs, p_oMenu) {\n\n"
							+ "var oSubmenuData"
							+ jrs.getInt("menu_id")
							+ " = {\n";
						mrs.previous();
					}
					
					renderString += "var oMenu"
						+ jrs.getInt("menu_id")
						+ " = new YAHOO.widget.Menu(\n"
						+ "\"leftpopmenu"
						+ jrs.getInt("menu_id")
						+ "\",\n"
						+ "{\n"
						+ "width: \"123px\",\n"
						+ "position: \"static\",\n"
						+ "showdelay:250,\n"
						+ "hidedelay:750,\n"
						+ "lazyload:true,\n"
						+ "effect:{\n"
						+ "  effect:YAHOO.widget.ContainerEffect.FADE,\n"
						+ "  duration:0.25\n"
						+ "}\n"
						+ "}\n"
						+ ");\n";
						
					subscribeString += "oMenu"
						+ jrs.getInt("menu_id")
						+ ".beforeRenderEvent.subscribe(onMenuBeforeRender"
						+ jrs.getInt("menu_id")
						+ ", oMenu"
						+ jrs.getInt("menu_id")
						+ ", true);\n";
						
					renderMenuString += "oMenu"
						+ jrs.getInt("menu_id")
						+ ".render();\n";
						
					initializeMenuString += "YAHOO.util.Event.onContentReady(\""
					+ "leftpopmenu"
					+ jrs.getInt("menu_id")
					+ "\", YAHOO.example.onMenuReady);\n";

					while (mrs.next()) {
						int ct_access_level_id = mrs.getInt("ct_access_level_id");
						if ((mrs.getString("menu_item_is_heading")).equalsIgnoreCase("y")) {
							if (mrs.next()) {
								if ((mrs.getString("menu_item_is_heading")).equalsIgnoreCase("n")) {
									mrs.previous();
									sJavaScript += "\"" + mrs.getString("menu_item_detail_name") + "\": [\n";
									cfgString += "this.getItem("
										+ i
										+ ").cfg.setProperty(\"submenu\", { id:\""
										+ mrs.getString("menu_item_detail_name")
										+ "\", itemdata: oSubmenuData"
										+ jrs.getInt("menu_id")
										+ "[\""
										+ mrs.getString("menu_item_detail_name")
										+ "\"] });\n";
								} else {
									mrs.previous();
									i++;
									justHeading = true;
								}
							}
						} else if ((mrs.getString("menu_item_is_spacer")).equalsIgnoreCase("y")) {
							
						} else if (ct_access_level_id <= customer_access_level) {
							if ((mrs.getInt("page_id") == 0) && (mrs.getInt("component_id") == 0)) {
								sJavaScript += "{ text: \"" 
									+ mrs.getString("menu_item_detail_name") 
									+ "\", url: \""
									+ mrs.getString("menu_item_action")
									+ "\" },\n";
							} else if ((mrs.getInt("page_id") > 0) && (mrs.getInt("component_id") ==0)) {
								PageTemplate myPageTemplate = new PageTemplate();
         						myPageTemplate.setConn(conn);
								myPageTemplate.setPage_id(mrs.getInt("page_id"));
								sJavaScript += "{ text: \"" 
									+ mrs.getString("menu_item_detail_name") 
									+ "\", url: \""
									+ myPageTemplate.getInvocationAsString()
									+ "\" },\n";
							} else if ((mrs.getInt("page_id") == 0) && (mrs.getInt("component_id") > 0)) {
								String theName = mrs.getString("component_name");
								String theUrl = mrs.getString("component_url");
								String theUrlExtra = mrs.getString("component_url_extra");
								if (theUrlExtra == null )
									theUrlExtra = "";
								String finalUrl = theUrl + " " + theUrlExtra;
							 	sJavaScript += "{ text: \"" 
									+ theName
									+ "\", url: \""
									+ finalUrl
									+ "\" },\n";
                 			}

							if (mrs.next()) {
								if ((mrs.getString("menu_item_is_heading").equalsIgnoreCase("y"))
									&& (!justHeading)) {
									mrs.previous();
									sJavaScript = sJavaScript.substring(0, (sJavaScript.length() - 2));
									sJavaScript += "\n],\n";
									i++;
								} else {
									mrs.previous();
									justHeading = false;
								}
							} else {
								sJavaScript = sJavaScript.substring(0, (sJavaScript.length() - 2));
								sJavaScript += "\n]\n};\n";
								sJavaScript += cfgString + "\n}\n";
								cfgString = "";
							}
						}
					}
				}
			  	
			  }
			  sJavaScript +=  renderString + subscribeString + renderMenuString;
			  if (renderMenuString.length() > 0) {
			  	sJavaScript += "\n}\n";
			  }
			  sJavaScript += initializeMenuString;
			  
			  sJavaScript += "</script>\n<!-- end of generated javascript-->";
			  
			  if (sAction != null) {
				if (sAction.length() > 0) {
					MasterTemplate = new HTMLTemplateDb("$BODY$ <!--ResultsTable-->");
					MasterTemplate.searchReplace("$BODY$", page_detail_contents);
					  try {
					  String className = ((String) (SingletonObjects.getInstance()
							.getHmClassMap()).get(sAction));
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
				
				   }
			   }
		   }
			} else {
			theError = "Invalid page requested!";
			redirect = true;
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
	// send privacy header
	response.setHeader("P3P", "CP=\"CAO DSP COR CURa ADMa DEVa OUR IND PHY ONL UNI COM NAV INT DEM PRE\"");
	
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
