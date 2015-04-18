/*
Copyright (c) 2005 Tim Taylor Consulting <http://tool-man.org/>

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
*/

var ToolMan = {
	events : function() {
		if (!ToolMan._eventsFactory) throw "ToolMan Events module isn't loaded";
		return ToolMan._eventsFactory
	},

	css : function() {
		if (!ToolMan._cssFactory) throw "ToolMan CSS module isn't loaded";
		return ToolMan._cssFactory
	},

	coordinates : function() {
		if (!ToolMan._coordinatesFactory) throw "ToolMan Coordinates module isn't loaded";
		return ToolMan._coordinatesFactory
	},

	drag : function() {
		if (!ToolMan._dragFactory) throw "ToolMan Drag module isn't loaded";
		return ToolMan._dragFactory
	},

	dragsort : function() {
		if (!ToolMan._dragsortFactory) throw "ToolMan DragSort module isn't loaded";
		return ToolMan._dragsortFactory
	},

	helpers : function() {
		return ToolMan._helpers
	},

	cookies : function() {
		if (!ToolMan._cookieOven) throw "ToolMan Cookie module isn't loaded";
		return ToolMan._cookieOven
	},

	junkdrawer : function() {
		return ToolMan._junkdrawer
	}

}

ToolMan._helpers = {
	map : function(array, func) {
		for (var i = 0, n = array.length; i < n; i++) func(array[i])
	},

	nextItem : function(item, nodeName) {
		if (item == null) return
		var next = item.nextSibling
		while (next != null) {
			if (next.nodeName == nodeName) return next
			next = next.nextSibling
		}
		return null
	},

	previousItem : function(item, nodeName) {
		var previous = item.previousSibling
		while (previous != null) {
			if (previous.nodeName == nodeName) return previous
			previous = previous.previousSibling
		}
		return null
	},

	moveBefore : function(item1, item2) {
		var parent = item1.parentNode
		parent.removeChild(item1)
		parent.insertBefore(item1, item2)
	},

	moveAfter : function(item1, item2) {
		var parent = item1.parentNode
		parent.removeChild(item1)
		parent.insertBefore(item1, item2 ? item2.nextSibling : null)
	}
}

/** 
 * scripts without a proper home
 *
 * stuff here is subject to change unapologetically and without warning
 */
ToolMan._junkdrawer = {
	serializeList : function(list) {
		var items = list.getElementsByTagName("li")
		var array = new Array()
		for (var i = 0, n = items.length; i < n; i++) {
			var item = items[i]

			array.push(ToolMan.junkdrawer()._identifier(item))
		}
		return array.join('|')
	},

	inspectListOrder : function(id) {
		alert(ToolMan.junkdrawer().serializeList(document.getElementById(id)))
	},

	restoreListOrder : function(listID) {
		var list = document.getElementById(listID)
		if (list == null) return

		var cookie = ToolMan.cookies().get("list-" + listID)
		if (!cookie) return;

		var IDs = cookie.split('|')
		var items = ToolMan.junkdrawer()._itemsByID(list)

		for (var i = 0, n = IDs.length; i < n; i++) {
			var itemID = IDs[i]
			if (itemID in items) {
				var item = items[itemID]
				list.removeChild(item)
				list.insertBefore(item, null)
			}
		}
	},

	_identifier : function(item) {
		var trim = ToolMan.junkdrawer().trim
		var identifier

		identifier = trim(item.getAttribute("id"))
		if (identifier != null && identifier.length > 0) return identifier;
		
		identifier = trim(item.getAttribute("itemID"))
		if (identifier != null && identifier.length > 0) return identifier;
		
		// FIXME: strip out special chars or make this an MD5 hash or something
		return trim(item.innerHTML)
	},

	_itemsByID : function(list) {
		var array = new Array()
		var items = list.getElementsByTagName('li')
		for (var i = 0, n = items.length; i < n; i++) {
			var item = items[i]
			array[ToolMan.junkdrawer()._identifier(item)] = item
		}
		return array
	},

	trim : function(text) {
		if (text == null) return null
		return text.replace(/^(\s+)?(.*\S)(\s+)?$/, '$2')
	}
}
/* Copyright (c) 2005 Tim Taylor Consulting (see LICENSE.txt) */

