//------------------------------------------------------------------------------
//Copyright (c) 2004-2007 Verilion Inc.
//------------------------------------------------------------------------------
//Created on 2007-03-14
//Revisions
//------------------------------------------------------------------------------
//$Log: ProcessClientAdminPMC.java,v $
//Revision 1.1.2.1  2009/07/22 16:27:27  tcs
//*** empty log message ***
//
//Revision 1.1  2007/03/18 00:24:21  tcs
//Intial entry
//
//------------------------------------------------------------------------------
package com.pmc.html.process;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.sourceforge.jxutil.sql.XDisconnectedRowSet;

import com.oreilly.servlet.MultipartRequest;
import com.verilion.database.CtCountry;
import com.verilion.database.CtProvinceState;
import com.verilion.database.CustomerEmailDetail;
import com.verilion.database.GenericTable;
import com.verilion.database.SingletonObjects;
import com.verilion.display.HTMLTemplateDb;
import com.verilion.display.html.process.ProcessPage;
import com.verilion.object.Errors;
import com.verilion.object.html.HTMLFormDropDownList;
import com.verilion.object.html.Years;
import com.verilion.utility.Thumbnail;

/**
 * Form to update Client Info
 * 
 * @author tsawler
 * @see com.verilion.display.html.Page
 * 
 */
public class ProcessClientAdminPMC extends ProcessPage {

