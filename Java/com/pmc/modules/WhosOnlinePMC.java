//------------------------------------------------------------------------------
//Copyright (c) 2004-2007 Verilion Inc.
//------------------------------------------------------------------------------
//Created on 2004-07-05
//Revisions
//------------------------------------------------------------------------------
//$Log: WhosOnlinePMC.java,v $
//Revision 1.1.2.2  2009/07/22 16:27:27  tcs
//*** empty log message ***
//
//Revision 1.1.2.1  2007/10/16 01:10:12  tcs
//Initial entry
//
//------------------------------------------------------------------------------
package com.pmc.modules;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.sourceforge.jxutil.sql.XDisconnectedRowSet;

import com.verilion.database.GenericTable;
import com.verilion.object.Errors;
import com.verilion.object.html.modules.SessionCounterModule;

public class WhosOnlinePMC extends SessionCounterModule {

    public WhosOnlinePMC() {
    }

    public String getHtmlOutput(Connection conn, HttpSession session, HttpServletRequest request)
        throws Exception {
        String theString = "";
        String query = "";
        ResultSet rs = null;
        Statement st = null;
        int sessionCount = 0;
        String visitorString = "";
        query = "select sessions from sessions";
        st = conn.createStatement();
        for(rs = st.executeQuery(query); rs.next();)
            sessionCount = rs.getInt(1);

        rs.close();
        rs = null;
        st.close();
        st = null;
        if(sessionCount < 1)
            sessionCount = 1;
        if(sessionCount > 1)
            visitorString = " visitors ";
        else
            visitorString = " visitor ";
        try {
            theString = (new StringBuilder("<div class=\"vmodule\">\n<div class=\"vmoduleheading\">Who's Online?</div>\n<div class=\"vmodulebody\">We have ")).append(sessionCount).append(visitorString).append("online.</div>").toString();
            GenericTable myTable = new GenericTable("logged_in_users");
            myTable.setConn(conn);
            myTable.setSSelectWhat("distinct username");
            myTable.setSCustomWhere("and username is not null");
            XDisconnectedRowSet drs = new XDisconnectedRowSet();
            drs = myTable.getAllRecordsDisconnected();
            if(drs.next()) {
                drs.previous();
                theString = (new StringBuilder(String.valueOf(theString))).append("<div class=\"vmodulebody\"><br /><strong>Members online:</strong><br />").toString();
                while(drs.next()) 
                    if(session.getAttribute("customer_id") != null) {
                        if(Integer.parseInt((String)session.getAttribute("customer_id")) > 0)
                            theString = (new StringBuilder(String.valueOf(theString))).append("&nbsp;&nbsp;<a title=\"Read  member profile\" href=\"/members/jpage/1/p/MemberDirectory/content.do?uname=").append(drs.getString("username")).append("\">").append(drs.getString("username")).append("</a>").append("<br />").toString();
                        else
                            theString = (new StringBuilder(String.valueOf(theString))).append("&nbsp;&nbsp;").append(drs.getString("username")).append("<br />").toString();
                    } else {
                        theString = (new StringBuilder(String.valueOf(theString))).append("&nbsp;&nbsp;").append(drs.getString("username")).append("<br />").toString();
                    }
                theString = (new StringBuilder(String.valueOf(theString))).append("</div>").toString();
            }
            theString = (new StringBuilder(String.valueOf(theString))).append("\n</div>\n").toString();
        }
        catch(Exception e) {
            Errors.addError((new StringBuilder("SessionCounter.getHtmlOutput:Exception:")).append(e.toString()).toString());
        }
        return theString;
    }
}