ToolMan._eventsFactory = {
	fix : function(event) {
		if (!event) event = window.event

		if (event.target) {
			if (event.target.nodeType == 3) event.target = event.target.parentNode
		} else if (event.srcElement) {
			event.target = event.srcElement
		}

		return event
	},

	register : function(element, type, func) {
		if (element.addEventListener) {
			element.addEventListener(type, func, false)
		} else if (element.attachEvent) {
			if (!element._listeners) element._listeners = new Array()
			if (!element._listeners[type]) element._listeners[type] = new Array()
			var workaroundFunc = function() {
				func.apply(element, new Array())
			}
			element._listeners[type][func] = workaroundFunc
			element.attachEvent('on' + type, workaroundFunc)
		}
	},

	unregister : function(element, type, func) {
		if (element.removeEventListener) {
			element.removeEventListener(type, func, false)
		} else if (element.detachEvent) {
			if (element._listeners 
					&& element._listeners[type] 
					&& element._listeners[type][func]) {

				element.detachEvent('on' + type, 
						element._listeners[type][func])
			}
		}
	}
}
/* Copyright (c) 2005 Tim Taylor Consulting (see LICENSE.txt) */

// TODO: write unit tests
ToolMan._cssFactory = {
	readStyle : function(element, property) {
		if (element.style[property]) {
			return element.style[property]
		} else if (element.currentStyle) {
			return element.currentStyle[property]
		} else if (document.defaultView && document.defaultView.getComputedStyle) {
			var style = document.defaultView.getComputedStyle(element, null)
			return style.getPropertyValue(property)
		} else {
			return null
		}
	}
}
/* Copyright (c) 2005 Tim Taylor Consulting (see LICENSE.txt) */

/* FIXME: assumes position styles are specified in 'px' */

ToolMan._coordinatesFactory = {

	create : function(x, y) {
		// FIXME: Safari won't parse 'throw' and aborts trying to do anything with this file
		//if (isNaN(x) || isNaN(y)) throw "invalid x,y: " + x + "," + y
		return new _ToolManCoordinate(this, x, y)
	},

	origin : function() {
		return this.create(0, 0)
	},

	/*
	 * FIXME: Safari 1.2, returns (0,0) on absolutely positioned elements
	 */
	topLeftPosition : function(element) {
		var left = parseInt(ToolMan.css().readStyle(element, "left"))
		var left = isNaN(left) ? 0 : left
		var top = parseInt(ToolMan.css().readStyle(element, "top"))
		var top = isNaN(top) ? 0 : top

		return this.create(left, top)
	},

	bottomRightPosition : function(element) {
		return this.topLeftPosition(element).plus(this._size(element))
	},

	topLeftOffset : function(element) {
		var offset = this._offset(element) 

		var parent = element.offsetParent
		while (parent) {
			offset = offset.plus(this._offset(parent))
			parent = parent.offsetParent
		}
		return offset
	},

	bottomRightOffset : function(element) {
		return this.topLeftOffset(element).plus(
				this.create(element.offsetWidth, element.offsetHeight))
	},

	scrollOffset : function() {
		if (window.pageXOffset) {
			return this.create(window.pageXOffset, window.pageYOffset)
		} else if (document.documentElement) {
			return this.create(
					document.body.scrollLeft + document.documentElement.scrollLeft, 
					document.body.scrollTop + document.documentElement.scrollTop)
		} else if (document.body.scrollLeft >= 0) {
			return this.create(document.body.scrollLeft, document.body.scrollTop)
		} else {
			return this.create(0, 0)
		}
	},

	clientSize : function() {
		if (window.innerHeight >= 0) {
			return this.create(window.innerWidth, window.innerHeight)
		} else if (document.documentElement) {
			return this.create(document.documentElement.clientWidth,
					document.documentElement.clientHeight)
		} else if (document.body.clientHeight >= 0) {
			return this.create(document.body.clientWidth,
					document.body.clientHeight)
		} else {
			return this.create(0, 0)
		}
	},

	/**
	 * mouse coordinate relative to the window (technically the
	 * browser client area) i.e. the part showing your page
	 *
	 * NOTE: in Safari the coordinate is relative to the document
	 */
	mousePosition : function(event) {
		event = ToolMan.events().fix(event)
		return this.create(event.clientX, event.clientY)
	},

	/**
	 * mouse coordinate relative to the document
	 */
	mouseOffset : function(event) {
		event = ToolMan.events().fix(event)
		if (event.pageX >= 0 || event.pageX < 0) {
			return this.create(event.pageX, event.pageY)
		} else if (event.clientX >= 0 || event.clientX < 0) {
			return this.mousePosition(event).plus(this.scrollOffset())
		}
	},

	_size : function(element) {
	/* TODO: move to a Dimension class */
		return this.create(element.offsetWidth, element.offsetHeight)
	},

	_offset : function(element) {
		return this.create(element.offsetLeft, element.offsetTop)
	}
}

