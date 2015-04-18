var NoOffFirstLineMenus=5;			// Number of first level items
var LowBgColor='white';			// Background color when mouse is not over
var LowSubBgColor='white';			// Background color when mouse is not over on subs
var HighBgColor='black';			// Background color when mouse is over
var HighSubBgColor='black';			// Background color when mouse is over on subs
var FontLowColor='#42696D';			// Font color when mouse is not over
var FontSubLowColor='#42696D';			// Font color subs when mouse is not over
var FontHighColor='white';			// Font color when mouse is over
var FontSubHighColor='white';			// Font color subs when mouse is over
var BorderColor='#42696D';			// Border color
var BorderSubColor='#42696D';			// Border color for subs
var BorderWidth=1;				// Border width
var BorderBtwnElmnts=1;			// Border between elements 1 or 0
var FontFamily="verdana,arial,comic sans ms,technical"	// Font family menu items
var FontSize=8;				// Font size menu items
var FontBold=0;				// Bold menu items 1 or 0
var FontItalic=0;				// Italic menu items 1 or 0
var MenuTextCentered='left';			// Item text position 'left', 'center' or 'right'
var MenuCentered='left';			// Menu horizontal position 'left', 'center' or 'right'
var MenuVerticalCentered='top';		// Menu vertical position 'top', 'middle','bottom' or static
var ChildOverlap=0;				// horizontal overlap child/ parent
var ChildVerticalOverlap=0;			// vertical overlap child/ parent
var StartTop=0;				// Menu offset x coordinate
var StartLeft=0;				// Menu offset y coordinate
var VerCorrect=0;				// Multiple frames y correction
var HorCorrect=0;				// Multiple frames x correction
var LeftPaddng=3;				// Left padding
var TopPaddng=2;				// Top padding
var FirstLineHorizontal=1;			// SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
var MenuFramesVertical=0;			// Frames in cols or rows 1 or 0
var DissapearDelay=500;			// delay before menu folds in
var TakeOverBgColor=1;			// Menu frame takes over background color subitem frame
var FirstLineFrame='';			// Frame where first level appears
var SecLineFrame='';			// Frame where sub levels appear
var DocTargetFrame='';			// Frame where target documents appear
var TargetLoc='MenuPos';				// span id for relative positioning
var HideTop=0;				// Hide first level when loading new document 1 or 0
var MenuWrap=1;				// enables/ disables menu wrap 1 or 0
var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
var UnfoldsOnClick=1;			// Level 1 unfolds onclick/ onmouseover
var WebMasterCheck=0;			// menu tree checking on or off 1 or 0
var ShowArrow=1;				// Uses arrow gifs when 1
var KeepHilite=1;				// Keep selected path highligthed
var Arrws=['/js/tri.gif',5,10,'/js/tridown.gif',10,5,'/js/trileft.gif',5,10];	// Arrow source, width and height

function BeforeStart(){return}
function AfterBuild(){return}
function BeforeFirstOpen(){return}
function AfterCloseAll(){return}


// Menu tree
//	MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
//	For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"

Menu1=new Array("Home","/content/PageDb/Home","",0,18,100);

Menu2=new Array("Hosting","/content/PageDb/Entry","",6);
Menu2_1=new Array("Entry","/content/PageDb/Entry","",0,18,100);
Menu2_2=new Array("Basic","/content/PageDb/Basic","",0);
Menu2_3=new Array("Standard","/content/PageDb/Standard","",0);
Menu2_4=new Array("Advanced","/content/PageDb/Advanced","",0);
Menu2_5=new Array("Custom","/content/PageDb/Custom","",0);
Menu2_6=new Array("Sign Up!","https://www3.verilion.com/servlet/com.verilion.display.html.JoinSite?page=JoinSite","",0);	

Menu3=new Array("Support","/content/PageDb/Support","",3);
Menu3_1=new Array("Support","/content/PageDb/Support","",0,18,120);
Menu3_2=new Array("System Status","/content/PageDb/Status","",0);
Menu3_3=new Array("Support Request","/content/PageDb/SupportRequest","",0);

Menu4=new Array("Development","/content/PageDb/Applications","",2);
Menu4_1=new Array("Applications","/content/PageDb/Applications","",0,18,120);
Menu4_2=new Array("Technologies","/content/PageDb/Technologies","",0);

Menu5=new Array("About","/content/PageDb/About","",3);
Menu5_1=new Array("About Us","/content/PageDb/About","",0,18,100);
Menu5_2=new Array("Security","/content/PageDb/Security","",0);
Menu5_3=new Array("Privacy","/content/PageDb/Privacy","",0);
