//------------------------------------------------------------------------------
//Copyright (c) 2004 Verilion Inc.
//------------------------------------------------------------------------------
//Created on 2007-03-17
//Revisions
//------------------------------------------------------------------------------
//$Log: ProcessMemberFeedback.java,v $
//Revision 1.1  2007/03/18 00:24:21  tcs
//Intial entry
//
//------------------------------------------------------------------------------
package com.pmc.html.process;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.verilion.display.HTMLTemplateDb;
import com.verilion.display.html.process.ProcessPage;
import com.verilion.object.Errors;
import com.verilion.object.html.Years;

/**
 * Member feedback form
 * 
 * <P>
 * 17 March 2007
 * <P>
 * 
 * @author tsawler
 * @see com.verilion.display.html.Page
 * 
 */
public class ProcessMemberFeedback extends ProcessPage {

   String like_most = "";
   String like_least = "";
   String improve = "";
   int rate_site = 0;
   int customer_id = 0;

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

      try {

         MasterTemplate.searchReplace("$DDLBRS$", Years.makeDropDownListYears(
               "rate_site",
               0,
               1,
               10));

      } catch (Exception e) {
         e.printStackTrace();
         Errors
               .addError("com.verilion.display.html.process.ProcessMemberFeedback:BuildPage:Exception:"
                     + e.toString());
      }
      return MasterTemplate;
   }

   /*
    * (non-Javadoc)
    * 
    * @see com.verilion.display.html.ProcessPage#ProcessForm(javax.servlet.http.HttpServletRequest,
    *      javax.servlet.http.HttpServletResponse,
    *      javax.servlet.http.HttpSession, java.sql.Connection,
    *      com.verilion.display.HTMLTemplateDb, java.util.HashMap)
    */
   public HTMLTemplateDb ProcessForm(
         HttpServletRequest request,
         HttpServletResponse response,
         HttpSession session,
         Connection conn,
         HTMLTemplateDb MasterTemplate,
         HashMap hm) throws Exception {

      try {
         // get values from calling form

         rate_site = Integer.parseInt((String) request
               .getParameter("rate_site"));
         like_most = request.getParameter("like_most");
         like_least = request.getParameter("like_least");
         improve = request.getParameter("improve");
         customer_id = Integer.parseInt((String) session
               .getAttribute("customer_id"));

         PreparedStatement pst = null;

         String query = "insert into pmc_member_feedback (rate_site, like_most, like_least, improve, customer_id) "
               + " values (?, ?, ?, ?, ?)";
         pst = conn.prepareStatement(query);

         pst.setInt(1, rate_site);
         pst.setString(2, like_most);
         pst.setString(3, like_least);
         pst.setString(4, improve);
         pst.setInt(5, customer_id);
         pst.executeUpdate();
         pst.close();
         pst = null;

         MasterTemplate
               .replaceFullValue("Thanks for completing our Member Feedback Form. Your input is greatly appreciated."
            		   + " If you require a response, please <a href='/public/jpage/1/p/Contact/content.do'>contact us</a>.");

      } catch (Exception e) {
         e.printStackTrace();
         Errors
               .addError("com.verilion.display.html.ProcessPage:ProcessForm:Exception:"
                     + e.toString());
      }
      return MasterTemplate;
   }
}