function _ToolManCoordinate(factory, x, y) {
	this.factory = factory
	this.x = isNaN(x) ? 0 : x
	this.y = isNaN(y) ? 0 : y
}

_ToolManCoordinate.prototype = {
	toString : function() {
		return "(" + this.x + "," + this.y + ")"
	},

	plus : function(that) {
		return this.factory.create(this.x + that.x, this.y + that.y)
	},

	minus : function(that) {
		return this.factory.create(this.x - that.x, this.y - that.y)
	},

	min : function(that) {
		return this.factory.create(
				Math.min(this.x , that.x), Math.min(this.y , that.y))
	},

	max : function(that) {
		return this.factory.create(
				Math.max(this.x , that.x), Math.max(this.y , that.y))
	},

	constrainTo : function (one, two) {
		var min = one.min(two)
		var max = one.max(two)

		return this.max(min).min(max)
	},

	distance : function (that) {
		return Math.sqrt(Math.pow(this.x - that.x, 2) + Math.pow(this.y - that.y, 2))
	},

	reposition : function(element) {
		element.style["top"] = this.y + "px"
		element.style["left"] = this.x + "px"
	}
}
/* Copyright (c) 2005 Tim Taylor Consulting (see LICENSE.txt) */

ToolMan._dragFactory = {
	createSimpleGroup : function(element, handle) {
		handle = handle ? handle : element
		var group = this.createGroup(element)
		group.setHandle(handle)
		group.transparentDrag()
		group.onTopWhileDragging()
		return group
	},

	createGroup : function(element) {
		var group = new _ToolManDragGroup(this, element)

		var position = ToolMan.css().readStyle(element, 'position')
		if (position == 'static') {
			element.style["position"] = 'relative'
		} else if (position == 'absolute') {
			/* for Safari 1.2 */
			ToolMan.coordinates().topLeftOffset(element).reposition(element)
		}

		// TODO: only if ToolMan.isDebugging()
		group.register('draginit', this._showDragEventStatus)
		group.register('dragmove', this._showDragEventStatus)
		group.register('dragend', this._showDragEventStatus)

		return group
	},

	_showDragEventStatus : function(dragEvent) {
		window.status = dragEvent.toString()
	},

	constraints : function() {
		return this._constraintFactory
	},

	_createEvent : function(type, event, group) {
		return new _ToolManDragEvent(type, event, group)
	}
}

function _ToolManDragGroup(factory, element) {
	this.factory = factory
	this.element = element
	this._handle = null
	this._thresholdDistance = 0
	this._transforms = new Array()
	// TODO: refactor into a helper object, move into events.js
	this._listeners = new Array()
	this._listeners['draginit'] = new Array()
	this._listeners['dragstart'] = new Array()
	this._listeners['dragmove'] = new Array()
	this._listeners['dragend'] = new Array()
}

