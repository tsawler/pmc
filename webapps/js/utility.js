// Copyright © 2000 by Apple Computer, Inc., All Rights Reserved.
//
// You may incorporate this Apple sample code into your own code
// without restriction. This Apple sample code has been provided "AS IS"
// and the responsibility for its operation is yours. You may redistribute
// this code, but you are not permitted to redistribute it as
// "Apple sample code" after having made changes.
//
// ************************
// layer utility routines *
// ************************

function getStyleObject(objectId) {
    // cross-browser function to get an object's style object given its id
    if(document.getElementById && document.getElementById(objectId)) {
	// W3C DOM
	return document.getElementById(objectId).style;
    } else if (document.all && document.all(objectId)) {
	// MSIE 4 DOM
	return document.all(objectId).style;
    } else if (document.layers && document.layers[objectId]) {
	// NN 4 DOM.. note: this won't find nested layers
	return document.layers[objectId];
    } else {
	return false;
    }
} // getStyleObject

function changeObjectVisibility(objectId, newVisibility) {
    // get a reference to the cross-browser style object and make sure the object exists
    var styleObject = getStyleObject(objectId);
    if(styleObject) {
	styleObject.visibility = newVisibility;
	return true;
    } else {
	// we couldn't find the object, so we can't change its visibility
	return false;
    }
} // changeObjectVisibility

function moveObject(objectId, newXCoordinate, newYCoordinate) {
    // get a reference to the cross-browser style object and make sure the object exists
    var styleObject = getStyleObject(objectId);
    if(styleObject) {
	styleObject.left = newXCoordinate;
	styleObject.top = newYCoordinate;
	return true;
    } else {
	// we couldn't find the object, so we can't very well move it
	return false;
    }
} // moveObject


function toggle(obj) {
var sibling;
if(obj.nextSibling.nodeType==3) {
    sibling=obj.nextSibling.nextSibling;
    }
else {
    sibling=obj.nextSibling;
    }
sibling.style.display=(sibling.style.display=='none')? 'block' : 'none';
}

function createCookie(name,value,days)
{
	if (days)
	{
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)
	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name)
{
	createCookie(name,"",-1);
}

function setMenu(menuArray) {
	var x = readCookie('menuCookie')
	if (x)
	{
		theElement=document.getElementById(x);
		toggle(theElement);
		for (i = 0; i < menuArray.length; i++) {
			if (menuArray[i] != x) {
			  theElement = document.getElementById(menuArray[i]);
				toggle(theElement);
			}
		}
		
	} else {
		theElement=document.getElementById('Customers');
		toggle(theElement);
		for (i = 0; i < menuArray.length; i++) {
			if (menuArray[i] != 'Customers'){
				theElement = document.getElementById(menuArray[i]);
				toggle(document.getElementById(menuArray[i]));
			}
		}
	}
}

function setMenuCookie(obj) {
	eraseCookie('menuCookie');
	createCookie('menuCookie',obj,0);
	toggle(obj);
}
