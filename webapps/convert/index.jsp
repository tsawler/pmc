<%@include file="header.jsp"%>
<html>
<head>
<title>
Data conversion
</title>
</head>
<body>
<%
String query2 = "";
try {
PreparedStatement ppst = null;
ppst = conn.prepareStatement("delete from customer where customer_id <> 99999999");
ppst.executeUpdate();
ppst.close();
ppst = null;
ppst = conn.prepareStatement("delete from pmc_stories");
ppst.executeUpdate();
ppst.close();
ppst = null;
ppst = conn.prepareStatement("delete from pmc_story_category");
ppst.executeUpdate();
ppst.close();
ppst = null;
ppst = conn.prepareStatement("delete from pmc_stories_comments");
ppst.executeUpdate();
ppst.close();
ppst = null;
ppst = conn.prepareStatement("delete from links");
ppst.executeUpdate();
ppst.close();
ppst = null;
ppst = conn.prepareStatement("delete from customer_messages");
ppst.executeUpdate();
ppst.close();
ppst = null;
ppst = conn.prepareStatement("delete from customer_messages_sent");
ppst.executeUpdate();
ppst.close();
ppst = null;

String query = "select * from nuke_users";
Statement mysqlSt = null;
mysqlSt = mysql_conn.createStatement();
ResultSet mysqlRs = null;
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	int pn_uid = mysqlRs.getInt("pn_uid");
	String name = mysqlRs.getString("pn_name");
	String username = mysqlRs.getString("pn_uname");
	String email = mysqlRs.getString("pn_email");
	String avatar = mysqlRs.getString("pn_user_avatar");
	long l = mysqlRs.getLong("pn_user_regdate");
	l = l * 1000;
	Timestamp regDate = new Timestamp(l);
	int number_of_devices = 1;
	try {
		number_of_devices = mysqlRs.getInt("pn_user_icq");
	} catch (Exception e) {
	
	}
	String occupation = mysqlRs.getString("pn_user_occ");
	String from_where = mysqlRs.getString("pn_user_from");
	String interests = mysqlRs.getString("pn_user_intrest");
	String implant_year = mysqlRs.getString("pn_user_aim");
	String first_name = "";
	String last_name = "";
	int impYear = 0;
	try {
		impYear = Integer.parseInt(implant_year);
	} catch (Exception e) {
	
	}
	String device_type = "";
	String tmp = mysqlRs.getString("pn_user_yim");
	if ((tmp.startsWith("M")) ||  (tmp.startsWith("m"))) {
		device_type = "Medtronic";
	} else if ((tmp.startsWith("S")) ||  (tmp.startsWith("s"))) {
		device_type = "St. Jude Medical";
	} else if ((tmp.startsWith("B")) ||  (tmp.startsWith("b"))) {
		device_type = "Boston Scientific/Guidant";
	} else if ((tmp.startsWith("O")) ||  (tmp.startsWith("o"))) {
		device_type = "Other";
	} else {
		device_type = "Unknown";
	}
	String YOB = mysqlRs.getString("pn_user_msnm");
	int by = 0;
	try {
		by = Integer.parseInt(YOB);
	} catch (Exception e) {
	
	}
	String bio = mysqlRs.getString("pn_bio");
	String theDate = "";
	theDate = regDate.toString();
	theDate = theDate.substring(0, 10);
	SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
	java.util.Date registrationDate = sdf.parse(theDate);
	
	char[] pw = new char[8];
	int c  = 'A';
	int  r1 = 0;
	for (int i=0; i < 8; i++)
	{
	  r1 = (int)(Math.random() * 3);
	  switch(r1) {
		case 0: c = '0' +  (int)(Math.random() * 10); break;
		case 1: c = 'a' +  (int)(Math.random() * 26); break;
		case 2: c = 'A' +  (int)(Math.random() * 26); break;
	  }
	  pw[i] = (char)c;
	}
	if (name.length() < 1) {
		name = "unknown";
	}
	try {
		if (name.indexOf(" ") > 0) {
			String tmpName = name;
			first_name = tmpName.substring(0, name.indexOf(" "));
			last_name = tmpName.substring(name.indexOf(" "), name.length());
		} else {
			first_name = name;
			last_name = "unknown";
		}
	} catch (Exception e) {
		first_name = name;
		last_name = "unknown";
	}
	query2 = "insert into customer (customer_id, customer_last_name, customer_add_to_mailing_list, "
		+ "customer_registration_date, customer_password, customer_access_level, customer_active_yn, "
		+ "customer_isnew_yn, customer_first_name, username) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	pst.setInt(1, pn_uid);
	pst.setString(2, last_name.trim());
	pst.setInt(3, 1);
	//pst.setDate(4, theDate);
	pst.setDate(4, new java.sql.Date(registrationDate.getTime()));
	pst.setString(5, new String(pw));
	pst.setInt(6, 2);
	pst.setString(7, "y");
	pst.setString(8, "n");
	pst.setString(9, first_name.trim());
	pst.setString(10, username);
	pst.executeUpdate();
	pst.close();
	pst = null;
	query2 = "insert into pmc_customer_extra (customer_id, avatar, occupation, number_of_devices, from_where, interests, implant_year, device_brand, birth_year, bio, username) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	pst = conn.prepareStatement(query2);
	pst.setInt(1, pn_uid);
	pst.setString(2, "default_avatar.png");
	pst.setString(3, occupation);
	pst.setInt(4, number_of_devices);
	pst.setString(5, from_where);
	pst.setString(6, interests);
	pst.setInt(7, impYear);
	pst.setString(8, device_type);
	pst.setInt(9, by);
	pst.setString(10, bio);
	pst.setString(11, username);
	pst.executeUpdate();
	pst.close();
	pst = null;
	query2 = "insert into customer_address_detail (ct_address_type_id, customer_address, customer_town_city, ct_province_state_id, ct_country_id, customer_zip_postal, primary_address_yn, customer_id) values (?, ?, ?, ?, ?, ?, ?, ?)";
	pst = conn.prepareStatement(query2);
	pst.setInt(1, 1);
	pst.setString(2, "unknown");
	pst.setString(3, "unknown");
	pst.setInt(4, 1);
	pst.setInt(5, 1);
	pst.setString(6, "unknown");
	pst.setString(7, "y");
	pst.setInt(8, pn_uid);
	pst.executeUpdate();
	pst.close();
	pst = null;
	
	query2 = "insert into customer_address_detail (ct_address_type_id, customer_address, customer_town_city, ct_province_state_id, ct_country_id, customer_zip_postal, primary_address_yn, customer_id) values (?, ?, ?, ?, ?, ?, ?, ?)";
	pst = conn.prepareStatement(query2);
	pst.setInt(1, 3);
	pst.setString(2, "unknown");
	pst.setString(3, "unknown");
	pst.setInt(4, 1);
	pst.setInt(5, 1);
	pst.setString(6, "unknown");
	pst.setString(7, "n");
	pst.setInt(8, pn_uid);
	pst.executeUpdate();
	pst.close();
	pst = null;
	query2 = "insert into customer_phone_detail (ct_phone_type_id, customer_phone, customer_phone_default_yn, customer_id) values (?, ?, ?, ?)";
	pst = conn.prepareStatement(query2);
	pst.setInt(1, 1);
	pst.setString(2, "unknown");
	pst.setString(3, "y");
	pst.setInt(4, pn_uid);
	pst.executeUpdate();
	pst.close();
	pst = null;
	
	query2 = "insert into customer_phone_detail (ct_phone_type_id, customer_phone, customer_phone_default_yn, customer_id) values (?, ?, ?, ?)";
	pst = conn.prepareStatement(query2);
	pst.setInt(1, 4);
	pst.setString(2, "unknown");
	pst.setString(3, "n");
	pst.setInt(4, pn_uid);
	pst.executeUpdate();
	pst.close();
	pst = null;
	
	query2 = "insert into customer_email_detail (customer_id, customer_email, customer_email_default_yn) values (?, ?, ?)";
	pst = conn.prepareStatement(query2);
	pst.setInt(1, pn_uid);
	pst.setString(2, email);
	pst.setString(3, "y");
	pst.executeUpdate();
	pst.close();
	pst = null;
	%>
	Doing <%=name%>, <%=username%><br />
	<%
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;

try {
mysqlSt = mysql_conn.createStatement();
query = "select * from nuke_topics";
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	int catId = mysqlRs.getInt("pn_topicid");
	String catName = mysqlRs.getString("pn_topicname");
	String catText = mysqlRs.getString("pn_topictext");
	query2 = "insert into pmc_story_category (story_category_id, story_category_name, story_category_active_yn, category_text) values (?, ?, ?, ?)";
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	pst.setInt(1, catId);
	pst.setString(2, catName);
	pst.setString(3, "y");
	pst.setString(4, catText);
	pst.executeUpdate();
	pst.close();
	pst = null;
}
} catch (Exception e) {
e.printStackTrace();
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;

try {
mysqlSt = mysql_conn.createStatement();
query = "select * from nuke_stories";
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	int storyId = mysqlRs.getInt("pn_sid");
	String title = mysqlRs.getString("pn_title");
	String tmpdate = mysqlRs.getString("pn_time");
	SimpleDateFormat FORMAT = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	java.sql.Timestamp theTime = new java.sql.Timestamp(FORMAT.parse(tmpdate).getTime());
	String theText = mysqlRs.getString("pn_hometext") + mysqlRs.getString("pn_bodytext");
	String newText = "";
	theText = theText.replaceAll("<P>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<BR>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br />", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<BR/>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br/>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<p>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	newText = com.verilion.utility.TextUtils.StripHtml(theText);
	newText = newText.replaceAll("XYXYXYXYXYXYXYXYXYXYXYYX", "<br />");
	int number_comments = mysqlRs.getInt("pn_comments");
	int story_category_id = mysqlRs.getInt("pn_topic");
	String posted_by = mysqlRs.getString("pn_informant");
	int counter = mysqlRs.getInt("pn_counter");
	%>
	**** trying story <%=storyId%> with date of <%=theTime.toString()%><br />
	<%
	query2 = "insert into pmc_stories (story_id, title, datetime, story, number_comments, counter, story_topic_id, posted_by) values (?, ?, ?, ?, ?, ?, ?, ?)";
	try {
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	pst.setInt(1, storyId);
	pst.setString(2, title);
	pst.setTimestamp(3, theTime);
	pst.setString(4, newText);
	pst.setInt(5, number_comments);
	pst.setInt(6, counter);
	pst.setInt(7, story_category_id);
	pst.setString(8, posted_by);
	pst.executeUpdate();
	pst.close();
	pst = null;
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println(e.toString());
		System.out.println("Error: *****************************************************************");
	}
}
} catch (Exception e) {
e.printStackTrace();
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;

try{
mysqlSt = mysql_conn.createStatement();
query = "select * from nuke_comments";
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	int comment_id = mysqlRs.getInt("pn_tid");
	int storyId = mysqlRs.getInt("pn_sid");
	String tmpdate = mysqlRs.getString("pn_date");
	SimpleDateFormat FORMAT = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	java.sql.Timestamp theTime = new java.sql.Timestamp(FORMAT.parse(tmpdate).getTime());
	String username = mysqlRs.getString("pn_name");
	String subject = mysqlRs.getString("pn_subject");
	String theText = mysqlRs.getString("pn_comment");
	String newText = "";
	theText = theText.replaceAll("<P>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<BR>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br />", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<BR/>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br/>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<p>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	newText = com.verilion.utility.TextUtils.StripHtml(theText);
	newText = newText.replaceAll("XYXYXYXYXYXYXYXYXYXYXYYX", "<br />");
	query2 = "insert into pmc_stories_comments (comment_id, username, story_id, datetime, subject, story_comment) values (?, ?, ?, ?, ?, ?)";
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	pst.setInt(1, comment_id);
	pst.setString(2, username);
	pst.setInt(3, storyId);
	pst.setTimestamp(4, theTime);
	pst.setString(5, subject);
	pst.setString(6, newText);
	pst.executeUpdate();
	pst.close();
	pst = null;
}
} catch (Exception e) {
e.printStackTrace();
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;

try{
mysqlSt = mysql_conn.createStatement();
query = "select * from nuke_links_links";
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	int cat_id = mysqlRs.getInt("pn_cat_id");
	String title = mysqlRs.getString("pn_title");
	String url = mysqlRs.getString("pn_url");
	String description = mysqlRs.getString("pn_description");

	query2 = "insert into links (link_cat_id, url, description, active_yn, title) values (?, ?, ?, ?, ?)";
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	pst.setInt(1, cat_id);
	pst.setString(2, url);
	pst.setString(3, description);
	pst.setString(4, "y");
	pst.setString(5, title);
	pst.executeUpdate();
	pst.close();
	pst = null;
}
} catch (Exception e) {
e.printStackTrace();
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;

// do messages
try{
SimpleDateFormat FORMAT = new SimpleDateFormat("yyyy-MM-dd hh:mm");
mysqlSt = mysql_conn.createStatement();
query = "select * from nuke_priv_msgs";
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	PreparedStatement pst = null;
	int from_user_id = mysqlRs.getInt("pn_from_userid");
	int to_user_id = mysqlRs.getInt("pn_to_userid");
	String timeSent = mysqlRs.getString("pn_msg_time");
	java.sql.Timestamp time_sent = new java.sql.Timestamp(FORMAT.parse(timeSent).getTime());
	String theText = mysqlRs.getString("pn_msg_text");
	String newText = "";
	theText = theText.replaceAll("<P>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<BR>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br />", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<BR/>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<br/>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	theText = theText.replaceAll("<p>", "XYXYXYXYXYXYXYXYXYXYXYYX");
	newText = com.verilion.utility.TextUtils.StripHtml(theText);
	newText = newText.replaceAll("XYXYXYXYXYXYXYXYXYXYXYYX", "<br />");
	String is_read_yn = "y";
	int ckRd = mysqlRs.getInt("pn_read_msg");
	if (ckRd == 1) {
		is_read_yn = "n";
	}
	String subject = mysqlRs.getString("pn_subject");
	
	try {
		query2 = "insert into customer_messages (from_user_id, to_user_id, time_sent, message, is_read_yn, subject) values (?, ?, ?, ?, ?, ?)";
		pst = conn.prepareStatement(query2);
		pst.setInt(1, from_user_id);
		pst.setInt(2, to_user_id);
		pst.setTimestamp(3, time_sent);
		pst.setString(4, newText);
		pst.setString(5, is_read_yn);
		pst.setString(6, subject);
		pst.executeUpdate();
	} catch (Exception e) {
		e.printStackTrace();
	}
	pst.close();
	pst = null;
}
} catch (Exception e) {
e.printStackTrace();
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;
/*
// do faq categories
try{
mysqlSt = mysql_conn.createStatement();
query = "select * from nuke_faqcategories";
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	int category_id = mysqlRs.getInt("pn_id_cat");
	int parent_id = mysqlRs.getInt("pn_parent_id");
	String category_name = mysqlRs.getString("pn_categories");

	query2 = "insert into faq_categories (faq_categories_id, faq_categories_name, parent_id) values (?, ?, ?)";
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	pst.setInt(1, category_id);
	pst.setString(2, category_name);
	pst.setInt(3, parent_id);
	pst.executeUpdate();
	pst.close();
	pst = null;
}
} catch (Exception e) {
e.printStackTrace();
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;

// do faq entries
try{
mysqlSt = mysql_conn.createStatement();
query = "select * from nuke_faqanswer";
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	int faq_id = mysqlRs.getInt("pn_id");
	int category_id = mysqlRs.getInt("pn_id_cat");
	String question = mysqlRs.getString("pn_question");
	String answer = mysqlRs.getString("pn_answer");
	String username = mysqlRs.getString("pn_submittedby");

	query2 = "insert into faq (faq_id, faq_categories_id, question, answer, username) values (?, ?, ?, ?, ?)";
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	pst.setInt(1, faq_id);
	pst.setInt(2, category_id);
	pst.setString(3, question);
	pst.setString(4, answer);
	pst.setString(5, username);
	pst.executeUpdate();
	pst.close();
	pst = null;
}
} catch (Exception e) {
e.printStackTrace();
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;

*/

/*
// do private messages
try{
mysqlSt = mysql_conn.createStatement();
query = "select * from nuke_priv_msgs";
mysqlRs = mysqlSt.executeQuery(query);
while (mysqlRs.next()) {
	int from_id = mysqlRs.getInt("pn_from_userid");
	int to_id = mysqlRs.getInt("pn_to_userid");
	String subject = mysqlRs.getString("pn_subject");
	String message_text = mysqlRs.getString("pn_msg_text");
	String tmpdate = mysqlRs.getString("pn_msg_time");
	SimpleDateFormat FORMAT = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	java.sql.Timestamp theTime = new java.sql.Timestamp(FORMAT.parse(tmpdate).getTime());
	int isRead = mysqlRs.getInt("pn_read_message");

	query2 = "insert into faq (faq_id, faq_categories_id, question, answer, username) values (?, ?, ?, ?, ?)";
	PreparedStatement pst = null;
	pst = conn.prepareStatement(query2);
	pst.setInt(1, faq_id);
	pst.setInt(2, category_id);
	pst.setString(3, question);
	pst.setString(4, answer);
	pst.setString(5, username);
	pst.executeUpdate();
	pst.close();
	pst = null;
}
} catch (Exception e) {
e.printStackTrace();
}
mysqlRs.close();
mysqlRs = null;
mysqlSt.close();
mysqlSt = null;

*/
} catch (Exception e) {
	e.printStackTrace();
}
%>
Done.
</body>
</html>
<%@include file="footer.jsp"%>