_ToolManDragGroup.prototype = {
	/*
	 * TODO:
	 *   - unregister(type, func)
	 *   - move custom event listener stuff into Event library
	 *   - keyboard nudging of "selected" group
	 */

	setHandle : function(handle) {
		var events = ToolMan.events()

		handle.toolManDragGroup = this
		events.register(handle, 'mousedown', this._dragInit)
		handle.onmousedown = function() { return false }

		if (this.element != handle)
			events.unregister(this.element, 'mousedown', this._dragInit)
	},

	register : function(type, func) {
		this._listeners[type].push(func)
	},

	addTransform : function(transformFunc) {
		this._transforms.push(transformFunc)
	},

	verticalOnly : function() {
		this.addTransform(this.factory.constraints().vertical())
	},

	horizontalOnly : function() {
		this.addTransform(this.factory.constraints().horizontal())
	},

	setThreshold : function(thresholdDistance) {
		this._thresholdDistance = thresholdDistance
	},

	transparentDrag : function(opacity) {
		var opacity = typeof(opacity) != "undefined" ? opacity : 0.75;
		var originalOpacity = ToolMan.css().readStyle(this.element, "opacity")

		this.register('dragstart', function(dragEvent) {
			var element = dragEvent.group.element
			element.style.opacity = opacity
			element.style.filter = 'alpha(opacity=' + (opacity * 100) + ')'
		})
		this.register('dragend', function(dragEvent) {
			var element = dragEvent.group.element
			element.style.opacity = originalOpacity
			element.style.filter = 'alpha(opacity=100)'
		})
	},

	onTopWhileDragging : function(zIndex) {
		var zIndex = typeof(zIndex) != "undefined" ? zIndex : 100000;
		var originalZIndex = ToolMan.css().readStyle(this.element, "z-index")

		this.register('dragstart', function(dragEvent) {
			dragEvent.group.element.style.zIndex = zIndex
		})
		this.register('dragend', function(dragEvent) {
			dragEvent.group.element.style.zIndex = originalZIndex
		})
	},

	_dragInit : function(event) {
		event = ToolMan.events().fix(event)
		var group = document.toolManDragGroup = this.toolManDragGroup
		var dragEvent = group.factory._createEvent('draginit', event, group)

		group._isThresholdExceeded = false
		group._initialMouseOffset = dragEvent.mouseOffset
		group._grabOffset = dragEvent.mouseOffset.minus(dragEvent.topLeftOffset)
		ToolMan.events().register(document, 'mousemove', group._drag)
		document.onmousemove = function() { return false }
		ToolMan.events().register(document, 'mouseup', group._dragEnd)

		group._notifyListeners(dragEvent)
	},

	_drag : function(event) {
		event = ToolMan.events().fix(event)
		var coordinates = ToolMan.coordinates()
		var group = this.toolManDragGroup
		if (!group) return
		var dragEvent = group.factory._createEvent('dragmove', event, group)

		var newTopLeftOffset = dragEvent.mouseOffset.minus(group._grabOffset)

		// TODO: replace with DragThreshold object
		if (!group._isThresholdExceeded) {
			var distance = 
					dragEvent.mouseOffset.distance(group._initialMouseOffset)
			if (distance < group._thresholdDistance) return
			group._isThresholdExceeded = true
			group._notifyListeners(
					group.factory._createEvent('dragstart', event, group))
		}

		for (i in group._transforms) {
			var transform = group._transforms[i]
			newTopLeftOffset = transform(newTopLeftOffset, dragEvent)
		}

		var dragDelta = newTopLeftOffset.minus(dragEvent.topLeftOffset)
		var newTopLeftPosition = dragEvent.topLeftPosition.plus(dragDelta)
		newTopLeftPosition.reposition(group.element)
		dragEvent.transformedMouseOffset = newTopLeftOffset.plus(group._grabOffset)

		group._notifyListeners(dragEvent)

		var errorDelta = newTopLeftOffset.minus(coordinates.topLeftOffset(group.element))
		if (errorDelta.x != 0 || errorDelta.y != 0) {
			coordinates.topLeftPosition(group.element).plus(errorDelta).reposition(group.element)
		}
	},

	_dragEnd : function(event) {
		event = ToolMan.events().fix(event)
		var group = this.toolManDragGroup
		var dragEvent = group.factory._createEvent('dragend', event, group)

		group._notifyListeners(dragEvent)

		this.toolManDragGroup = null
		ToolMan.events().unregister(document, 'mousemove', group._drag)
		document.onmousemove = null
		ToolMan.events().unregister(document, 'mouseup', group._dragEnd)
	},

	_notifyListeners : function(dragEvent) {
		var listeners = this._listeners[dragEvent.type]
		for (i in listeners) {
			listeners[i](dragEvent)
		}
	}
}

function _ToolManDragEvent(type, event, group) {
	this.type = type
	this.group = group
	this.mousePosition = ToolMan.coordinates().mousePosition(event)
	this.mouseOffset = ToolMan.coordinates().mouseOffset(event)
	this.transformedMouseOffset = this.mouseOffset
	this.topLeftPosition = ToolMan.coordinates().topLeftPosition(group.element)
	this.topLeftOffset = ToolMan.coordinates().topLeftOffset(group.element)
}

_ToolManDragEvent.prototype = {
	toString : function() {
		return "mouse: " + this.mousePosition + this.mouseOffset + "    " +
				"xmouse: " + this.transformedMouseOffset + "    " +
				"left,top: " + this.topLeftPosition + this.topLeftOffset
	}
}

