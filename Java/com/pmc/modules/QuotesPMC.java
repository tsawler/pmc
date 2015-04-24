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
	public String getHtmlOutput(Connection conn, HttpSession session,
			HttpServletRequest request) throws Exception {
		super.setTitle("You're Wired When...");
		super.setUrl("/public/jpage/1/p/Store/content.do");
		return super.getHtmlOutput(conn, session, request);
	}

}