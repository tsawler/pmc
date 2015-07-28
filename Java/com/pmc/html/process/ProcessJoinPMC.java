//------------------------------------------------------------------------------
//Copyright (c) 2004 Verilion Inc.
//------------------------------------------------------------------------------
//Created on 2004-10-18
//Revisions
//------------------------------------------------------------------------------
//$Log: ProcessJoinPMC.java,v $
//Revision 1.2.2.2  2009/07/22 16:27:27  tcs
//*** empty log message ***
//
//Revision 1.2.2.1  2008/09/01 21:22:23  tcs
//*** empty log message ***
//
//Revision 1.2  2007/03/18 00:24:36  tcs
//Changed to reflect new db fields
//
//Revision 1.1  2007/03/05 17:11:24  tcs
//Intial entry
//
//------------------------------------------------------------------------------
package com.pmc.html.process;

import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.validator.EmailValidator;
import org.sourceforge.jxutil.sql.XDisconnectedRowSet;

import com.verilion.database.CtProvinceState;
import com.verilion.database.CustomerAddressDetail;
import com.verilion.database.CustomerEmailDetail;
import com.verilion.database.CustomerPhoneDetail;
import com.verilion.database.GenericTable;
import com.verilion.display.HTMLTemplateDb;
import com.verilion.display.html.process.ProcessPage;
import com.verilion.object.Errors;
import com.verilion.object.html.HTMLFormDropDownList;
import com.verilion.object.html.Years;

import com.pmc.VerifyRecaptcha;

/**
 * Form to join site
 * 
 * <P>
 * October 18, 2004
 * <P>
 * 
 * @author tsawler
 * @see com.verilion.display.html.Page
 * 
 */
public class ProcessJoinPMC extends ProcessPage {