ToolMan._dragFactory._constraintFactory = {
	vertical : function() {
		return function(coordinate, dragEvent) {
			var x = dragEvent.topLeftOffset.x
			return coordinate.x != x
					? coordinate.factory.create(x, coordinate.y) 
					: coordinate
		}
	},

	horizontal : function() {
		return function(coordinate, dragEvent) {
			var y = dragEvent.topLeftOffset.y
			return coordinate.y != y
					? coordinate.factory.create(coordinate.x, y) 
					: coordinate
		}
	}
}
/* Copyright (c) 2005 Tim Taylor Consulting (see LICENSE.txt) */

ToolMan._dragsortFactory = {
	makeSortable : function(item) {
		var group = ToolMan.drag().createSimpleGroup(item)

		group.register('dragstart', this._onDragStart)
		group.register('dragmove', this._onDragMove)
		group.register('dragend', this._onDragEnd)

		return group
	},

	/** 
	 * Iterates over a list's items, making them sortable, applying
	 * optional functions to each item.
	 *
	 * example: makeListSortable(myList, myFunc1, myFunc2, ... , myFuncN)
	 */
	makeListSortable : function(list) {
		var helpers = ToolMan.helpers()
		var coordinates = ToolMan.coordinates()
		var items = list.getElementsByTagName("li")

		helpers.map(items, function(item) {
			var dragGroup = dragsort.makeSortable(item)
			dragGroup.setThreshold(4)
			var min, max
			dragGroup.addTransform(function(coordinate, dragEvent) {
				return coordinate.constrainTo(min, max)
			})
			dragGroup.register('dragstart', function() {
				var items = list.getElementsByTagName("li")
				min = max = coordinates.topLeftOffset(items[0])
				for (var i = 1, n = items.length; i < n; i++) {
					var offset = coordinates.topLeftOffset(items[i])
					min = min.min(offset)
					max = max.max(offset)
				}
			})
		})
		for (var i = 1, n = arguments.length; i < n; i++)
			helpers.map(items, arguments[i])
	},

	_onDragStart : function(dragEvent) {
	},

	_onDragMove : function(dragEvent) {
		var helpers = ToolMan.helpers()
		var coordinates = ToolMan.coordinates()

		var item = dragEvent.group.element
		var xmouse = dragEvent.transformedMouseOffset
		var moveTo = null

		var previous = helpers.previousItem(item, item.nodeName)
		while (previous != null) {
			var bottomRight = coordinates.bottomRightOffset(previous)
			if (xmouse.y <= bottomRight.y && xmouse.x <= bottomRight.x) {
				moveTo = previous
			}
			previous = helpers.previousItem(previous, item.nodeName)
		}
		if (moveTo != null) {
			helpers.moveBefore(item, moveTo)
			return
		}

		var next = helpers.nextItem(item, item.nodeName)
		while (next != null) {
			var topLeft = coordinates.topLeftOffset(next)
			if (topLeft.y <= xmouse.y && topLeft.x <= xmouse.x) {
				moveTo = next
			}
			next = helpers.nextItem(next, item.nodeName)
		}
		if (moveTo != null) {
			helpers.moveBefore(item, helpers.nextItem(moveTo, item.nodeName))
			return
		}
	},

	_onDragEnd : function(dragEvent) {
		ToolMan.coordinates().create(0, 0).reposition(dragEvent.group.element)
	}
}
/* Copyright (c) 2005 Tim Taylor Consulting (see LICENSE.txt)

based on http://www.quirksmode.org/js/cookies.html
*/

ToolMan._cookieOven = {

	set : function(name, value, expirationInDays) {
		if (expirationInDays) {
			var date = new Date()
			date.setTime(date.getTime() + (expirationInDays * 24 * 60 * 60 * 1000))
			var expires = "; expires=" + date.toGMTString()
		} else {
			var expires = ""
		}
		document.cookie = name + "=" + value + expires + "; path=/"
	},

	get : function(name) {
		var namePattern = name + "="
		var cookies = document.cookie.split(';')
		for(var i = 0, n = cookies.length; i < n; i++) {
			var c = cookies[i]
			while (c.charAt(0) == ' ') c = c.substring(1, c.length)
			if (c.indexOf(namePattern) == 0)
				return c.substring(namePattern.length, c.length)
		}
		return null
	},

	eraseCookie : function(name) {
		createCookie(name, "", -1)
	}
}
/*  Prototype JavaScript framework
 *  (c) 2005 Sam Stephenson <sam@conio.net>
 *
 *  Prototype is freely distributable under the terms of an MIT-style license.
 *
 *  For details, see the Prototype web site: http://prototype.conio.net/
 *
/*--------------------------------------------------------------------------*/


