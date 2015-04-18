//------------------------------------------------------------------------------
//Copyright (c) 2004-2007 Verilion Inc.
//------------------------------------------------------------------------------
//Created on 2007-03-14
//Revisions
//------------------------------------------------------------------------------
//$Log: ProcessWelcomeToSite.java,v $
//Revision 1.1  2007/03/18 00:24:21  tcs
//Intial entry
//
//------------------------------------------------------------------------------
package com.pmc.html.process;

import java.sql.Connection;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.sourceforge.jxutil.sql.XDisconnectedRowSet;

import com.verilion.database.GenericTable;
import com.verilion.display.HTMLTemplateDb;
import com.verilion.display.html.process.ProcessPage;
import com.verilion.object.Errors;

/**
 * Displays new member info after signup
 * 
 * @author tsawler
 * @see com.verilion.display.html.Page
 * 
 */
public class ProcessWelcomeToSite extends ProcessPage {

   /*
    * (non-Javadoc)
    * 
    * @see com.verilion.display.html.ProcessPage#BuildPage(javax.servlet.http.HttpServletRequest,
    *      javax.servlet.http.HttpServletResponse,
    *      javax.servlet.http.HttpSession, java.sql.Connection,
    *      com.verilion.display.HTMLTemplateDb, java.util.HashMap)
    */
   public HTMLTemplateDb BuildPage(
         HttpServletRequest request,
         HttpServletResponse response,
         HttpSession session,
         Connection conn,
         HTMLTemplateDb MasterTemplate,
         HashMap hm) throws Exception {

      String username = "";
      String email_address = "";
      String password = "";
      int customer_id = 0;
      GenericTable myTable = new GenericTable("v_pmc_customer");
      XDisconnectedRowSet drs = new XDisconnectedRowSet();

      try {
         customer_id = Integer.parseInt((String) session
               .getAttribute("customer_id"));
      } catch (Exception e) {
         customer_id = 0;
      }
      myTable.setConn(conn);

      try {
         // first get info for this customer
         myTable.setSSelectWhat("*");
         myTable.setSCustomWhere("and customer_id = " + customer_id);
         drs = myTable.getAllRecordsDisconnected();
         while (drs.next()) {
            password = drs.getString("customer_password");
            username = drs.getString("username");
            email_address = drs.getString("customer_email");
         }
         drs.close();
         drs = null;

         MasterTemplate.searchReplace("$username$", username);
         MasterTemplate.searchReplace("$email$", email_address);
         MasterTemplate.searchReplace("$password$", password);

      } catch (Exception e) {
         e.printStackTrace();
         Errors.addError("ProcessWelcomeToSite:BuildPage:Exception:"
               + e.toString());
      }
      return MasterTemplate;
   }

}
