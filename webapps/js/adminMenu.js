USETEXTLINKS = 1
STARTALLOPEN = 0
USEFRAMES = 0
USEICONS = 1
WRAPTEXT = 1
PRESERVESTATE = 1
HIGHLIGHT = 1
HIGHLIGHT_COLOR = 'white'
HIGHLIGHT_BG = '#333333'
ICONPATH = '/js/'
foldersTree = gFld("<b>Administration</b>", "/servlet/com.verilion.display.html.SecurePage?page=Administration")
foldersTree.treeID = "t2"
aux2 = insFld(foldersTree, gFld("Customers", "javascript:undefined"))
insDoc(aux2, gLnk("S", "Search Customers", "/SearchCustomers/searchcustomers/1/content.admin"))
insDoc(aux2, gLnk("S", "Add Customer", "/AddCustomer/addcustomer/1/content.admin"))
aux2 = insFld(foldersTree, gFld("Manage Menu", "/servlet/com.verilion.display.html.admin.ManageMenuChoose?page=ManageMenuChoose"))
aux2 = insFld(foldersTree, gFld("Manage Modules", "/servlet/com.verilion.display.html.admin.ManageModulesChoose?page=ManageModulesChoose"))
aux2 = insFld(foldersTree, gFld("News", "javascript:undefined"))
insDoc(aux2, gLnk("S", "News Categories", "/servlet/com.verilion.display.html.admin.NewsCategoriesChoice?page=NewsCategoriesChoice"))
insDoc(aux2, gLnk("S", "News Items", "/servlet/com.verilion.display.html.admin.NewsItemChoice?page=NewsItemChoice"))
insDoc(aux2, gLnk("S", "Add News Item", "/servlet/com.verilion.display.html.admin.NewsItemDetail?page=NewsItemDetail&news_id=-1"))
aux2 = insFld(foldersTree, gFld("Packages", "javascript:undefined"))
insDoc(aux2, gLnk("S", "Manage Packages", "/servlet/com.verilion.display.html.admin.EditPackages?page=EditPackages"))
insDoc(aux2, gLnk("S", "Add Package", "/servlet/com.verilion.display.html.SecurePage?page=AddPackage"))
aux2 = insFld(foldersTree, gFld("Pages", "javascript:undefined"))
insDoc(aux2, gLnk("S", "Edit Pages", "/servlet/com.verilion.display.html.admin.EditPageChoose?page=EditPageChoose"))
insDoc(aux2, gLnk("S", "Add Page", "/servlet/com.verilion.display.html.admin.AddPage?page=AddPage"))
insDoc(aux2, gLnk("S", "Edit Archive Pages", "/servlet/com.verilion.display.html.admin.EditArchivePageChoose?page=EditArchivePageChoose"))
insDoc(aux2, gLnk("S", "Add Archive Page", "/servlet/com.verilion.display.html.admin.AddArchivePage?page=AddArchivePage"))
aux2 = insFld(foldersTree, gFld("Templates", "javascript:undefined"))
insDoc(aux2, gLnk("S", "Manage Templates", "/servlet/com.verilion.display.html.admin.TemplateChoose?page=TemplateChoose"))
insDoc(aux2, gLnk("S", "Add Template", "/servlet/com.verilion.display.html.SecurePage?page=AddTemplate"))
aux2 = insFld(foldersTree, gFld("Quotations", "javascript:undefined"))
insDoc(aux2, gLnk("S", "Manage Quotations", "/servlet/com.verilion.display.html.admin.EditQuotesChoose?page=EditQuotesChoose"))
insDoc(aux2, gLnk("S", "Add Quotation", "/servlet/com.verilion.display.html.SecurePage?page=AddQuote"))
aux2 = insFld(foldersTree, gFld("Preferences", "javascript:undefined"))
insDoc(aux2, gLnk("S", "System Prefs", "/servlet/com.verilion.display.html.admin.SysPref?page=SysPref"))
insDoc(aux2, gLnk("S", "Admin Menu", "/AdminMenuItemChoose/adminmenu/1/content.admin"))
aux2 = insFld(foldersTree, gFld("Logout", "/Logout/logout/1/content.do?logout=true"))
aux2 = insFld(foldersTree, gFld("Public Site", "/Home/display/1/content.do"))