//note: this is a stripped down version of prototype, to be used with moo.fx by mad4milk (http://moofx.mad4milk.net).

var Class = {
  create: function() {
    return function() { 
      this.initialize.apply(this, arguments);
    }
  }
}

Object.extend = function(destination, source) {
  for (property in source) {
    destination[property] = source[property];
  }
  return destination;
}

Function.prototype.bind = function(object) {
  var __method = this;
  return function() {
    return __method.apply(object, arguments);
  }
}

function $() {
  var elements = new Array();

  for (var i = 0; i < arguments.length; i++) {
    var element = arguments[i];
    if (typeof element == 'string')
      element = document.getElementById(element);

    if (arguments.length == 1) 
      return element;

    elements.push(element);
  }

  return elements;
}

//-------------------------

document.getElementsByClassName = function(className) {
  var children = document.getElementsByTagName('*') || document.all;
  var elements = new Array();
  
  for (var i = 0; i < children.length; i++) {
    var child = children[i];
    var classNames = child.className.split(' ');
    for (var j = 0; j < classNames.length; j++) {
      if (classNames[j] == className) {
        elements.push(child);
        break;
      }
    }
  }
  
  return elements;
}

//-------------------------

if (!window.Element) {
  var Element = new Object();
}

Object.extend(Element, {
  remove: function(element) {
    element = $(element);
    element.parentNode.removeChild(element);
  },

  hasClassName: function(element, className) {
    element = $(element);
    if (!element)
      return;
    var a = element.className.split(' ');
    for (var i = 0; i < a.length; i++) {
      if (a[i] == className)
        return true;
    }
    return false;
  },

  addClassName: function(element, className) {
    element = $(element);
    Element.removeClassName(element, className);
    element.className += ' ' + className;
  },
  
  removeClassName: function(element, className) {
    element = $(element);
    if (!element)
      return;
    var newClassName = '';
    var a = element.className.split(' ');
    for (var i = 0; i < a.length; i++) {
      if (a[i] != className) {
        if (i > 0)
          newClassName += ' ';
        newClassName += a[i];
      }
    }
    element.className = newClassName;
  },
  
  // removes whitespace-only text node children
  cleanWhitespace: function(element) {
    element = $(element);
    for (var i = 0; i < element.childNodes.length; i++) {
      var node = element.childNodes[i];
      if (node.nodeType == 3 && !/\S/.test(node.nodeValue)) 
        Element.remove(node);
    }
  }
});
/*
moo.fx, simple effects library built with prototype.js (http://prototype.conio.net).
by Valerio Proietti (http://mad4milk.net) MIT-style LICENSE.
for more info (http://moofx.mad4milk.net).
10/24/2005
v(1.0.2)
*/

//base
var fx = new Object();
fx.Base = function(){};
fx.Base.prototype = {
	setOptions: function(options) {
	this.options = {
		duration: 500,
		onComplete: ''
	}
	Object.extend(this.options, options || {});
	},

	go: function() {
		this.duration = this.options.duration;
		this.startTime = (new Date).getTime();
		this.timer = setInterval (this.step.bind(this), 13);
	},

	step: function() {
		var time  = (new Date).getTime();
		var Tpos   = (time - this.startTime) / (this.duration);
		if (time >= this.duration+this.startTime) {
			this.now = this.to;
			clearInterval (this.timer);
			this.timer = null;
			if (this.options.onComplete) setTimeout(this.options.onComplete.bind(this), 10);
		}
		else {
			this.now = ((-Math.cos(Tpos*Math.PI)/2) + 0.5) * (this.to-this.from) + this.from;
			//this time-position, sinoidal transition thing is from script.aculo.us
		}
		this.increase();
	},

	custom: function(from, to) {
		if (this.timer != null) return;
		this.from = from;
		this.to = to;
		this.go();
	},

	hide: function() {
		this.now = 0;
		this.increase();
	},

	clearTimer: function() {
		clearInterval(this.timer);
		this.timer = null;
	}
}

