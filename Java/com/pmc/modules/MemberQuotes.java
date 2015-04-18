//------------------------------------------------------------------------------
//Copyright (c) 2009 Verilion Inc.
//------------------------------------------------------------------------------
//Created on 2009-05-26
//Revisions
//------------------------------------------------------------------------------
//$Log: MemberQuotes.java,v $
//Revision 1.1.2.1  2009/07/22 16:27:27  tcs
//*** empty log message ***
//
//------------------------------------------------------------------------------
package com.pmc.modules;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.sourceforge.jxutil.sql.XDisconnectedRowSet;

import com.verilion.database.GenericTable;
import com.verilion.database.Quotes;
import com.verilion.object.Errors;
import com.verilion.object.html.modules.ModuleInterface;

/**
 * Displays random quotes in a formatted box
 * <P>
 * July 5, 2004
 * <P>
 * 
 * @author tsawler
 * 
 */
public class MemberQuotes implements ModuleInterface {

   public String title = "Member Quotes";
   public String url = "";

   /**
    * Builds an html table with a random quote
    * 
    * @return String - fully formatted quote as html
    * @throws Exception
    */
   public String getHtmlOutput(Connection conn, HttpSession session, HttpServletRequest request)
         throws Exception {
	   
	  String myQuote = "";

      String theFormattedQuote = "";
      GenericTable myGt = new GenericTable("pmc_quotes");
      myGt.setConn(conn);
      myGt.setSSelectWhat("*");
      myGt.setSCustomWhere(" and quote_active_yn = 'y' ");
      myGt.setSCustomOrder(" order by random() limit 1 ");
      XDisconnectedRowSet drs = new XDisconnectedRowSet();
      drs = myGt.getAllRecordsDisconnected();
      while (drs.next()) {
    	  myQuote = drs.getString("quote_text");
      }
      drs.close();
      drs = null;
      
      try {
         if (url.length() > 0) {
            theFormattedQuote = "<a href=\"" + url + "\">";
         }
         theFormattedQuote += "<div class=\"vmodule\">\n"
               + "<div class=\"vmoduleheading\">"
               + title
               + "</div>\n"
               + "<div class=\"vmodulebody\">\n";
         theFormattedQuote += myQuote + "</div></div>";
         if (url.length() > 0) {
            theFormattedQuote += "</a>";
         }
      } catch (Exception e) {
         Errors.addError("QuoteModule.getHtmlOutput:Exception:" + e.toString());
      }
      return theFormattedQuote;
   }

   public String getTitle() {
      return title;
   }

   public void setTitle(String title) {
      this.title = title;
   }

   public String getUrl() {
      return url;
   }

   public void setUrl(String url) {
      this.url = url;
   }
}