//------------------------------------------------------------------------------
//Copyright (c) 2004-2007 Verilion Inc.
//------------------------------------------------------------------------------
//Created on 2007-10-14
//Revisions
//------------------------------------------------------------------------------
//$Log: ProcessDisplayCustomer.java,v $
//Revision 1.2.2.2  2009/07/22 16:27:27  tcs
//*** empty log message ***
//
//Revision 1.2.2.1  2007/10/22 14:12:31  tcs
//Initial entry
//
//------------------------------------------------------------------------------
package com.pmc.html.admin.process;

import java.sql.Connection;
import java.sql.ResultSet;
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

public class ProcessDisplayCustomer extends ProcessPage {

	public ProcessDisplayCustomer() {
		first_name = "";
		last_name = "";
		email_address = "";
		password = "";
		device_brand = "";
		implant_year = 0;
		birth_year = 0;
		number_of_devices = 0;
		interests = "";
		bio = "";
		occupation = "";
		city = "";
		ct_province_state_id = 0;
		ct_country_id = 0;
		customer_id = 0;
		model = "";
		device_type = 0;
		customer_add_to_mailing_list = 0;
		cancelPage = "";
		customer_active_yn = "";
		customer_access_level = 0;
		String notify_on_pm = "";
		String notify_on_comment = "";
	}