//stretchers
fx.Layout = Class.create();
fx.Layout.prototype = Object.extend(new fx.Base(), {
	initialize: function(el, options) {
		this.el = $(el);
		this.el.style.overflow = "hidden";
		this.el.iniWidth = this.el.offsetWidth;
		this.el.iniHeight = this.el.offsetHeight;
		this.setOptions(options);
	}
});

fx.Height = Class.create();
Object.extend(Object.extend(fx.Height.prototype, fx.Layout.prototype), {	
	increase: function() {
		this.el.style.height = this.now + "px";
	},

	toggle: function() {
		if (this.el.offsetHeight > 0) this.custom(this.el.offsetHeight, 0);
		else this.custom(0, this.el.scrollHeight);
	}
});

fx.Width = Class.create();
Object.extend(Object.extend(fx.Width.prototype, fx.Layout.prototype), {	
	increase: function() {
		this.el.style.width = this.now + "px";
	},

	toggle: function(){
		if (this.el.offsetWidth > 0) this.custom(this.el.offsetWidth, 0);
		else this.custom(0, this.el.iniWidth);
	}
});

//fader
fx.Opacity = Class.create();
fx.Opacity.prototype = Object.extend(new fx.Base(), {
	initialize: function(el, options) {
		this.el = $(el);
		this.now = 1;
		this.increase();
		this.setOptions(options);
	},

	increase: function() {
		if (this.now == 1) this.now = 0.9999;
		if (this.now > 0 && this.el.style.visibility == "hidden") this.el.style.visibility = "visible";
		if (this.now == 0) this.el.style.visibility = "hidden";
		if (window.ActiveXObject) this.el.style.filter = "alpha(opacity=" + this.now*100 + ")";
		this.el.style.opacity = this.now;
	},

	toggle: function() {
		if (this.now > 0) this.custom(1, 0);
		else this.custom(0, 1);
	}
});	
/*
moo.fx pack, effects extensions for moo.fx.
by Valerio Proietti (http://mad4milk.net) MIT-style LICENSE
for more info visit (http://moofx.mad4milk.net).
Wednesday, November 16, 2005
v1.0.4
*/

//text size modify, now works with pixels too.
fx.Text = Class.create();
fx.Text.prototype = Object.extend(new fx.Base(), {
	initialize: function(el, options) {
		this.el = $(el);
		this.setOptions(options);
		if (!this.options.unit) this.options.unit = "em";
	},

	increase: function() {
		this.el.style.fontSize = this.now + this.options.unit;
	}
});

//composition effect, calls Width and Height alltogheter
fx.Resize = Class.create();
fx.Resize.prototype = {
	initialize: function(el, options) {
		this.h = new fx.Height(el, options); 
		if (options) options.onComplete = null;
		this.w = new fx.Width(el, options);
		this.el = $(el);
	},

	toggle: function(){
		this.h.toggle();
		this.w.toggle();
	},

	modify: function(hto, wto) {
		this.h.custom(this.el.offsetHeight, this.el.offsetHeight + hto);
		this.w.custom(this.el.offsetWidth, this.el.offsetWidth + wto);
	},

	custom: function(hto, wto) {
		this.h.custom(this.el.offsetHeight, hto);
		this.w.custom(this.el.offsetWidth, wto);
	},

	hide: function(){
		this.h.hide();
		this.w.hide();
	}
}

//composition effect, calls Opacity and (Width and/or Height) alltogheter
fx.FadeSize = Class.create();
fx.FadeSize.prototype = {
	initialize: function(el, options) {
		this.el = $(el);
		this.el.o = new fx.Opacity(el, options);
		if (options) options.onComplete = null;
		this.el.h = new fx.Height(el, options);
		this.el.w = new fx.Width(el, options);
	},

	toggle: function() {
		this.el.o.toggle();
		for (var i = 0; i < arguments.length; i++) {
			if (arguments[i] == 'height') this.el.h.toggle();
			if (arguments[i] == 'width') this.el.w.toggle();
		}
	},

	hide: function(){
		this.el.o.hide();
		for (var i = 0; i < arguments.length; i++) {
			if (arguments[i] == 'height') this.el.h.hide();
			if (arguments[i] == 'width') this.el.w.hide();
		}
	}
}

