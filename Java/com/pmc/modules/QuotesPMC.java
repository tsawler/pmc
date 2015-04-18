//------------------------------------------------------------------------------
//Copyright (c) 2004 Verilion Inc.
//------------------------------------------------------------------------------
//Created on 2004-07-05
//Revisions
//------------------------------------------------------------------------------
//$Log: QuotesPMC.java,v $
//Revision 1.1.2.1  2009/07/22 16:27:26  tcs
//*** empty log message ***
//
//Revision 1.1  2007/03/18 00:27:12  tcs
//Initial entry
//
//------------------------------------------------------------------------------
package com.pmc.modules;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.verilion.object.html.modules.QuotesModule;

/**
 * PMC Quotes
 * 
 * @author tsawler
 * @see com.verilion.objects.html.modules.QuotesModule
 */
public class QuotesPMC extends QuotesModule {

   @Override
   public String getHtmlOutput(Connection conn, HttpSession session, HttpServletRequest request) throws Exception {
      super.setTitle("You're Wired When...");
      super.setUrl("/public/jpage/1/p/Store/content.do");
      return super.getHtmlOutput(conn, session, request);
   }
    
}