	String first_name = "";
	String last_name = "";
	String username = "";
	String email_address = "";
	String password = "";
	int device_type = 0;
	String device_brand = "";
	int implant_year = 1950;
	int birth_year = 1870;
	int number_of_devices = 0;
	String interests = "";
	String bio = "";
	String occupation = "";
	String city = "";
	int ct_province_state_id = 62;
	int ct_country_id = 215;
	String query = "";
	int customer_id = 0;
	String model = "";
	int customer_add_to_mailing_list = 0;
	String theErrorMessage = "";
	String notify_on_comment = "";
	String notify_on_pm = "";

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.verilion.display.html.ProcessPage#BuildPage(javax.servlet.http.
	 * HttpServletRequest, javax.servlet.http.HttpServletResponse,
	 * javax.servlet.http.HttpSession, java.sql.Connection,
	 * com.verilion.display.HTMLTemplateDb, java.util.HashMap)
	 */
	public HTMLTemplateDb BuildPage(HttpServletRequest request, HttpServletResponse response, HttpSession session,
			Connection conn, HTMLTemplateDb MasterTemplate, HashMap hm) throws Exception {

		ResultSet rs = null;
		String theMenu = "";
		int year = 0;

		try {

			// ---------------------------------------------------------------------
			// create drop down list of provinces/states
			// ---------------------------------------------------------------------
			CtProvinceState myProvince = new CtProvinceState();
			myProvince.setConn(conn);
			rs = myProvince.getAllProvinceState();

			theMenu = HTMLFormDropDownList.makeDropDownListSnippet("state_province", ct_province_state_id, rs,
					"ct_province_state_id", "ct_province_state_name", 62, "&nbsp;");

			MasterTemplate.searchReplace("$DDLBSP$", theMenu);

			// ---------------------------------------------------------------------
			// create drop down list of countries
			// ---------------------------------------------------------------------
			GenericTable gt = new GenericTable("ct_country");
			gt.setConn(conn);
			gt.setSSelectWhat("ct_country_id, ct_country_name");
			gt.setSCustomOrder(" order by ct_country_name");
			XDisconnectedRowSet drs = new XDisconnectedRowSet();
			drs = gt.getAllRecordsDisconnected();

			theMenu = HTMLFormDropDownList.makeDropDownListSnippet("country", ct_country_id, drs, "ct_country_id",
					"ct_country_name", 215, "&nbsp;");

			MasterTemplate.searchReplace("$DDLBC$", theMenu);

			// ---------------------------------------------------------------------
			// create drop down list years for implant year
			// ---------------------------------------------------------------------
			Calendar cal = Calendar.getInstance();
			year = cal.get(Calendar.YEAR);

			MasterTemplate.searchReplace("$DDLBIY$", Years.makeDropDownListYears("implant_year", 0, 1950, year));

			MasterTemplate.searchReplace("$DDLBBY$", Years.makeDropDownListYears("birth_year", 0, 1870, year));

			MasterTemplate.searchReplace("$FIRSTNAME$", first_name);
			MasterTemplate.searchReplace("$LASTNAME$", last_name);
			MasterTemplate.searchReplace("$USERNAME$", username);
			MasterTemplate.searchReplace("$EMAIL$", email_address);
			MasterTemplate.searchReplace("$PASSWORD$", password);
			MasterTemplate.searchReplace("$CITY$", city);
			MasterTemplate.searchReplace("$NODEV$", number_of_devices + "");
			MasterTemplate.searchReplace("$INTERESTS$", interests);
			MasterTemplate.searchReplace("$OCCUPATION$", occupation);
			MasterTemplate.searchReplace("$BIO$", bio);
			MasterTemplate.searchReplace("$MODEL$", model);
			MasterTemplate.searchReplace("$NOTIFYPM$", " checked ");
			MasterTemplate.searchReplace("$NOTIFYCOMMENT$", " checked ");

		} catch (Exception e) {
			e.printStackTrace();
			Errors.addError("com.verilion.display.html.process.ProcessJoinSite:BuildPage:Exception:" + e.toString());
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
	@SuppressWarnings("deprecation")
	public HTMLTemplateDb ProcessForm(HttpServletRequest request, HttpServletResponse response, HttpSession session,
			Connection conn, HTMLTemplateDb MasterTemplate, HashMap hm) throws Exception {

		boolean isValid = true;

		isValid = this.ValidateData(request, response, session, conn, MasterTemplate, hm);
		if (isValid) {
			try {
				// get values from calling form
				device_type = Integer.parseInt((String) request.getParameter("device_type"));
				first_name = (String) request.getParameter("first_name");
				last_name = (String) request.getParameter("last_name");
				username = (String) request.getParameter("username");
				email_address = (String) request.getParameter("email_address");
				occupation = (String) request.getParameter("occupation");
				password = (String) request.getParameter("customer_password");
				number_of_devices = Integer.parseInt((String) request.getParameter("number_of_devices"));
				interests = (String) request.getParameter("interests");
				implant_year = Integer.parseInt((String) request.getParameter("implant_year"));
				birth_year = Integer.parseInt((String) request.getParameter("birth_year"));
				city = (String) request.getParameter("city");
				ct_province_state_id = Integer.parseInt((String) request.getParameter("state_province"));
				ct_country_id = Integer.parseInt((String) request.getParameter("country"));
				device_brand = (String) request.getParameter("device_brand");
				bio = (String) request.getParameter("bio");
				model = (String) request.getParameter("model");
				customer_add_to_mailing_list = Integer.parseInt((String) request.getParameter("receive_mail"));
				if (request.getParameter("notify_on_comment") != null) {
					notify_on_comment = "y";
				} else {
					notify_on_comment = "n";
				}
				if (request.getParameter("notify_on_pm") != null) {
					notify_on_pm = "y";
				} else {
					notify_on_pm = "n";
				}

				// validate email and username
				boolean isOkay = true;
				int numRecs = 0;
				Statement st = null;
				ResultSet rs = null;
				st = conn.createStatement();
				rs = st.executeQuery(
						"select count(customer_id) from v_pmc_customer where customer_email = '" + email_address + "'");
				while (rs.next()) {
					numRecs = rs.getInt(1);
				}
				if (numRecs > 0) {
					isOkay = false;
					theErrorMessage = email_address + " is already registered!";
				}
				rs.close();
				rs = null;
				st.close();
				st = null;

				if (!(EmailValidator.getInstance().isValid(email_address))) {
					isOkay = false;
					theErrorMessage += email_address + " is not a valid email!";
				}

				st = conn.createStatement();
				rs = st.executeQuery(
						"select count(customer_id) from v_pmc_customer where username = '" + username + "'");
				while (rs.next()) {
					numRecs = rs.getInt(1);
				}
				if (numRecs > 0) {
					isOkay = false;
					theErrorMessage = username + " is already taken!";
				}

				if (isOkay) {

					PreparedStatement pst = null;

					query = "insert into customer (customer_first_name, customer_last_name, customer_password, "
							+ "customer_active_yn, customer_access_level, username, customer_add_to_mailing_list, customer_registration_date, notify_on_comment, notify_on_pm)"
							+ " values (?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?)";
					pst = conn.prepareStatement(query);

					pst.setString(1, first_name);
					pst.setString(2, last_name);
					pst.setString(3, password);
					pst.setString(4, "y");
					pst.setInt(5, 2);
					pst.setString(6, username);
					pst.setInt(7, customer_add_to_mailing_list);
					pst.setString(8, notify_on_comment);
					pst.setString(9, notify_on_pm);
					pst.executeUpdate();
					pst.close();
					pst = null;

					query = "select currval('customer_customer_id_seq')";
					pst = conn.prepareStatement(query);
					rs = pst.executeQuery();
					rs.next();
					customer_id = rs.getInt(1);
					rs.close();
					rs = null;
					pst.close();
					pst = null;

					CustomerEmailDetail myEmail = new CustomerEmailDetail();
					myEmail.setConn(conn);
					myEmail.setCustomer_id(customer_id);
					myEmail.setCustomer_email(email_address);
					myEmail.setCustomer_email_default_yn("y");
					myEmail.addCustomerEmailDetail();

					// enter address info. 2 entries for everyone
					CustomerAddressDetail myAddress = new CustomerAddressDetail();
					myAddress.setConn(conn);
					myAddress.setCustomer_id(customer_id);
					myAddress.setCt_address_type_id(1);
					myAddress.setCustomer_address("");
					myAddress.setCustomer_town_city(city);
					myAddress.setCt_province_state_id(ct_province_state_id);
					myAddress.setCustomer_zip_postal("");
					myAddress.setCt_country_id(ct_country_id);
					myAddress.setPrimary_address_yn("y");
					myAddress.addCustomerAddressDetail();

					myAddress.setCustomer_id(customer_id);
					myAddress.setCt_address_type_id(3);
					myAddress.setCustomer_address("");
					myAddress.setCustomer_town_city(city);
					myAddress.setCt_province_state_id(ct_province_state_id);
					myAddress.setCustomer_zip_postal("");
					myAddress.setCt_country_id(ct_country_id);
					myAddress.setPrimary_address_yn("n");
					myAddress.addCustomerAddressDetail();

					// main number
					CustomerPhoneDetail myPhone = new CustomerPhoneDetail();
					myPhone.setConn(conn);
					myPhone.setCustomer_id(customer_id);
					myPhone.setCt_phone_type_id(1);
					myPhone.setCustomer_phone_default_yn("y");
					myPhone.setCustomer_phone("");
					myPhone.setCustomer_phone_extension("");
					myPhone.addCustomerPhoneDetail();

					// dummy fax
					myPhone.setCustomer_id(customer_id);
					myPhone.setCt_phone_type_id(4);
					myPhone.setCustomer_phone_default_yn("n");
					myPhone.setCustomer_phone("");
					myPhone.setCustomer_phone_extension("");
					myPhone.addCustomerPhoneDetail();

					// final info

					query = "insert into pmc_customer_extra (customer_id, occupation, number_of_devices, "
							+ "interests, implant_year, device_brand, birth_year, username, avatar, from_where, bio, model, device_type)"
							+ " values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
					pst = conn.prepareStatement(query);
					pst.setInt(1, customer_id);
					pst.setString(2, occupation);
					pst.setInt(3, number_of_devices);
					pst.setString(4, interests);
					pst.setInt(5, implant_year);
					pst.setString(6, device_brand);
					pst.setInt(7, birth_year);
					pst.setString(8, username);
					pst.setString(9, "default_avatar.png");
					pst.setString(10, "");
					pst.setString(11, bio);
					pst.setString(12, model);
					pst.setInt(13, device_type);
					pst.executeUpdate();
					pst.close();
					pst = null;

					response.sendRedirect("/public/jpage/1/p/Home/a/login/content.do?email_address="
							+ URLEncoder.encode(email_address) + "&password=" + URLEncoder.encode(password)
							+ "&url=/public/jpage/1/p/WelcomeToTheClub/a/welcometosite/content.do");
				} else {
					session.setAttribute("Error", theErrorMessage);
					this.BuildPage(request, response, session, conn, MasterTemplate, hm);
				}

			} catch (Exception e) {
				e.printStackTrace();
				Errors.addError("com.verilion.display.html.ProcessPage:ProcessForm:Exception:" + e.toString());
			}
		} else {
			this.BuildPage(request, response, session, conn, MasterTemplate, hm);
		}
		return MasterTemplate;
	}

	public boolean ValidateData(HttpServletRequest request, HttpServletResponse response, HttpSession session,
			Connection conn, HTMLTemplateDb MasterTemplate, HashMap hm) throws Exception {

		String subject = "";
		String story = "";
		String captcha_response = "";
		boolean isValid = true;
		String errormessage = "";

		try {
			// try {
			// captcha_response = (String)
			// request.getParameter("j_captcha_response");
			// String correctAnswer = (String) session
			// .getAttribute(com.verilion.object.captcha.servlet.Constants.SIMPLE_CAPCHA_SESSION_KEY);
			// System.out.println("correct in post story: " + correctAnswer);
			// System.out.println("Answer: " + captcha_response);
			// if (!(correctAnswer.equalsIgnoreCase(captcha_response))) {
			// isValid = false;
			// errormessage += "Incorrect spam code entered. Try again... ";
			// }
			// } catch (Exception e) {
			// System.out.println("Error checking captcha for post story: " +
			// e.toString());
			// isValid = false;
			// errormessage += "Incorrect spam code entered. Try again... ";
			// }

			String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
			boolean verify = VerifyRecaptcha.verify(gRecaptchaResponse);

			if (verify == false) {
				isValid = false;
				errormessage += "Sorry, but you did not verify that you are human. Try again... ";
			}

			if (errormessage.length() > 0) {
				session.setAttribute("Error", errormessage);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return isValid;
	}
}
