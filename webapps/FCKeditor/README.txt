-------------------------------------------------
	FCKeditor - JSP Integration Pack ver 2.1
-------------------------------------------------


---------------
Contents:
---------------

1 - Preface
2 - Installation
3 - Usage
4 - Building
5 - Future plans
6 - Further information and support

--------------------
1 - Preface
--------------------

This is the JSP Integration Pack for using FCKeditor inside a java server page without
the complexity of using a Java scriptlets or the javascript api.
I hope you find it usefull.
This package contains just the integration library. To setup a full working environment
you need to download the latest version of FCKEditor
(http://sourceforge.net/project/showfiles.php?group_id=75348&package_id=75845)


--------------------
2 - Installation
--------------------

Installing FCKeditor in a JSP environment is quite easy:
 - Unzip the Java Integration Library in a directory named "FCKeditor"
 - Unzip the content of the FCKEditor release of your choise inside the "FCKeditor\web" folder
 - then you have to create in tomcat (or any servlet container) a new context named "FCKeditor"
 	that points to the previously created "FCKeditor\web" folder
 - point your browser to http://domainName.ext/FCKeditor/_samples/default.jsp for the list of
 	the samples



--------------------
3 - Usage
--------------------

Take a look at the test files and in the javadoc api provided in the distribution.
Anyway, for the lazy ones, here is a simple example

First put this taglib definiton at the top of the JSP page
<%@ taglib uri="http://fckeditor.net/tags-fckeditor" prefix="FCK" %>

then the tag:

	<FCK:editor
		id="EditorAccessibility"	//Unique name of the editor
		width="80%"			//Width
		height="120"			//Height
		toolbarSet="Accessibility"	//Toolbar name
	>This is another test. <BR><B>The "Second" row.</B></FCK:editor>

A more advance example, that show how to use the inner tags to overrides any of the settings specified in
the config.js file

	<FCK:editor id="EditorDefault" basePath="/FCKeditor/"
		styleNames=";Style 1;Style 2; Style 3" 
		fontNames=";Arial;Courier New;Times New Roman;Verdana" >
		This is some <B>sample text</B>.
	</FCK:editor>


--------------------
4 - Building
--------------------

Inside the files there is the source files for the tags (/src) and the ant build file (build.xml)

The ant build file provides the following tasks:
 - all: Clean build and dist directories, then compile
 - clean: Delete old build and dist directories
 - compile: Compile Java sources
 - dist: Create binary distribution
 - javadoc: Create Javadoc API documentation
 - release: Create Release Distribution

Plus some Tomcat managing tasks (to make this tasks work you need to copy inside the "web" folder the FCKeditor package):
 - install: Create a web application pointing to the build directory
 - reload: Recompiles and reload the web application
 - remove: remove the web application

To start building the class you first need to modify the "catalina.home" property inside the build.xml,
then type "ant dist" to compile, create the javadoc API description and generate the jar library to be copied in the WEB-INF.

Or more easily, type "ant install" after setting the right username and password for the tomcat manager application.


--------------------
5 - Future plans
--------------------

 * Integrate with Struts (so that FCKeditor can retrive and pass informations from Form Beans)



--------------------
6 - Further informations and support
--------------------

For further informations refers to http://www.fckeditor.net/
For support specific with this JSP integration taglib send an email to simo@users.sourceforge.net


--------------------
7 - History
--------------------

2.1 - 2005/03/29
 
 - Changed naming of the package
 
 TAGLIB:
 - Made the taglib similar to the .NET custom tag, so: 
 		* Added all attributes available for the .NET integration package
 		* Removed the "config" tag
 		
 CONNECTOR:
 - Added "debug" init-parameted for the connector
 
 SAMPLE:
 - Implemented all sample files provided by the javascript version
 - Samples now work out-of-the-box, since the connector configuration is set inside the tag
 


2.0b2 (1.0 beta 2 for 2.0b2) - 2004/11/03

 - Fixes the following bugs:
   [ 1058945 ] user-agent parsing exception
   [ 1032971 ] Browserversion of Mozilla: StringIndexOutOfBoundsException

2.0b1 (1.0 beta 1 for 2.0b2) - 2004/09/13

 - New stand alone package
 - Fixes the following bugs:
   [ 970740 ] ConnectorServlet not working
   [ 991489 ] getNameWithoutExtension
   [ 1025909 ] [Firefox 0.9.2] Resource browser works partially
 - Uploaded files and images are now shown with a absolute path (starting from the root of the site) and not as relatives from the editor directory


1.0 - 2004/05/09

	Available just with the 1.6 release of FCKeditor.
	This is the 1.x compatible taglib