//intended to work with arrays.
var Multi = new Object();
Multi = function(){};
Multi.prototype = {
	initialize: function(elements, options){
		this.options = options;
		this.el = this.getElementsFromArray(elements);
		for (i=0;i<this.el.length;i++){
			this.effect(this.el[i]);
		}
	},

	getElementsFromArray: function(array) {
		var elements = new Array();
		for (i=0;i<array.length;i++) { 
			elements.push($(array[i])); 
		}
		return elements;
	}
}

//Fadesize with arrays
fx.MultiFadeSize = Class.create();
fx.MultiFadeSize.prototype = Object.extend(new Multi(), {
	effect: function(el){
		el.fs = new fx.FadeSize(el, this.options);
	},

	showThisHideOpen: function(el, delay, mode){
		for (i=0;i<this.el.length;i++){
			if (this.el[i].offsetHeight > 0 && this.el[i] != el && this.el[i].h.timer == null && el.h.timer == null){
				this.el[i].fs.toggle(mode);
				setTimeout(function(){el.fs.toggle(mode);}.bind(el), delay);
			}
			
		}
	},

	hide: function(el, mode){
		el.fs.hide(mode);
	}
});

var Remember = new Object();
Remember = function(){};
Remember.prototype = {
	initialize: function(el, options){
		this.el = $(el);
		this.days = 365;
		this.options = options;
		this.effect();
		var cookie = this.readCookie();
		if (cookie) {
			this.fx.now = cookie;
			this.fx.increase();
		}
	},

	//cookie functions based on code by Peter-Paul Koch
	setCookie: function(value) {
		var date = new Date();
		date.setTime(date.getTime()+(this.days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
		document.cookie = this.el+this.el.id+this.prefix+"="+value+expires+"; path=/";
	},

	readCookie: function() {
		var nameEQ = this.el+this.el.id+this.prefix + "=";
		var ca = document.cookie.split(';');
		for(var i=0;i < ca.length;i++) {
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
		}
		return false;
	},

	custom: function(from, to){
		if (this.fx.now != to) {
			this.setCookie(to);
			this.fx.custom(from, to);
		}
	}
}

fx.RememberHeight = Class.create();
fx.RememberHeight.prototype = Object.extend(new Remember(), {
	effect: function(){
		this.fx = new fx.Height(this.el, this.options);
		this.prefix = 'height';
	},
	
	toggle: function(){
		if (this.el.offsetHeight == 0) this.setCookie(this.el.scrollHeight);
		else this.setCookie(0);
		this.fx.toggle();
	},
	
	resize: function(to){
		this.setCookie(this.el.offsetHeight+to);
		this.fx.custom(this.el.offsetHeight,this.el.offsetHeight+to);
	},

	hide: function(){
		if (!this.readCookie()) {
			this.fx.hide();
		}
	}
});

fx.RememberText = Class.create();
fx.RememberText.prototype = Object.extend(new Remember(), {
	effect: function(){
		this.fx = new fx.Text(this.el, this.options);
		this.prefix = 'text';
	}
});


//use to attach effects without using js code, just classnames and rel attributes.
ParseClassNames = Class.create();
ParseClassNames.prototype = {
	initialize: function(options){
		var babies = document.getElementsByTagName('*') || document.all;
		for (var i = 0; i < babies.length; i++) {
			var el = babies[i];
			//attach the effect, from the classNames;
			var effects = this.getEffects(el);
			for (var j = 0; j < effects.length; j++) {
				if (j == 1 && options) options.onComplete = null;
				el[effects[j]+"fx"] = new fx[effects[j]](el, options);
			}
			//execute methods, from rel
			if (el.rel) {
				el.crel = el.rel.split(' ');
				if (el.crel[0].indexOf("fx_") > -1) {
					var event = el.crel[0].replace('fx_', '');
					var tocompute = this.getEffects($(el.crel[1]));
					el["on"+event] = function(){
						for (var f = 0; f < tocompute.length; f++) {
							$(this.crel[1])[tocompute[f]+"fx"][this.crel[2] || "toggle"](this.crel[3] || null, this.crel[4] || null);
						}
					}
				}
			}
		}
	},

	getEffects: function(el){
		var effects = new Array();
		var css = el.className.split(' ');
		for (var i = 0; i < css.length; i++) {
			if (css[i].indexOf('fx_') > -1) {
				var effect = css[i].replace('fx_', '');
				effects.push(effect);
			}
		}
		return effects;
	}
}