	public HTMLTemplateDb BuildPage(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Connection conn,
			HTMLTemplateDb MasterTemplate, HashMap hm) throws Exception {
		ResultSet rs;
		String notify_on_pm = "";
		String notify_on_comment = "";
		String first_name;
		String last_name;
		String username;
		String email_address;
		String password;
		String device_brand;
		int implant_year;
		int birth_year;
		int number_of_devices;
		String interests;
		String bio;
		String occupation;
		String city;
		int ct_province_state_id;
		int ct_country_id;
		String model;
		int customer_add_to_mailing_list;
		int device_type;
		String avatar;
		int customer_id;
		GenericTable myTable;
		rs = null;
		String theMenu = "";
		first_name = "";
		last_name = "";
		username = "";
		email_address = "";
		password = "";
		device_brand = "";
		implant_year = 0;
		birth_year = 0;
		number_of_devices = 0;
		interests = "";
		bio = "";
		occupation = "";
		city = "";
		ct_province_state_id = 0;
		ct_country_id = 0;
		model = "";
		customer_add_to_mailing_list = 0;
		device_type = 0;
		avatar = "";
		customer_id = 0;
		int year = 0;
		myTable = new GenericTable("v_pmc_customer");
		XDisconnectedRowSet drs = new XDisconnectedRowSet();
		try {
			customer_id = Integer.parseInt(request.getParameter("id"));
			cancelPage = request.getParameter("cancelPage");
		} catch (Exception e) {
			e.printStackTrace();
			customer_id = 0;
		}
		myTable.setConn(conn);
		try {
			myTable.setSSelectWhat("*");
			myTable.setSCustomWhere((new StringBuilder("and customer_id = "))
					.append(customer_id).toString());

			for (drs = myTable.getAllRecordsDisconnected(); drs.next();) {
				customer_access_level = drs.getInt("customer_access_level");
				customer_active_yn = drs.getString("customer_active_yn");
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
			if (avatar.equals("default_avatar.png"))
				MasterTemplate
						.searchReplace(
								"$IMG$",
								"<img src=\"/avatars/default_avatar.png\" height=\"48\" width=\"48\" alt=\"avatar image\" />");
			else
				MasterTemplate.searchReplace("$IMG$", (new StringBuilder(
						"<img src=\"/avatars/")).append(avatar).append(
						"\" alt=\"avatar image\" />").toString());
			CtProvinceState myProvince = new CtProvinceState();
			myProvince.setConn(conn);
			rs = myProvince.getAllProvinceState();
			theMenu = HTMLFormDropDownList.makeDropDownListSnippet(
					"state_province", ct_province_state_id, rs,
					"ct_province_state_id", "ct_province_state_name", 62,
					"&nbsp;");
			MasterTemplate.searchReplace("$DDLBSP$", theMenu);
			CtCountry myCountry = new CtCountry();
			myCountry.setConn(conn);
			rs = myCountry.getAllCountries();
			theMenu = HTMLFormDropDownList.makeDropDownListSnippet("country",
					ct_country_id, rs, "ct_country_id", "ct_country_name", 215,
					"&nbsp;");
			MasterTemplate.searchReplace("$DDLBC$", theMenu);
			Calendar cal = Calendar.getInstance();
			year = cal.get(1);
			MasterTemplate.searchReplace("$DDLBIY$", Years
					.makeDropDownListYears("implant_year", implant_year, 1950,
							year));
			MasterTemplate.searchReplace("$DDLBND$", Years
					.makeDropDownListYears("number_of_devices",
							number_of_devices, 0, 20));
			MasterTemplate.searchReplace("$DDLBBY$",
					Years.makeDropDownListYears("birth_year", birth_year, 1870,
							year));
			int i = 1;
			theMenu = "<select class=\"inputbox\" name=\"receive_mail\">";
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"<option value=\"1\"").toString();
			if (i == customer_add_to_mailing_list)
				theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
						" selected ").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					">Yes</option>").toString();
			i--;
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"<option value=\"0\"").toString();
			if (i == customer_add_to_mailing_list)
				theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
						" selected ").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					">No</option>").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"</select>").toString();
			MasterTemplate.searchReplace("$DDLBAL$", theMenu);
			theMenu = "<select class=\"inputbox\" name=\"customer_active_yn\">";
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"<option value=\"y\"").toString();
			if (customer_active_yn.equalsIgnoreCase("y"))
				theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
						" selected ").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					">Yes</option>").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"<option value=\"n\"").toString();
			if (customer_active_yn.equalsIgnoreCase("n"))
				theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
						" selected ").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					">No</option>").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"</select>").toString();
			MasterTemplate.searchReplace("$DDLBMA$", theMenu);
			GenericTable customerAccess = new GenericTable("ct_access_level");
			customerAccess.setConn(conn);
			customerAccess.setSSelectWhat("*");
			XDisconnectedRowSet crs = new XDisconnectedRowSet();
			crs = customerAccess.getAllRecordsDisconnected();
			theMenu = HTMLFormDropDownList.makeDropDownListSnippet(
					"customer_access_level", customer_access_level, crs,
					"ct_access_level_id", "ct_access_level_name", 0, "");
			MasterTemplate.searchReplace("$DDLBCAL$", theMenu);
			i = 0;
			theMenu = "<select class=\"inputbox\" name=\"device_type\">";
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"<option value=\"").append(i).append("\"").toString();
			if (i == device_type)
				theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
						" selected ").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					">&nbsp;</option>").toString();
			i++;
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"<option value=\"").append(i).append("\"").toString();
			if (i == device_type)
				theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
						" selected ").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					">Pacemaker</option>").toString();
			i++;
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"<option value=\"").append(i).append("\"").toString();
			if (i == device_type)
				theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
						" selected ").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					">Defibrillator</option>").toString();
			theMenu = (new StringBuilder(String.valueOf(theMenu))).append(
					"</select>").toString();
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
			MasterTemplate.searchReplace("$CANCEL$", cancelPage);
			MasterTemplate.searchReplace("$ID$", (new StringBuilder(String
					.valueOf(customer_id))).toString());
			if (device_brand.startsWith("B"))
				MasterTemplate.searchReplace(
						"value=\"Boston Scientific/Guidant\">",
						"value=\"Boston Scientific\" selected>");
			else if (device_brand.startsWith("M"))
				MasterTemplate.searchReplace("value=\"Medtronic\">",
						"value=\"Medtronic\" selected>");
			else if (device_brand.startsWith("S"))
				MasterTemplate.searchReplace("value=\"St. Jude Medical\">",
						"value=\"St. Jude Medical\" selected>");
			else if (device_brand.startsWith("O"))
				MasterTemplate.searchReplace("value=\"Other\">",
						"value=\"Other\" selected>");
			else
				MasterTemplate.searchReplace("value=\"Unknown\">",
						"value=\"Unknown\" selected>");
		} catch (Exception e) {
			e.printStackTrace();
			Errors.addError((new StringBuilder(
					"ProcessDisplayCustomer:BuildPage:Exception:")).append(
					e.toString()).toString());

		} finally {

			if (rs != null) {
				rs.close();
				rs = null;
			}
		}
		return MasterTemplate;
	}

	public HTMLTemplateDb ProcessFormMultipart(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Connection conn,
			HTMLTemplateDb MasterTemplate, HashMap hm, MultipartRequest multi)
			throws Exception {
		String notify_on_pm = "";
		String notify_on_comment = "";

		try {
			customer_id = Integer.parseInt(multi.getParameter("id"));
			cancelPage = multi.getParameter("cancelPage");
		} catch (Exception e) {
			e.printStackTrace();
			customer_id = 0;
		}
		try {
			customer_access_level = Integer.parseInt(multi
					.getParameter("customer_access_level"));
			customer_active_yn = multi.getParameter("customer_active_yn");
			customer_add_to_mailing_list = Integer.parseInt(multi
					.getParameter("receive_mail"));
			device_type = Integer.parseInt(multi.getParameter("device_type"));
			first_name = multi.getParameter("first_name");
			last_name = multi.getParameter("last_name");
			email_address = multi.getParameter("email_address");
			occupation = multi.getParameter("occupation");
			password = multi.getParameter("customer_password");
			number_of_devices = Integer.parseInt(multi
					.getParameter("number_of_devices"));
			interests = multi.getParameter("interests");
			implant_year = Integer.parseInt(multi.getParameter("implant_year"));
			birth_year = Integer.parseInt(multi.getParameter("birth_year"));
			city = multi.getParameter("city");
			ct_province_state_id = Integer.parseInt(multi
					.getParameter("state_province"));
			ct_country_id = Integer.parseInt(multi.getParameter("country"));
			device_brand = multi.getParameter("device_brand");
			bio = multi.getParameter("bio");
			model = multi.getParameter("model");
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
			GenericTable myTable = new GenericTable();
			myTable.setConn(conn);
			myTable.setUpdateWhat("customer");
			myTable.setSCustomWhere((new StringBuilder("and customer_id = "))
					.append(customer_id).toString());
			myTable.addUpdateFieldNameValuePair("customer_first_name",
					first_name, "string");
			myTable.addUpdateFieldNameValuePair("customer_last_name",
					last_name, "string");
			myTable.addUpdateFieldNameValuePair("customer_password", password,
					"string");
			myTable
					.addUpdateFieldNameValuePair(
							"customer_add_to_mailing_list",
							(new StringBuilder(String
									.valueOf(customer_add_to_mailing_list)))
									.toString(), "int");
			myTable.addUpdateFieldNameValuePair("customer_active_yn",
					customer_active_yn, "string");
			myTable.addUpdateFieldNameValuePair("customer_access_level",
					(new StringBuilder(String.valueOf(customer_access_level)))
							.toString(), "int");
			myTable.addSet("notify_on_pm", notify_on_pm, "string");
			myTable.addSet("notify_on_comment", notify_on_comment, "string");
			myTable.updateRecord();
			CustomerEmailDetail myEmail = new CustomerEmailDetail();
			myEmail.setConn(conn);
			myEmail.setCustomer_id(customer_id);
			myEmail.setCustomer_email(email_address);
			myEmail.updateAllEmailsForCustomerId();
			myTable.clearUpdateVectors();
			myTable.setUpdateWhat("customer_address_detail");
			myTable.setSCustomWhere((new StringBuilder("and customer_id = "))
					.append(customer_id).toString());
			myTable.addUpdateFieldNameValuePair("ct_province_state_id",
					(new StringBuilder(String.valueOf(ct_province_state_id)))
							.toString(), "int");
			myTable.addUpdateFieldNameValuePair("ct_country_id",
					(new StringBuilder(String.valueOf(ct_country_id)))
							.toString(), "int");
			myTable.addUpdateFieldNameValuePair("customer_town_city", city,
					"string");
			myTable.updateRecord();
			myTable.clearUpdateVectors();
			myTable.setUpdateWhat("pmc_customer_extra");
			myTable.setSCustomWhere((new StringBuilder("and customer_id = "))
					.append(customer_id).toString());
			myTable.addUpdateFieldNameValuePair("occupation", occupation,
					"String");
			myTable.addUpdateFieldNameValuePair("number_of_devices",
					(new StringBuilder(String.valueOf(number_of_devices)))
							.toString(), "int");
			myTable.addUpdateFieldNameValuePair("interests", interests,
					"String");
			myTable.addUpdateFieldNameValuePair("implant_year",
					(new StringBuilder(String.valueOf(implant_year)))
							.toString(), "int");
			myTable.addUpdateFieldNameValuePair("device_brand", device_brand,
					"String");
			myTable.addUpdateFieldNameValuePair("birth_year",
					(new StringBuilder(String.valueOf(birth_year))).toString(),
					"int");
			myTable.addUpdateFieldNameValuePair("bio", bio, "String");
			myTable.addUpdateFieldNameValuePair("model", model, "String");
			myTable
					.addUpdateFieldNameValuePair("device_type",
							(new StringBuilder(String.valueOf(device_type)))
									.toString(), "int");
			myTable.updateRecord();
			Enumeration files = multi.getFileNames();
			String filename = "";
			String thePath = (new StringBuilder(String.valueOf(SingletonObjects
					.getInstance().getSystem_path()))).append("tmp/")
					.toString();
			while (files.hasMoreElements()) {
				String name = (String) files.nextElement();
				filename = multi.getFilesystemName(name);
			}
			if (filename == null) {
				filename = "";
			} else {
				Thumbnail myThumbNail = new Thumbnail();
				String theResult = myThumbNail.createThumbnail(
						(new StringBuilder(String.valueOf(thePath))).append(
								filename).toString(), (new StringBuilder(String
								.valueOf(SingletonObjects.getInstance()
										.getSystem_path())))
								.append("/avatars/").append("avatar_").append(
										customer_id).append("_").append(
										filename).toString(), 48);
				if (theResult.length() == 0) {
					myTable.clearUpdateVectors();
					myTable.setUpdateWhat("pmc_customer_extra");
					myTable.setSCustomWhere((new StringBuilder(
							"and customer_id = ")).append(customer_id)
							.toString());
					myTable.addUpdateFieldNameValuePair("avatar",
							(new StringBuilder("avatar_")).append(customer_id)
									.append("_").append(filename).toString(),
							"String");
					myTable.updateRecord();
				} else {
					System.out.println((new StringBuilder(
							"Error uploading file: ")).append(theResult)
							.toString());
				}
			}
			hm.put("PRESERVEMSG", "TRUE");
			session.setAttribute("Error", "Information updated.");
			response
					.sendRedirect("/customer/jpage/1/p/SearchCustomers/admin/1/content.do");
		} catch (Exception e) {
			e.printStackTrace();
			Errors.addError((new StringBuilder(
					"ProcessDisplayCustomer:ProcessForm:Exception:")).append(
					e.toString()).toString());
		}
		return MasterTemplate;
	}

	public HTMLTemplateDb ProcessForm(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Connection conn,
			HTMLTemplateDb MasterTemplate, HashMap hm) throws Exception {
		try {
			customer_id = Integer.parseInt(request.getParameter("id"));
			cancelPage = request.getParameter("cancelPage");
		} catch (Exception e) {
			e.printStackTrace();
			customer_id = 0;
		}
		BuildPage(request, response, session, conn, MasterTemplate, hm);
		return MasterTemplate;
	}

	String first_name;
	String last_name;
	String email_address;
	String password;
	String device_brand;
	int implant_year;
	int birth_year;
	int number_of_devices;
	String interests;
	String bio;
	String occupation;
	String city;
	int ct_province_state_id;
	int ct_country_id;
	int customer_id;
	String model;
	int device_type;
	int customer_add_to_mailing_list;
	String cancelPage;
	String customer_active_yn;
	int customer_access_level;
}