	String first_name = "";
	String last_name = "";
	String email_address = "";
	String password = "";
	String username = "";
	String device_brand = "";
	int implant_year = 0;
	int birth_year = 0;
	int number_of_devices = 0;
	String interests = "";
	String bio = "";
	String occupation = "";
	String city = "";
	int ct_province_state_id = 0;
	int ct_country_id = 0;
	int customer_id = 0;
	String model = "";
	int device_type = 0;
	int customer_add_to_mailing_list = 0;
	String notify_on_pm = "";
	String notify_on_comment = "";

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.verilion.display.html.ProcessPage#BuildPage(javax.servlet.http.
	 * HttpServletRequest, javax.servlet.http.HttpServletResponse,
	 * javax.servlet.http.HttpSession, java.sql.Connection,
	 * com.verilion.display.HTMLTemplateDb, java.util.HashMap)
	 */
	public HTMLTemplateDb BuildPage(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Connection conn,
			HTMLTemplateDb MasterTemplate, HashMap hm) throws Exception {

		ResultSet rs = null;
		String theMenu = "";
		String first_name = "";
		String last_name = "";
		String username = "";
		String email_address = "";
		String password = "";
		String device_brand = "";
		int implant_year = 0;
		int birth_year = 0;
		int number_of_devices = 0;
		String interests = "";
		String bio = "";
		String occupation = "";
		String city = "";
		int ct_province_state_id = 0;
		int ct_country_id = 0;
		String model = "";
		int customer_add_to_mailing_list = 0;
		int device_type = 0;
		String avatar = "";

		int customer_id = 0;
		int year = 0;
		GenericTable myTable = new GenericTable("v_pmc_customer");
		XDisconnectedRowSet drs = new XDisconnectedRowSet();

		try {
			customer_id = Integer.parseInt((String) session
					.getAttribute("customer_id"));
		} catch (Exception e) {
			e.printStackTrace();
			customer_id = 0;
		}
		myTable.setConn(conn);

		try {
			// first get info for this customer
			myTable.setSSelectWhat("*");
			myTable.setSCustomWhere("and customer_id = " + customer_id);
			drs = myTable.getAllRecordsDisconnected();
			while (drs.next()) {
				first_name = drs.getString("customer_first_name");
				last_name = drs.getString("customer_last_name");
				password = drs.getString("customer_password");
				username = drs.getString("username");
				ct_province_state_id = drs.getInt("ct_province_state_id");
				email_address = drs.getString("customer_email");
				device_brand = drs.getString("device_brand");
				implant_year = drs.getInt("implant_year");
				birth_year = drs.getInt("birth_year");
				number_of_devices = drs.getInt("number_of_devices");
				model = drs.getString("model");
				interests = drs.getString("interests");
				bio = drs.getString("bio");
				occupation = drs.getString("occupation");
				city = drs.getString("billing_city");
				ct_country_id = drs.getInt("ct_country_id");
				model = drs.getString("model");
				device_type = drs.getInt("device_type");
				customer_add_to_mailing_list = drs
						.getInt("customer_add_to_mailing_list");
				avatar = drs.getString("avatar");
				notify_on_pm = drs.getString("notify_on_pm");
				notify_on_comment = drs.getString("notify_on_comment");
			}
			drs.close();
			drs = null;

			// do notification options
			if (notify_on_pm.equals("y")) {
				MasterTemplate.searchReplace("$NOTIFYPM$", "checked");
			} else {
				MasterTemplate.searchReplace("$NOTIFYPM$", "");
			}
			if (notify_on_comment.equals("y")) {
				MasterTemplate.searchReplace("$NOTIFYCOMMENT$", "checked");
			} else {
				MasterTemplate.searchReplace("$NOTIFYCOMMENT$", "");
			}

			// do image
			if (avatar.equals("default_avatar.png")) {
				MasterTemplate
						.searchReplace(
								"$IMG$",
								"<img src=\"/avatars/default_avatar.png\""
										+ " height=\"48\" width=\"48\" alt=\"avatar image\" />");
			} else {
				MasterTemplate.searchReplace("$IMG$", "<img src=\"/avatars/"
						+ avatar + "\" alt=\"avatar image\" />");
			}

			// ---------------------------------------------------------------------
			// create drop down list of provinces/states
			// ---------------------------------------------------------------------
			CtProvinceState myProvince = new CtProvinceState();
			myProvince.setConn(conn);
			rs = myProvince.getAllProvinceState();

			theMenu = HTMLFormDropDownList.makeDropDownListSnippet(
					"state_province", ct_province_state_id, rs,
					"ct_province_state_id", "ct_province_state_name", 62,
					"&nbsp;");

			MasterTemplate.searchReplace("$DDLBSP$", theMenu);

			// ---------------------------------------------------------------------
			// create drop down list of countries
			// ---------------------------------------------------------------------
			/*CtCountry myCountry = new CtCountry();
			myCountry.setConn(conn);
			rs = myCountry.getAllCountries();

			theMenu = HTMLFormDropDownList.makeDropDownListSnippet("country",
					ct_country_id, rs, "ct_country_id", "ct_country_name", 215,
					"&nbsp;");

			MasterTemplate.searchReplace("$DDLBC$", theMenu);*/
			
			// ---------------------------------------------------------------------
	         // create drop down list of countries
	         // ---------------------------------------------------------------------
	         GenericTable gt = new GenericTable("ct_country");
	         gt.setConn(conn);
	         gt.setSSelectWhat("ct_country_id, ct_country_name");
	         gt.setSCustomOrder(" order by ct_country_name");
	         XDisconnectedRowSet crs = new XDisconnectedRowSet();
	         crs = gt.getAllRecordsDisconnected();

	         theMenu = HTMLFormDropDownList.makeDropDownListSnippet(
	               "country",
	               ct_country_id,
	               crs,
	               "ct_country_id",
	               "ct_country_name",
	               215,
	               "&nbsp;");

	         MasterTemplate.searchReplace("$DDLBC$", theMenu);

			// ---------------------------------------------------------------------
			// create drop down list years for implant year
			// ---------------------------------------------------------------------
			Calendar cal = Calendar.getInstance();
			year = cal.get(Calendar.YEAR);

			MasterTemplate.searchReplace("$DDLBIY$",
					Years.makeDropDownListYears("implant_year", 0, 1950, year));

			MasterTemplate.searchReplace("$DDLBND$", Years
					.makeDropDownListYears("number_of_devices",
							number_of_devices, 0, 20));

			MasterTemplate.searchReplace("$DDLBBY$",
					Years.makeDropDownListYears("birth_year", 0, 1870, year));

			// add to mailing list menu
			int i = 1;
			theMenu = "<select class=\"inputbox\" name=\"receive_mail\">";
			theMenu += "<option value=\"1\"";
			if (i == customer_add_to_mailing_list)
				theMenu += " selected ";
			theMenu += ">Yes</option>";
			i--;
			theMenu += "<option value=\"0\"";
			if (i == customer_add_to_mailing_list)
				theMenu += " selected ";
			theMenu += ">No</option>";
			theMenu += "</select>";
			MasterTemplate.searchReplace("$DDLBAL$", theMenu);

			// device type menu
			i = 0;
			theMenu = "<select class=\"inputbox\" name=\"device_type\">";
			theMenu += "<option value=\"" + i + "\"";
			if (i == device_type)
				theMenu += " selected ";
			theMenu += ">&nbsp;</option>";
			i++;
			theMenu += "<option value=\"" + i + "\"";
			if (i == device_type)
				theMenu += " selected ";
			theMenu += ">Pacemaker</option>";
			i++;
			theMenu += "<option value=\"" + i + "\"";
			if (i == device_type)
				theMenu += " selected ";
			theMenu += ">Defibrillator</option>";
			i++;
			theMenu += "<option value=\"" + i + "\"";
			if (i == device_type)
				theMenu += " selected ";
			theMenu += ">CRT</option>";
			theMenu += "</select>";

			MasterTemplate.searchReplace("$DDLBDT$", theMenu);

			MasterTemplate.searchReplace("$FIRSTNAME$", first_name);
			MasterTemplate.searchReplace("$LASTNAME$", last_name);
			MasterTemplate.searchReplace("$USERNAME$", username);
			MasterTemplate.searchReplace("$EMAIL$", email_address);
			MasterTemplate.searchReplace("$PASSWORD$", password);
			MasterTemplate.searchReplace("$CITY$", city);
			MasterTemplate.searchReplace("$INTERESTS$", interests);
			MasterTemplate.searchReplace("$OCCUPATION$", occupation);
			MasterTemplate.searchReplace("$BIO$", bio);
			MasterTemplate.searchReplace("$MODEL$", model);

			if (device_brand.startsWith("B")) {
				MasterTemplate.searchReplace(
						"value=\"Boston Scientific/Guidant\">",
						"value=\"Boston Scientific\" selected>");
			} else if (device_brand.startsWith("M")) {
				MasterTemplate.searchReplace("value=\"Medtronic\">",
						"value=\"Medtronic\" selected>");
			} else if (device_brand.startsWith("S")) {
				MasterTemplate.searchReplace("value=\"St. Jude Medical\">",
						"value=\"St. Jude Medical\" selected>");
			} else if (device_brand.startsWith("O")) {
				MasterTemplate.searchReplace("value=\"Other\">",
						"value=\"Other\" selected>");
			} else {
				MasterTemplate.searchReplace("value=\"Unknown\">",
						"value=\"Unknown\" selected>");
			}

		} catch (Exception e) {
			e.printStackTrace();
			Errors.addError("ProcessClientAdminPMC:BuildPage:Exception:"
					+ e.toString());
		} finally {
			if (rs != null) {
				rs.close();
				rs = null;
			}
		}
		return MasterTemplate;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.verilion.display.html.ProcessPage#ProcessForm(javax.servlet.http.
	 * HttpServletRequest, javax.servlet.http.HttpServletResponse,
	 * javax.servlet.http.HttpSession, java.sql.Connection,
	 * com.verilion.display.HTMLTemplateDb, java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	public HTMLTemplateDb ProcessFormMultipart(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Connection conn,
			HTMLTemplateDb MasterTemplate, HashMap hm, MultipartRequest multi)
			throws Exception {

		try {
			customer_id = Integer.parseInt((String) session
					.getAttribute("customer_id"));
		} catch (Exception e) {
			e.printStackTrace();
			customer_id = 0;
		}

		try {
			// get values from calling form
			String tmpString = "";

			customer_add_to_mailing_list = Integer.parseInt((String) multi
					.getParameter("receive_mail"));
			device_type = Integer.parseInt((String) multi
					.getParameter("device_type"));
			first_name = (String) multi.getParameter("first_name");
			last_name = (String) multi.getParameter("last_name");
			email_address = (String) multi.getParameter("email_address");
			username = (String) multi.getParameter("username");
			occupation = (String) multi.getParameter("occupation");
			password = (String) multi.getParameter("customer_password");
			number_of_devices = Integer.parseInt((String) multi
					.getParameter("number_of_devices"));
			tmpString = (String) multi.getParameter("interests");
			interests = tmpString.replaceAll("\\<.*?>", "");
			implant_year = Integer.parseInt((String) multi
					.getParameter("implant_year"));
			birth_year = Integer.parseInt((String) multi
					.getParameter("birth_year"));
			city = (String) multi.getParameter("city");
			ct_province_state_id = Integer.parseInt((String) multi
					.getParameter("state_province"));
			ct_country_id = Integer.parseInt((String) multi
					.getParameter("country"));
			device_brand = (String) multi.getParameter("device_brand");
			tmpString = (String) multi.getParameter("bio");
			bio = tmpString.replaceAll("\\<.*?>", "");
			model = (String) multi.getParameter("model");

			if (multi.getParameter("notify_on_pm") != null) {
				notify_on_pm = "y";
			} else {
				notify_on_pm = "n";
			}

			if (multi.getParameter("notify_on_comment") != null) {
				notify_on_comment = "y";
			} else {
				notify_on_comment = "n";
			}

			boolean isOkay = true;

			// first check to see if the username has changed
			String oldName = "";
			GenericTable uTable = new GenericTable("customer");
			uTable.setConn(conn);
			uTable.setSSelectWhat("username");
			uTable.setSCustomWhere("and customer_id = " + customer_id);
			XDisconnectedRowSet uDrs = new XDisconnectedRowSet();
			uDrs = uTable.getAllRecordsDisconnected();
			while (uDrs.next()) {
				oldName = uDrs.getString("username");
			}
			boolean usernameChanged = false;

			if (username.equals(oldName)) {
				// do nothing - the name has not changed
			} else {
				// see if the chosen username is ok
				int numRecs = 0;
				Statement st = null;
				ResultSet rs = null;

				st = conn.createStatement();
				rs = st.executeQuery("select count(customer_id) from v_pmc_customer where username = '"
						+ username + "'");
				while (rs.next()) {
					numRecs = rs.getInt(1);
				}
				if (numRecs > 0) {
					isOkay = false;

				} else {
					usernameChanged = true;

				}
				rs.close();
				rs = null;
				st.close();
				st = null;
			}

			if (isOkay) {
				GenericTable myTable = new GenericTable();
				myTable.setConn(conn);
				myTable.setUpdateWhat("customer");
				myTable.setSCustomWhere("and customer_id = " + customer_id);
				myTable.addUpdateFieldNameValuePair("customer_first_name",
						first_name, "string");
				myTable.addUpdateFieldNameValuePair("customer_last_name",
						last_name, "string");
				myTable.addUpdateFieldNameValuePair("customer_password",
						password, "string");
				myTable.addUpdateFieldNameValuePair(
						"customer_add_to_mailing_list",
						customer_add_to_mailing_list + "", "int");
				myTable.addSet("notify_on_pm", notify_on_pm, "string");
				myTable.addSet("notify_on_comment", notify_on_comment, "string");
				myTable.addSet("username", username, "string");

				myTable.updateRecord();

				// email address
				GenericTable eTable = new GenericTable();
				eTable.setConn(conn);
				eTable.setUpdateWhat("customer_email_detail");
				eTable.setSCustomWhere("and customer_id = " + customer_id);
				eTable.addSet("customer_email", email_address, "string");
				eTable.updateRecord();

				// enter address info. 2 entries for everyone
				myTable.clearUpdateVectors();
				myTable.setUpdateWhat("customer_address_detail");
				myTable.setSCustomWhere("and customer_id = " + customer_id);
				myTable.addUpdateFieldNameValuePair("ct_province_state_id",
						ct_province_state_id + "", "int");
				myTable.addUpdateFieldNameValuePair("ct_country_id",
						ct_country_id + "", "int");
				myTable.addUpdateFieldNameValuePair("customer_town_city", city,
						"string");
				myTable.updateRecord();

				// final info
				myTable.clearUpdateVectors();
				myTable.setUpdateWhat("pmc_customer_extra");
				myTable.setSCustomWhere("and customer_id = " + customer_id);
				myTable.addUpdateFieldNameValuePair("occupation", occupation,
						"String");
				myTable.addUpdateFieldNameValuePair("number_of_devices",
						number_of_devices + "", "int");
				myTable.addUpdateFieldNameValuePair("interests", interests,
						"String");
				myTable.addUpdateFieldNameValuePair("implant_year",
						implant_year + "", "int");
				myTable.addUpdateFieldNameValuePair("device_brand",
						device_brand, "String");
				myTable.addUpdateFieldNameValuePair("birth_year", birth_year
						+ "", "int");
				myTable.addUpdateFieldNameValuePair("bio", bio, "String");
				myTable.addUpdateFieldNameValuePair("model", model, "String");
				myTable.addUpdateFieldNameValuePair("device_type", device_type
						+ "", "int");
				myTable.updateRecord();

				if (usernameChanged) {

					// need to update username in three tables
					myTable.clearUpdateVectors();
					myTable.setUpdateWhat("pmc_stories");
					myTable.addSet("posted_by", username, "string");
					myTable.setSCustomWhere("and posted_by = '" + oldName + "'");
					myTable.updateRecord();

					myTable.clearUpdateVectors();
					myTable.setUpdateWhat("pmc_stories_comments");
					myTable.addSet("username", username, "string");
					myTable.setSCustomWhere("and username = '" + oldName + "'");
					myTable.updateRecord();

					myTable.clearUpdateVectors();
					myTable.setUpdateWhat("gallery_detail");
					myTable.addSet("username", username, "string");
					myTable.setSCustomWhere("and username = '" + oldName + "'");
					myTable.updateRecord();
					
					session.setAttribute("username", username);

				}

				// handle avatar, if any
				Enumeration files = multi.getFileNames();
				String filename = "";
				// String type = "";
				String thePath = SingletonObjects.getInstance()
						.getSystem_path() + "tmp/";

				while (files.hasMoreElements()) {
					String name = (String) files.nextElement();
					filename = multi.getFilesystemName(name);
					// type = multi.getContentType(name);
				}

				if (filename == null) {
					filename = "";
				} else {

					Thumbnail myThumbNail = new Thumbnail();
					String theResult = myThumbNail.createThumbnail(thePath
							+ filename, SingletonObjects.getInstance()
							.getSystem_path()
							+ "/avatars/"
							+ "avatar_"
							+ customer_id + "_" + filename, 48);

					if (theResult.length() == 0) {
						myTable.clearUpdateVectors();
						myTable.setUpdateWhat("pmc_customer_extra");
						myTable.setSCustomWhere("and customer_id = "
								+ customer_id);
						myTable.addUpdateFieldNameValuePair("avatar", "avatar_"
								+ customer_id + "_" + filename, "String");
						myTable.updateRecord();
					} else {
						System.out
								.println("Error uploading file: " + theResult);
					}
				}

				hm.put("PRESERVEMSG", "TRUE");
				session.setAttribute("Error", "Information updated.");
				response.sendRedirect("/public/jpage/1/p/Home/content.do");
			} else {

				hm.put("PRESERVEMSG", "TRUE");
				session.setAttribute("Error",
						"The username you picked is not available!");
				response.sendRedirect("/public/jpage/1/p/ClientAdminPMC/a/clientadminpmc/content.do");
			}

		} catch (Exception e) {
			e.printStackTrace();
			Errors.addError("com.verilion.display.html.ProcessPage:ProcessForm:Exception:"
					+ e.toString());
		}
		return MasterTemplate;
	}
}
