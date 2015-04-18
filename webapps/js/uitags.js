function uiUtil_Object() {
  var inherit = arguments[this.__init.length];
  if (!inherit) {
    this.__init.apply(this, arguments);
  }
  ++uiUtil_Object.__numOfInstantiatedObjects;
}
uiUtil_Object.__numOfInstantiatedObjects = 0;
uiUtil_Object.prototype.__init = function() {
};
uiUtil_Object.prototype.__toArray = function(collection, start) {
  var arr = new Array();
  for (var i = start; i < collection.length; ++i) {
    arr[i - start] = collection[i];
  }
  return arr;
};
uiUtil_Object.prototype._super = function(optArgN) {
  this.__apply("__init", this.__toArray(arguments, 0));
};
uiUtil_Object.prototype._callSuper = function(method, optArgN) {
  return this.__apply(method, this.__toArray(arguments, 1));
};
uiUtil_Object.prototype.__apply = function(method, optArguments) {
  if (this.__executingClass[method] == null) {
    this.__executingClass[method] = this.constructor;
  }
  var currentClass = this.__executingClass[method];
  this.__executingClass[method] = currentClass.__parentClass;
  try {
    var returnValue = currentClass.__parentPrototype[method].apply(this, optArguments);
  }
  finally {
    this.__executingClass[method] = currentClass;
  }
  return returnValue;
};
uiUtil_Object.prototype.getClassName = function() {
  return uiUtil_Object.getClassName(this.constructor);
};
uiUtil_Object.prototype.toString = function() {
  return this.getClassName() + uiUtil_Object.__numOfInstantiatedObjects;
};
uiUtil_Object._inherits = function(childClass, parentClass) {
  var UNDEFINED_VALUE;
  var count = parentClass.prototype.__init.length;
  var command = "new parentClass(";
  if (count > 0) {
    for (var i = 0; i < count; ++i) {
      command += "UNDEFINED_VALUE, ";
    }
  }
  command += "true);";
  childClass.prototype = eval(command);
  childClass.prototype.constructor = childClass;
  childClass.prototype.__executingClass = new Object();
  childClass.__parentPrototype = parentClass.prototype;
  childClass.__parentClass = parentClass;
  return childClass.prototype;
};
uiUtil_Object.isAssignableFrom = function(class1, class2) {
  var currClass = class2;
  while (currClass != null) {
    if (class1 == currClass) {
      return true;
    }
    currClass = currClass.__parentClass;
  }
  return false;
};
uiUtil_Object.declareClass = function(origClass, parentClass, optUseLogger) {
  return uiUtil_Object.__declareGenericClass(origClass, parentClass,
      ((optUseLogger == null) ? true : optUseLogger),
      uiUtil_Object.__evaluateClassCode);
};
uiUtil_Object.declareSingleton = function(origClass, parentClass, optUseLogger) {
  return uiUtil_Object.__declareGenericClass(origClass, parentClass,
      ((optUseLogger == null) ? true : optUseLogger),
      uiUtil_Object.__evaluateSingletonCode);
};
uiUtil_Object.declareUtil = function(origClass, parentClass) {
  return uiUtil_Object.__declareGenericClass(
      origClass, parentClass, false, uiUtil_Object.__evaluateUtilCode);
};
uiUtil_Object.__declareGenericClass = function(
    origClass, parent, useLogger, codeGenerator) {
  try {
    var classRef = codeGenerator(origClass);
    var newPrototype = uiUtil_Object._inherits(classRef, parent);
    newPrototype.__init = origClass;
    if (useLogger) {
      newPrototype.__logger = uiUtil_Logger.getInstance(classRef);
      classRef.__logger = newPrototype.__logger;
    }
  }
  catch (e) {  
    alert("Error declaring class: " + uiUtil_Object.getClassName(classRef) +
        ".\nCaused by: " + e);
  }
  return classRef;
};
uiUtil_Object.__generateConstructorPrototype = function(origClass) {
  var className = uiUtil_Object.getClassName(origClass);
  return "function " + className + "()";
};
uiUtil_Object.__evaluateUtilCode = function(origClass) {
  var className = uiUtil_Object.getClassName(origClass);
  return eval(
      className + " = " + uiUtil_Object.__generateConstructorPrototype(origClass) + " {" +
      "  throw new uiUtil_CreateException(" +
      "      'This class is not instantiable: ' + this.getClassName());" +
      "};"
  );
};
uiUtil_Object.__evaluateClassCode = function(origClass) {
  var className = uiUtil_Object.getClassName(origClass);
  return eval(
      className + " = " + uiUtil_Object.__generateConstructorPrototype(origClass) + " {" +
      "  var inherit = arguments[this.__init.length];" +
      "  if (!inherit) {" +
      "    this.__init.apply(this, arguments);" +
      "  }" +
      "};"
  );
};
uiUtil_Object.__evaluateSingletonCode = function(origClass) {
  var className = uiUtil_Object.getClassName(origClass);
  return eval(
      "var temp = " + uiUtil_Object.__generateConstructorPrototype(origClass) + " {" +
      "  if (" + className + ".__instance != null) {" +
      "    throw new uiUtil_CreateException(" +
      "        'A singleton cannot have multiple instances: ' + className);" +
      "  }" +
      "  " + className + ".__instance = this;" +
      "  var inherit = arguments[this.__init.length];" +
      "  if (!inherit) {" +
      "    try {" +
      "      this.__init.apply(this, arguments);" +
      "    }" +
      "    catch (e) {" +
      "      " + className + ".__instance = null;" +  
      "      throw e" +  
      "    }" +
      "  }" +
      "};" + 
      "temp.__instance = null;" +
      "temp.getInstance = function() {" +  
      "  if (" + className + ".__instance == null) {" +
      "    new " + className + "();" +
      "  }" +
      "  return " + className + ".__instance;" +
      "};" +
      className + " = temp;"
  );
};
uiUtil_Object.getClassName = function(objectClass) {
  if (objectClass.name == null) {
    return objectClass.toString().replace(
        /(.*\n)*function ([^\(]*)\((.*\n)*.*/, "$2");
  }
  return objectClass.name;  
};
uiUtil_Object.getPropertiesString = function(object) {
  var str = "";
  for (property in object) {
    str += ' ' + property + "=" + this[property];
  }
  return str;
};
function uiUtil_Exception(message, optError) {
  this._super();
  this.__message = message;
  this.__error = optError;
  if (this.__error != null) {
    this.__error.message = message; 
  }
}
uiUtil_Exception = uiUtil_Object.declareClass(
    uiUtil_Exception, uiUtil_Object, false);
uiUtil_Exception.prototype.getMessage = function() {
  return this.__message;
};
uiUtil_Exception.prototype.getError = function() {
  return this.__error;
};
uiUtil_Exception.prototype.toString = function() {
  return this.getClassName() + ": " + this.getMessage();
};
function uiUtil_CreateException(message) {
  this._super(message);
}
uiUtil_CreateException = uiUtil_Object.declareClass(
    uiUtil_CreateException, uiUtil_Exception, false);
function uiUtil_IllegalStateException(message) {
  this._super(message);
}
uiUtil_IllegalStateException = uiUtil_Object.declareClass(
    uiUtil_IllegalStateException, uiUtil_Exception, false);
function uiUtil_IllegalArgumentException(message) {
  this._super(message);
}
uiUtil_IllegalArgumentException = uiUtil_Object.declareClass(
    uiUtil_IllegalArgumentException, uiUtil_Exception, false);
function uiUtil_Type() {
  this._super();
}
uiUtil_Type = uiUtil_Object.declareUtil(uiUtil_Type, uiUtil_Object);
uiUtil_Type.isDefined = function(value) {
  return ("undefined" != (typeof value));
};
uiUtil_Type.isFunction = function(value) {
  return ("function" == (typeof value));
};
uiUtil_Type.isObject = function(value) {
  return ("object" == (typeof value));
};
uiUtil_Type.isString = function(value) {
  return ("string" == (typeof value));
};
uiUtil_Type.isBoolean = function(value) {
  return ("boolean" == (typeof value));
};
uiUtil_Type.isNumber = function(value) {
  return ("number" == (typeof value)) && !isNaN(value);
};
uiUtil_Type.isInt = function(value) {
  if (!uiUtil_Type.isNumber(value)) {
    return false;
  }
  return (new String(value).indexOf('.') < 0);
};
uiUtil_Type.isDouble = function(value) {
  if (!uiUtil_Type.isNumber(value)) {
    return false;
  }
  return (new String(value).indexOf('.') >= 0);
};
uiUtil_Type.getTypeName = function(value) {
  if (!uiUtil_Type.isDefined(value)) {
    return "undefined";
  }
  else if (value == null) {
    return "null";
  }
  else if (uiUtil_Type.isHtmlNode(value)) {
    return value.nodeName.toLowerCase();
  }
  if (!uiUtil_Type.isFunction(value)) {
    return (typeof value);
  }
  return uiUtil_Object.getClassName(value);
};
uiUtil_Type.isHtmlNode = function(value) {
  return value.nodeName != null;
};
uiUtil_Type.isElementNode = function(value) {
  return value.nodeType == 1;
};
uiUtil_Type.isTextNode = function(value) {
  return value.nodeType == 3;
};
uiUtil_Type.getValue = function(value, defaultValue) {
  if (value == null) {
    return defaultValue;
  }
  return value;
};
uiUtil_Type.getString = function(value, defaultValue) {
  if (uiUtil_Type.isString(value)) {
    return value;
  }
  if (uiUtil_Type.isDefined(value)) {  
    throw new uiUtil_IllegalArgumentException(
        "Invalid string value: " + value);
  }
  return defaultValue;
};
uiUtil_Type.getBoolean = function(value, defaultValue) {
  if (uiUtil_Type.isBoolean(value)) {
    return value;
  }
  if (uiUtil_Type.isDefined(value)) {  
    throw new uiUtil_IllegalArgumentException(
        "Invalid boolean value: " + value);
  }
  return defaultValue;
};
uiUtil_Type.getInt = function(value, defaultValue) {
  if (uiUtil_Type.isInt(value)) {
    return value;
  }
  if (uiUtil_Type.isDefined(value)) {  
    throw new uiUtil_IllegalArgumentException(
        "Invalid integer value: " + value);
  }
  return defaultValue;
};
uiUtil_Type.getComparator = function(optComparator) {
  if (optComparator == null) {
    return new uiUtil_Type.Comparator();
  }
  return optComparator;
};
uiUtil_Type.getEqualityTester = function(optTester) {
  if (optTester == null) {
    return new uiUtil_Type.EqualityTester();
  }
  return optTester;
};
function uiUtil_Type$EqualityTester() {
  this._super();
}
uiUtil_Type.EqualityTester = uiUtil_Object.declareClass(
    uiUtil_Type$EqualityTester, uiUtil_Object, false);
uiUtil_Type.EqualityTester.prototype.equals = function(first, second) {
  return first == second;
};
function uiUtil_Type$Comparator() {
  this._super();
}
uiUtil_Type.Comparator = uiUtil_Object.declareClass(
    uiUtil_Type$Comparator, uiUtil_Object, false);
uiUtil_Type.Comparator.prototype.compare = function(first, second) {
  if (first < second) {
    return -1;
  }
  else if (first > second) {
    return 1;
  }
  return 0;
};
function uiUtil_ArrayUtils() {
  this._super();
}
uiUtil_ArrayUtils = uiUtil_Object.declareUtil(uiUtil_ArrayUtils, uiUtil_Object);
uiUtil_ArrayUtils.INVALID_INDEX = -1;
uiUtil_ArrayUtils.indexOf = function(array, item, optEqualityTester) {
  var equalityTester = uiUtil_Type.getEqualityTester(optEqualityTester);
  for (var i = 0; i < array.length; ++i) {
    if (equalityTester.equals(array[i], item)) {
      return i;
    }
  }
  return uiUtil_ArrayUtils.INVALID_INDEX;
};
uiUtil_ArrayUtils.contains = function(array, item, optTester) {
  var index = uiUtil_ArrayUtils.indexOf(array, item, optTester);
  return index != uiUtil_ArrayUtils.INVALID_INDEX;
};
uiUtil_ArrayUtils.get = function(array, index) {
  if (index >= array.length) {
    throw new uiUtil_IllegalArgumentException("Index out of bound: " + index);
  }
  if (index >= 0) {
    return array[index];
  }
  return array[array.length + index];  
};
uiUtil_ArrayUtils.clear = function(array) {
  while (array.length > 0) {
    array.pop();
  }
};
uiUtil_ArrayUtils.addUnique = function(array, item, optEqualityTester) {
  if (!uiUtil_ArrayUtils.contains(array, item, optEqualityTester)) {
    array.push(item);
  }
};
uiUtil_ArrayUtils.removeFirst = function(array, item, optEqualityTester) {
  var index = uiUtil_ArrayUtils.indexOf(array, item, optEqualityTester);
  if (index != uiUtil_ArrayUtils.INVALID_INDEX) {
    uiUtil_ArrayUtils.removeAt(array, index, 1);
  }
};
uiUtil_ArrayUtils.removeAt = function(array, index, optCount) {
  var count = ((uiUtil_Type.isInt(optCount)) ? optCount : 1);
  if (index >= 0) {
    array.splice(index, count);
  }
  else {  
    array.splice(array.length + index - count + 1, count);
  }
};
uiUtil_ArrayUtils.sort = function(array, optComparator) {
  var comparator = uiUtil_Type.getComparator(optComparator);
  array.sort(comparator.compare);
};
uiUtil_ArrayUtils.reverse = function(array, optComparator) {
  var comparator = uiUtil_Type.getComparator(optComparator);
  array.reverse(comparator.compare);
};
uiUtil_ArrayUtils.toArrayIfNotAlready = function(collection) {
  if (collection instanceof Array) {
    return collection;
  }
  if (uiUtil_Type.isDefined(collection) &&
      uiUtil_Type.isDefined(collection[0]) &&
      uiUtil_Type.isInt(collection.length)) {
    var array = new Array(collection.length);
    for (var i = 0; i < collection.length; ++i) {
      array[i] = collection[i];
    }
    return array;
  }
  throw new uiUtil_IllegalArgumentException(
      "The provided argument is not a valid collection");
};
uiUtil_ArrayUtils.toString = function(array) {
  var string = array.getClassName() + "{";
  if (array.length > 0) {
    string += array[0];
    for (var i = 1; i < array.length; ++i) {
      string += ", " + array[i];
    }
  }
  return string + "}";
};
function uiUtil_Logger(loggedClass, logLevel) {
  this._super();
  var className = uiUtil_Type.getTypeName(loggedClass);
  if (uiUtil_Logger.__instances[className] != null) {
    throw new uiUtil_CreateException("There shouldn't be more than one " +
        "instances of logger for the same class: " + className);
  }
  uiUtil_Logger.__instances[className] = this;
  this.__allLevels = new Array();
  this.__loggedClass = loggedClass;
  this.__needDebugPanel = (logLevel != uiUtil_Logger.LEVEL_NONE);
  this.__currentLevel = null;
  this.setLevel(logLevel);
}
uiUtil_Object._inherits(uiUtil_Logger, uiUtil_Object);
uiUtil_Logger.__defaultStream = null;
uiUtil_Logger.__instances = new Object();
uiUtil_Logger.LEVEL_NONE = 0;
uiUtil_Logger.LEVEL_FATAL = 1;
uiUtil_Logger.LEVEL_ERROR = 2;
uiUtil_Logger.LEVEL_WARN = 3;
uiUtil_Logger.LEVEL_INFO = 4;
uiUtil_Logger.LEVEL_DEBUG = 5;
uiUtil_Logger.LEVEL_ALL = 6;
if ((typeof uiGlobal_defaultLevel) == "undefined") {
  uiUtil_Logger.__defaultLevel = uiUtil_Logger.LEVEL_NONE;
}
else {
  uiUtil_Logger.__defaultLevel = uiGlobal_defaultLevel;
}
uiUtil_Logger.prototype.__obtainStream = function(loggedClass) {
  var className = uiUtil_Type.getTypeName(loggedClass);
  var stream = null;
  this.__needDebugPanel = true;
  try {
    stream = uiHtml_DebugPanel.getInstance("Creator: " + className);
    this.__needDebugPanel = false;
  }
  catch (e1) {
    try {
      stream = uiHtml_Document.getInstance().getPrintStream();
    }
    catch (e2) {
      stream = uiUtil_Logger.getDefaultPrintStream();
    }
  }
  return stream;
};
uiUtil_Logger.prototype.setLevel = function(level) {
  this.__currentLevel = level;
  var max = level + 1;  
  for (var i = 0; i < max; ++i) {
    this.__allLevels[i] = true;
  }
};
uiUtil_Logger.prototype.setStream = function(stream) {
  this.__stream = stream;
};
uiUtil_Logger.prototype.getStream = function() {
  if (this.__needDebugPanel) {
    try {
      this.__stream = this.__obtainStream(this.__loggedClass);
    }
    catch (e) {
      throw e;
    }
  }
  return this.__stream;
};
uiUtil_Logger.prototype.__logTo = function(stream, message, level) {
  var levelName;
  switch (level) {
    case uiUtil_Logger.LEVEL_FATAL : levelName = "FATAL";
                                        break;
    case uiUtil_Logger.LEVEL_ERROR : levelName = "ERROR";
                                        break;
    case uiUtil_Logger.LEVEL_WARN  : levelName = "WARN";
                                        break;
    case uiUtil_Logger.LEVEL_INFO  : levelName = "INFO";
                                        break;
    case uiUtil_Logger.LEVEL_DEBUG : levelName = "DEBUG";
                                        break;
  }
  stream.println("[uitags " + levelName + "] " +
      uiUtil_Type.getTypeName(this.__loggedClass) + ": " + message);
};
uiUtil_Logger.prototype.__log = function(message, level) {
  this.__logTo(this.getStream(), message, level);
};
uiUtil_Logger.prototype.fatal = function(message) {
  if (this.__allLevels[uiUtil_Logger.LEVEL_FATAL]) {
    this.__log(message, uiUtil_Logger.LEVEL_FATAL);
  }
};
uiUtil_Logger.prototype.error = function(message) {
  if (this.__allLevels[uiUtil_Logger.LEVEL_ERROR]) {
    this.__log(message, uiUtil_Logger.LEVEL_ERROR);
  }
};
uiUtil_Logger.prototype.warn = function(message) {
  if (this.__allLevels[uiUtil_Logger.LEVEL_WARN]) {
    this.__log(message, uiUtil_Logger.LEVEL_WARN);
  }
};
uiUtil_Logger.prototype.info = function(message) {
  if (this.__allLevels[uiUtil_Logger.LEVEL_INFO]) {
    this.__log(message, uiUtil_Logger.LEVEL_INFO);
  }
};
uiUtil_Logger.prototype.debug = function(message) {
  if (this.__allLevels[uiUtil_Logger.LEVEL_DEBUG]) {
    this.__log(message, uiUtil_Logger.LEVEL_DEBUG);
  }
};
uiUtil_Logger.getInstance = function(optLoggedClass, optLevel) {
  var className = uiUtil_Type.getTypeName(optLoggedClass);
  if (uiUtil_Logger.__instances[className] == null) {
    var level = uiUtil_Type.isDefined(optLevel) ?
        optLevel : uiUtil_Logger.__defaultLevel;
    return new uiUtil_Logger(optLoggedClass, level);
  }
  return uiUtil_Logger.__instances[className];
};
uiUtil_Logger.getDefaultPrintStream = function() {
  if (uiUtil_Logger.__defaultStream == null) {
    uiUtil_Logger.__defaultStream = new uiUtil_Logger.PrintStream();
  }
  return uiUtil_Logger.__defaultStream;
};
function uiUtil_Logger$PrintStream() {
  this._super();
}
uiUtil_Logger.PrintStream =
    uiUtil_Object.declareClass(uiUtil_Logger$PrintStream, uiUtil_Object);
uiUtil_Logger.PrintStream.prototype.print = function(text) {
  alert(text);
};
uiUtil_Logger.PrintStream.prototype.println = function(text) {
  alert(text);
};
function uiUtil_Dimension(left, top, width, height) {
  this._super();
  this.__left = left;
  this.__top = top;
  this.__width = width;
  this.__height = height;
  this.__right = null;
  this.__bottom = null;
}
uiUtil_Dimension = uiUtil_Object.declareClass(uiUtil_Dimension, uiUtil_Object);
uiUtil_Dimension.prototype.getWidth = function() {
  return this.__width;
};
uiUtil_Dimension.prototype.getHeight = function() {
  return this.__height;
};
uiUtil_Dimension.prototype.getLeft = function() {
  return this.__left;
};
uiUtil_Dimension.prototype.getRight = function() {
  if (this.__right == null) {
    this.__right = this.__left + this.__width;
  }
  return this.__right;
};
uiUtil_Dimension.prototype.getTop = function() {
  return this.__top;
};
uiUtil_Dimension.prototype.getBottom = function() {
  if (this.__bottom == null) {
    this.__bottom = this.__top + this.__height;
  }
  return this.__bottom;
};
uiUtil_Dimension.prototype.toString = function() {
  return this.getClassName() + " [" +
      " x=" + this.__left +
      " y=" + this.__top +
      " width=" + this.__width +
      " height=" + this.__height +
      " ]";
};
uiUtil_Dimension.prototype.equals = function(obj) {
  if (this == obj) {
    return true;
  }
  if (!(obj instanceof uiUtil_Dimension)) {
    return false;
  }
  return (this.__left == obj.__left) &&
      (this.__top == obj.__top) &&
      (this.__width == obj.__width) &&
      (this.__height == obj.__height);
};
function uiUtil_Calendar(optJsDate) {
  this._super();
  this.__updateListeners = new Array();
  this.__date = (optJsDate == null) ? new Date() : new Date(optJsDate);
}
uiUtil_Calendar = uiUtil_Object.declareClass(uiUtil_Calendar, uiUtil_Object);
uiUtil_Calendar.NUM_DAYS_IN_A_WEEK = 7;
uiUtil_Calendar.NUM_MONTHS_IN_A_YEAR = 12;
uiUtil_Calendar.INDEX_SUNDAY = 0;
uiUtil_Calendar.INDEX_MONDAY = 1;
uiUtil_Calendar.INDEX_TUESDAY = 2;
uiUtil_Calendar.INDEX_WEDNESDAY = 3;
uiUtil_Calendar.INDEX_THURSDAY = 4;
uiUtil_Calendar.INDEX_FRIDAY = 5;
uiUtil_Calendar.INDEX_SATURDAY = 6;
uiUtil_Calendar.INDEX_JANUARY = 0;
uiUtil_Calendar.INDEX_FEBRUARY = 1;
uiUtil_Calendar.INDEX_MARCH = 2;
uiUtil_Calendar.INDEX_APRIL = 3;
uiUtil_Calendar.INDEX_MAY = 4;
uiUtil_Calendar.INDEX_JUNE = 5;
uiUtil_Calendar.INDEX_JULY = 6;
uiUtil_Calendar.INDEX_AUGUST = 7;
uiUtil_Calendar.INDEX_SEPTEMBER = 8;
uiUtil_Calendar.INDEX_OCTOBER = 9;
uiUtil_Calendar.INDEX_NOVEMBER = 10;
uiUtil_Calendar.INDEX_DECEMBER = 11;
uiUtil_Calendar.CODE_YEAR = "y";
uiUtil_Calendar.CODE_MONTH = "M";
uiUtil_Calendar.CODE_DAY = "d";
uiUtil_Calendar.__SPECIAL_CHARS =
    uiUtil_Calendar.CODE_YEAR +
    uiUtil_Calendar.CODE_MONTH +
    uiUtil_Calendar.CODE_DAY;
uiUtil_Calendar.prototype.addUpdateListener = function(listener) {
  this.__updateListeners.push(listener);
};
uiUtil_Calendar.prototype.toDate = function() {
  return new Date(this.__date);
};
uiUtil_Calendar.prototype.fromDate = function(jsDate) {
  this.__date = new Date(jsDate);
  this.__notifyListeners();
};
uiUtil_Calendar.prototype.update = function(newYear, newMonth, newDay) {
  this.__date.setDate(1);
  this.__date.setYear(newYear);
  this.__date.setMonth(newMonth);
  this.__date.setDate(newDay);
  this.__notifyListeners();
  return this;
};
uiUtil_Calendar.prototype.setDay = function(newDay) {
  this.__date.setDate(newDay);
  this.__notifyListeners();
  return this;
};
uiUtil_Calendar.prototype.setMonth = function(newMonth) {
  this.__date.setMonth(newMonth);
  this.__notifyListeners();
  return this;
};
uiUtil_Calendar.prototype.setYear = function(newYear) {
  this.__date.setYear(newYear);
  this.__notifyListeners();
  return this;
};
uiUtil_Calendar.prototype.incrementDay = function() {
  return this.setDay(this.getDay() + 1);
};
uiUtil_Calendar.prototype.decrementDay = function() {
  return this.setDay(this.getDay() - 1);
};
uiUtil_Calendar.prototype.incrementMonth = function() {
  return this.setMonth(this.getMonth() + 1);
};
uiUtil_Calendar.prototype.decrementMonth = function() {
  return this.setMonth(this.getMonth() - 1);
};
uiUtil_Calendar.prototype.incrementYear = function() {
  return this.setYear(this.getYear() + 1);
};
uiUtil_Calendar.prototype.decrementYear = function() {
  return this.setYear(this.getYear() - 1);
};
uiUtil_Calendar.prototype.__notifyListeners = function() {
  for (var i = 0; i < this.__updateListeners.length; ++i) {
    this.__updateListeners[i].dateUpdated(this);
  }
};
uiUtil_Calendar.prototype.getDay = function() {
  return this.__date.getDate();
};
uiUtil_Calendar.prototype.getMonth = function() {
  return this.__date.getMonth();
};
uiUtil_Calendar.prototype.getYear = function() {
  return this.__date.getFullYear();
};
uiUtil_Calendar.prototype.getFirstDayInMonth = function() {
  var firstInMonth = new Date(this.__date);
  firstInMonth.setDate(1);
  return firstInMonth.getDay();
};
uiUtil_Calendar.prototype.getNumDaysInMonth = function() {
  var numDays = new Array(12);
  numDays[0]  = 31;
  numDays[1]  = this.__isLeapYear()? 29 : 28;
  numDays[2]  = 31;
  numDays[3]  = 30;
  numDays[4]  = 31;
  numDays[5]  = 30;
  numDays[6]  = 31;
  numDays[7]  = 31;
  numDays[8]  = 30;
  numDays[9]  = 31;
  numDays[10] = 30;
  numDays[11] = 31;
  return numDays[this.__date.getMonth()];
};
uiUtil_Calendar.prototype.__isLeapYear = function() {
  var year = this.__date.getFullYear();
  if ((year % 4 == 0 && year % 100 != 0) ||
      year % 400 == 0) {
    return true;
  }
  return false;
};
uiUtil_Calendar.prototype.format = function(format) {
  var specialChars = uiUtil_Calendar.__SPECIAL_CHARS;
  var newString = format;
  for (var i = 0; i < specialChars.length; ++i) {
    var regex = new RegExp("(" + specialChars.charAt(i) + "+)");
    if (regex.test(format)) {
      var specialCode = RegExp.$1;
      var codeHandler = uiUtil_Calendar.__formats[specialCode];
      if (codeHandler != null) {
        newString = newString.replace(
            specialCode, codeHandler.call(this));
      }
    }
  }
  return newString;
};
uiUtil_Calendar.__formats = new Array();
uiUtil_Calendar.__formats["yyyy"] = function() {
  return this.getYear();
};
uiUtil_Calendar.__formats["yy"] = function() {
  var yearString = new String(this.getYear());
  return yearString.substring(2);
};
uiUtil_Calendar.__formats["MM"] = function() {
  var month = this.getMonth() + 1;
  return (month < 10) ? "0" + month : month;
};
uiUtil_Calendar.__formats["dd"] = function() {
  var day = this.getDay();
  return (day < 10) ? "0" + day : day;
};
uiUtil_Calendar.createFromString = function(string, format) {
  var regex = new uiUtil_Calendar.DateRegExp(format);
  if (regex.__test(string)) {
    var year = regex.__getYear();
    var month = regex.__getMonth();
    var day = regex.__getDay();
    var calendar = new uiUtil_Calendar(new Date(year, month, day));
    if (calendar.getDay() != day ||
        calendar.getMonth() != month ||
        calendar.getYear() != year) {
      throw new uiUtil_CreateException("Invalid date value '" + string +
          "'. " + year + "-" + month + "-" + day + " converted to: " +
          calendar.getYear() + "-" + calendar.getMonth() + "-" + calendar.getDay());
    }
    return calendar;
  }
  throw new uiUtil_CreateException("Invalid date '" + string +
      "' according to the format: " + format);
};
function uiUtil_Calendar$UpdateListener() {
  this._super();
}
uiUtil_Calendar.UpdateListener =
    uiUtil_Object.declareClass(uiUtil_Calendar$UpdateListener, uiUtil_Object);
uiUtil_Calendar.UpdateListener.prototype.dateUpdated = function(date) {
  alert("Date updated " + date.format("dd/MM/yyyy"));
};
function uiUtil_Calendar$DateRegExp(format) {
  this._super();
  this.__yearIndex = 0;
  this.__monthIndex = 0;
  this.__dayIndex = 0;
  this.__currentIndex = 1;
  this.__results = null;
  this.__regex = new RegExp(this.__getRegexPatternFrom(format));
}
uiUtil_Calendar.DateRegExp =
    uiUtil_Object.declareClass(uiUtil_Calendar$DateRegExp, uiUtil_Object);
uiUtil_Calendar.DateRegExp.prototype.__getRegexPatternFrom = function(format) {
  var pattern = "";
  var currentChar = "";
  var currentCount;
  for (var i = 0; i < format.length; ++i) {
    if (format.charAt(i) == currentChar) {
      ++currentCount;
    }
    else {
      if (currentChar != "") {
        pattern += this.__generateDigitPattern(currentCount);
      }
      if (this.__isSpecialChar(format.charAt(i))) {
        currentChar = format.charAt(i);
        currentCount = 1;
      }
      else {
        pattern += format.charAt(i);
        currentChar = "";
      }
    }
  }
  if (currentChar != "") {  
    pattern += this.__generateDigitPattern(currentCount);
  }
  return pattern;
};
uiUtil_Calendar.DateRegExp.prototype.__generateDigitPattern = function(count) {
  return "(\\d{" + count + "})";
};
uiUtil_Calendar.DateRegExp.prototype.__isSpecialChar = function(currentChar) {
  switch (currentChar) {
    case uiUtil_Calendar.CODE_YEAR :
        this.__yearIndex = this.__currentIndex;
        ++this.__currentIndex;
        return true;
    case uiUtil_Calendar.CODE_MONTH :
        this.__monthIndex = this.__currentIndex;
        ++this.__currentIndex;
        return true;
    case uiUtil_Calendar.CODE_DAY :
        this.__dayIndex = this.__currentIndex;
        ++this.__currentIndex;
        return true;
  }
  return false;
};
uiUtil_Calendar.DateRegExp.prototype.__test = function(string) {
  this.__results = this.__regex.exec(string);
  return this.__results != null;
};
uiUtil_Calendar.DateRegExp.prototype.__getDay = function() {
  return this.__results[this.__dayIndex];
};
uiUtil_Calendar.DateRegExp.prototype.__getMonth = function() {
  return this.__results[this.__monthIndex] - 1;
};
uiUtil_Calendar.DateRegExp.prototype.__getYear = function() {
  return this.__results[this.__yearIndex];
};
function uiHtml_Element(domElement, inline) {
  this._super();
  this.__domElement = domElement;
  this.__supporter = uiHtml_ElementWrapper.getInstance();
}
uiHtml_Element = uiUtil_Object.declareClass(uiHtml_Element, uiUtil_Object);
uiHtml_Element.prototype.setStyleAttribute = function(name, value) {
  this.__supporter.setStyleAttribute(this.__domElement, name, value);
};
uiHtml_Element.prototype.getCascadedStyleAttribute = function(name) {
  return this.__supporter.getCascadedStyleAttribute(this.__domElement, name);
};
uiHtml_Element.prototype.isShowing = function() {
  return this.__supporter.isShowing(this.__domElement);
};
uiHtml_Element.prototype.show = function() {
  this.__supporter.show(this.__domElement);
};
uiHtml_Element.prototype.hide = function() {
  this.__supporter.hide(this.__domElement);
};
uiHtml_Element.prototype.isAppearing = function() {
  return this.__supporter.isAppearing(this.__domElement);
};
uiHtml_Element.prototype.appear = function() {
  this.__supporter.appear(this.__domElement);
};
uiHtml_Element.prototype.disappear = function() {
  this.__supporter.disappear(this.__domElement);
};
uiHtml_Element.prototype.setDepth = function(depth) {
  this.__supporter.setDepth(this.__domElement, depth);
};
uiHtml_Element.prototype.getDepth = function() {
  return this.__supporter.getDepth(this.__domElement);
};
uiHtml_Element.prototype.setDimension = function(x, y, width, height) {
  this.__supporter.setDimension(this.__domElement, x, y, width, height);
};
uiHtml_Element.prototype.setDimensionObject = function(dimension) {
  this.__supporter.setDimensionObject(this.__domElement, dimension);
};
uiHtml_Element.prototype.prependEventHandler = function(eventName, eventHandler) {
  return this.__supporter.prependEventHandler(
      this.__domElement, eventName, eventHandler);
};
uiHtml_Element.prototype.appendEventHandler = function(eventName, eventHandler) {
  return this.__supporter.appendEventHandler(
      this.__domElement, eventName, eventHandler);
};
uiHtml_Element.prototype._initializeEventProperty = function(eventName, actualHandler) {
  this.__supporter._initializeEventProperty(this.__domElement, eventName, actualHandler);
};
uiHtml_Element.prototype._getActualHandler = function(eventName) {
  return this.__supporter._getActualHandler(this.__domElement, eventName);
};
uiHtml_Element.prototype.removeEventHandler = function(
    eventName, startIndex) {
  this.__supporter.removeEventHandler(
      this.__domElement, eventName, startIndex);
};
uiHtml_Element.prototype.clearEventHandlerExtension = function(eventName) {
  this.__supporter.clearEventHandlerExtension(this.__domElement, eventName);
};
uiHtml_Element.prototype.executeAggregateEventHandler = function(
    eventName, optDomEvent) {
  this.__supporter.executeAggregateEventHandler(
      this.__domElement, eventName, optDomEvent);
};
uiHtml_Element.prototype.appendMousePressHandler = function(eventHandler) {
  this.__supporter.appendMousePressHandler(this.__domElement, eventHandler);
};
uiHtml_Element.prototype.enableDragSupport = function(optTrigger) {
  var element = this;
  this.__supporter.enableDragSupport(this.__domElement, optTrigger, function(x, y) {
    element.setDimension(x, y, null, null);
  });
};
uiHtml_Element.prototype.restrictDragging = function(
    optLeft, optTop, optMaxWidth, optMaxHeight) {
  this.__supporter.restrictDragging(
      this.__domElement, optLeft, optTop, optMaxWidth, optMaxHeight);
};
uiHtml_Element.prototype.getWidth = function() {
  return this.__supporter.getWidth(this.__domElement);
};
uiHtml_Element.prototype.getHeight = function() {
  return this.__supporter.getHeight(this.__domElement);
};
uiHtml_Element.prototype.getImmediateRelativeDimension = function() {
  var element = this;
  return this.__supporter._getDimension(this.__domElement,
      this.__supporter._obtainImmediateRelativeDimension,
      function() { return element.getWidth(); },
      function() { return element.getHeight(); });
};
uiHtml_Element.prototype.getRelativeDimension = function() {
  var element = this;
  return this.__supporter._getDimension(this.__domElement,
      this.__supporter._obtainRelativeDimension,
      function() { return element.getWidth(); },
      function() { return element.getHeight(); });
};
uiHtml_Element.prototype.setDisabled = function(value) {
  this.__supporter.setDisabled(this.__domElement, value);
};
uiHtml_Element.prototype.getDomObject = function() {
  return this.__domElement;
};
uiHtml_Element.createByEither = function(id, name, optTypeClass) {
  var uiDocument = uiHtml_Document.getInstance();
  var domObject = null;
  try {
    domObject = uiDocument.getDomObjectById(id, true);
  }
  catch (e) {
    if (name == null || name == '') {
      throw e;
    }
    domObject = uiDocument.getDomObjectsByName(name, true)[0];
  }
  var extProps = uiHtml_Element.__getExtProps(domObject);
  if (extProps.__elementWrapper == null) {
    extProps.__elementWrapper = uiHtml_Element.__createElement(
          domObject, optTypeClass);
    uiHtml_Element.__logger.debug("Created new element " +
        extProps.__elementWrapper);
    uiHtml_Element.__logger.debug("ID/name: " + id + "/" + name);
  }
  return extProps.__elementWrapper;
};
uiHtml_Element.__createElement = function(domObject, optTypeClass) {
  if (optTypeClass != null &&
      uiUtil_Object.isAssignableFrom(uiHtml_Element, optTypeClass)) {
    return new optTypeClass(domObject);
  }
  return uiHtml_Element.createElementByType(domObject);
};
uiHtml_Element.__getExtProps = function(domElement) {
  var supporter = uiHtml_ElementWrapper.getInstance();
  var extProps = supporter._getClassProperty(domElement, uiHtml_Element);
  if (extProps == null) {
    extProps = new uiHtml_Element.DomExtProps();
    supporter._setClassProperty(domElement, uiHtml_Element, extProps);
  }
  return extProps;
}
uiHtml_Element.createElementByType = function(domElement) {
  if (domElement == null) {
    return null;
  }
  switch(uiHtml_Element.getWidgetType(domElement)) {
    case "select"   : return new uiHtml_Select(domElement);
    default         : return new uiHtml_Element(domElement);
  }
};
uiHtml_Element.getWidgetType = function(domElement) {
  var tagName = uiHtml_Element.getTagName(domElement);
  switch (tagName) {
    case "label"   :
    case "select"  :
    case "option"  :
    case "textarea": return tagName;
    case "input"   : 
                     return domElement.type.toLowerCase();
    default        : return "undefined";
  }
};
uiHtml_Element.getTagName = function(domElement) {
  var tagName = domElement.tagName;
  if (tagName == null) {
    return "undefined";
  }
  return tagName.toLowerCase();
};
uiHtml_Element._initializeDomObject = function(domElement, optAppear) {
  var supporter = uiHtml_ElementWrapper.getInstance();
  if (uiUtil_Type.getBoolean(optAppear, true)) {
    supporter.appear(domElement);
  }
  else {
    supporter.disappear(domElement);
  }
};
function uiHtml_Element$DomExtProps() {
  this.__elementWrapper = null;
}
uiHtml_Element.DomExtProps = uiUtil_Object.declareClass(
    uiHtml_Element$DomExtProps, uiUtil_Object);
function uiHtml_ScrollSupporter(domElement) {
  this._super();
  this.__domElement = domElement;
}
uiHtml_ScrollSupporter =
    uiUtil_Object.declareClass(uiHtml_ScrollSupporter, uiUtil_Object);
uiHtml_ScrollSupporter.prototype.showScrollBars = function(optAlways) {
  this.__domElement.style.overflow = ((optAlways == true) ? "scroll" : "auto");
};
uiHtml_ScrollSupporter.prototype.hideScrollBars = function() {
  this.__domElement.style.overflow = "hidden";
};
uiHtml_ScrollSupporter.prototype.scrollToTop = function() {
  this.__domElement.scrollTop = 0;
};
uiHtml_ScrollSupporter.prototype.scrollToBottom = function() {
  this.__domElement.scrollTop = this.__domElement.scrollHeight;
};
uiHtml_ScrollSupporter.prototype.getScrollLeft = function() {
  return this.__domElement.scrollLeft;
};
uiHtml_ScrollSupporter.prototype.getScrollTop = function() {
  return this.__domElement.scrollTop;
};
function uiHtml_PrintSupporter(domElement) {
  this._super();
  this.__domElement = domElement;
  this.__textNode = uiHtml_Document.createTextNode("", domElement);
}
uiHtml_PrintSupporter =
    uiUtil_Object.declareClass(uiHtml_PrintSupporter, uiUtil_Object);
uiHtml_PrintSupporter.prototype.print = function(text) {
  this.__textNode.appendData(text);
};
uiHtml_PrintSupporter.prototype.println = function(text) {
  this.print(text);
  uiHtml_Document.createDomObject("br", true, this.__domElement);
  this.__textNode = uiHtml_Document.createTextNode("", this.__domElement);
};
function uiHtml_Event(event) {
  this._super();
  if (event == null) {  
    this.__domEvent = window.event;
    this.__w3cModel = false;
  }
  else {  
    this.__domEvent = event;
    this.__w3cModel = true;
  }
}
uiHtml_Event = uiUtil_Object.declareClass(uiHtml_Event, uiUtil_Object);
uiHtml_Event.prototype.getDomSource = function() {
  if (this.__w3cModel) {
    return this.__domEvent.currentTarget;
  }
  else {
    return this.__domEvent.srcElement;
  }
};
uiHtml_Event.prototype.preventBubble = function() {
  if (this.__w3cModel) {
    this.__domEvent.stopPropagation();
  }
  else {
    this.__domEvent.cancelBubble = true;
  }
};
uiHtml_Event.prototype.preventDefault = function() {
  if (this.__w3cModel) {
    this.__domEvent.preventDefault();
  }
  else {
    this.__domEvent.returnValue = false;
  }
};
uiHtml_Event.prototype.getViewPortPosition = function() {
  return new uiUtil_Dimension(this.__domEvent.clientX, this.__domEvent.clientY);
};
uiHtml_Event.prototype.getAbsolutePosition = function() {
  return new uiUtil_Dimension(
      uiHtml_Document.getInstance().getScrollLeft() + this.__domEvent.clientX,
      uiHtml_Document.getInstance().getScrollTop() + this.__domEvent.clientY);
};
uiHtml_Event.prototype.isAltPressed = function() {
  return this.__domEvent.altKey;
};
uiHtml_Event.prototype.isCtrlPressed = function() {
  return this.__domEvent.ctrlKey;
};
uiHtml_Event.prototype.isShiftPressed = function() {
  return this.__domEvent.shiftKey;
};
uiHtml_Event.prototype.getPressedChar = function(optToLower) {
  var code = this.__domEvent.keyCode;
  if (this.__w3cModel) {
    code = this.__domEvent.which;
  }
  var character = String.fromCharCode(code);
  if (uiUtil_Type.getBoolean(optToLower, false)) {
    character = character.toLowerCase();
  }
  return character;
};
uiHtml_Event.__getDomObject = function(event) {
  if (event == null) {  
    return window.event;
  }
  else {  
    return event;
  }
};
uiHtml_Event.getViewPortPosition = function(event) {
  var domEvent = uiHtml_Event.__getDomObject(event);
  return new uiUtil_Dimension(domEvent.clientX, domEvent.clientY);
};
function uiHtml_Window() {
  this._super(window);
  this.__isOpera = window.opera ? true : false;
  this.__isIe = (document.all != null && !this.__isOpera);
  this.__finalizerId = this.__appendElementFinalizer();
  var uiWindow = this;
  var actualHandler = this._getActualHandler("load");
  this._initializeEventProperty("load", function() {
    try {
      actualHandler();
    }
    catch (e) {
      if (e instanceof Error) {
        throw uiWindow.__handleError(e);
      }
      else if (e instanceof uiUtil_Exception) {
        throw uiWindow.__handleException(e);
      }
    }
  });
  this.prependEventHandler("load", function(e) {
    uiHtml_Window.__isLoaded = true;
    uiHtml_Window.getInstance().__logger.debug("finish loading");
  });
}
uiHtml_Window = uiUtil_Object.declareSingleton(uiHtml_Window, uiHtml_Element);
uiHtml_Window.__isLoaded = false;
uiHtml_Window.prototype.isOpera = function() {
  return this.__isOpera;
};
uiHtml_Window.prototype.isIe = function() {
  return this.__isIe;
};
uiHtml_Window.prototype.getBrowserVersion = function() {
  if (this.__isOpera) {
    return this.__extractVersion(navigator.userAgent, "Opera");
  }
  if (this.__isIe) {
    return this.__extractVersion(navigator.userAgent, "MSIE");
  }
  return -1;
};
uiHtml_Window.prototype.__extractVersion = function(data, idSubstring) {
  var index = data.indexOf(idSubstring);
  if (index >= 0) {
    return parseFloat(data.substring(index + idSubstring.length + 1));
  }
  return -1;
}
uiHtml_Window.prototype.__printError = function(error) {
  var message = error.message;
  var url = error.fileName;
  var line = error.lineNumber;
  this.__logger.info(message + " (Loc: " + url + ":" + line + ")");
};
uiHtml_Window.prototype.__handleError = function(error) {
  this.__printError(error);
  return error;
};
uiHtml_Window.prototype.__handleException = function(exception) {
  var error =exception.getError();
  if (error != null) {
    this.__printError(error);
    return error;
  }
  else {
    this.__logger.info(exception.getMessage());
    return exception;
  }
};
uiHtml_Window.prototype.getWidth = function() {
  if (this.__isIe) {
    return document.documentElement.clientWidth;
  }
  else {
    return window.innerWidth;
  }
};
uiHtml_Window.prototype.getHeight = function() {
  if (this.__isIe) {
    return document.documentElement.clientHeight;
  }
  else {
    return window.innerHeight;
  }
};
uiHtml_Window.prototype.__appendElementFinalizer = function() {
  return this._callSuper("appendEventHandler", "unload", function(e) {
    uiHtml_ElementWrapper._finalizeElements();
    uiHtml_Window.__isLoaded = false;
  });
}
uiHtml_Window.prototype.appendEventHandler = function(eventName, handler) {
  if (eventName == "unload" && this.__finalizerId != null) {
    this.removeEventHandler(eventName, this.__finalizerId);
    var index = this._callSuper("appendEventHandler", eventName, handler);
    this.__finalizerId = this.__appendElementFinalizer();
    return index;
  }
  return this._callSuper("appendEventHandler", eventName, handler);
};
uiHtml_Window.prototype.clearEventHandlerExtension = function(eventName) {
  this._callSuper("clearEventHandlerExtension", eventName);
  if (eventName == "unload") {
    this.__finalizerId = this.__appendElementFinalizer();
  }
};
uiHtml_Window.prototype.getRequestParameters = function() {
  var parameters = new Object();
  var url = window.top.location.href;
  var queries = url.split("&");
  for (var i = 0; i < queries.length; ++i) {
    var pair = queries[i].split("=");
    var key = pair[0];
    var value = pair[1];
    parameters[key] = value;
  }
  return parameters;
};
uiHtml_Window.isLoaded = function() {
  return uiHtml_Window.__isLoaded;
};
function uiHtml_Document() {
  this._super(document.body);
  this.__printStream = null;
  this.__scrollSupporter =
      new uiHtml_ScrollSupporter(document.documentElement);
  this.__eventSupporter = uiHtml_Element.createElementByType(document);
}
uiHtml_Document = uiUtil_Object.declareSingleton(uiHtml_Document, uiHtml_Element);
uiHtml_Document.prototype.getDomObjectById = function(id, optAssert) {
  var domObject = document.getElementById(id);
  if (uiUtil_Type.getBoolean(optAssert, true) && domObject == null) {
    throw new uiUtil_IllegalArgumentException("Invalid element ID: " + id);
  }
  return domObject;
};
uiHtml_Document.prototype.getDomObjectsByName = function(name, optAssert) {
  var domObjects = document.getElementsByName(name);
  if (uiUtil_Type.getBoolean(optAssert, true) && domObjects[0] == null) {
    throw new uiUtil_IllegalArgumentException("Invalid element name: " + name);
  }
  return domObjects;
};
uiHtml_Document.prototype.__assertLoaded = function(message) {
  if (!uiHtml_Window.isLoaded()) {
    throw new uiUtil_IllegalStateException(message);
  }
};
uiHtml_Document.prototype.__assertLoadedWhenAttachingDomObjectOf = function(tagName) {
  this.__assertLoaded("DOM object " + tagName + " should not be " +
        "attached to document before the window finishes loading");
};
uiHtml_Document.prototype.createDomObject = function(tagName, optAppear) {
  this.__assertLoadedWhenAttachingDomObjectOf(tagName);
  return uiHtml_Document.createDomObject(tagName, optAppear, document.body);
};
uiHtml_Document.prototype.prependEventHandler = function(eventName, eventHandler) {
  return this.__eventSupporter.prependEventHandler(eventName, eventHandler);
};
uiHtml_Document.prototype.appendEventHandler = function(eventName, eventHandler) {
  return this.__eventSupporter.appendEventHandler(eventName, eventHandler);
};
uiHtml_Document.prototype.removeEventHandler = function(eventName, startIndex, optCount) {
  this.__eventSupporter.removeEventHandler(eventName, startIndex, optCount);
};
uiHtml_Document.prototype.clearEventHandlerExtension = function(eventName) {
  this.__eventSupporter.clearEventHandlerExtension(eventName);
};
uiHtml_Document.prototype.getPrintStream = function() {
  if (this.__printStream == null) {
    this.__assertLoaded(
        "Cannot get print stream before the window finishes loading");
    this.__printStream = new uiHtml_PrintSupporter(this.getDomObject());
  }
  return this.__printStream;
};
uiHtml_Document.prototype.scrollToTop = function() {
  this.__scrollSupporter.scrollToTop();
};
uiHtml_Document.prototype.scrollToBottom = function() {
  this.__scrollSupporter.scrollToBottom();
};
uiHtml_Document.prototype.getScrollLeft = function() {
  return this.__scrollSupporter.getScrollLeft();
};
uiHtml_Document.prototype.getScrollTop = function() {
  return this.__scrollSupporter.getScrollTop();
};
uiHtml_Document.createDomObject = function(tagName, optAppear, optParent) {
  var domObject = document.createElement(tagName);
  uiHtml_Element._initializeDomObject(domObject, optAppear);
  if (uiUtil_Type.isDefined(optParent)) {
    optParent.appendChild(domObject);
  }  
  return domObject;
};
uiHtml_Document.createTextNode = function(initialText, optParent) {
  var domTextNode = document.createTextNode(initialText);
  if (uiUtil_Type.isDefined(optParent)) {
    optParent.appendChild(domTextNode);
  }  
  return domTextNode;
};
function uiHtml_ElementWrapper() {
  this._super();
}
uiHtml_ElementWrapper = uiUtil_Object.declareClass(
    uiHtml_ElementWrapper, uiUtil_Object);
uiHtml_ElementWrapper.__instance = null;
uiHtml_ElementWrapper.__extendedElements = new Array();
uiHtml_ElementWrapper.prototype.__normalizeStyleAttributeName = function(name) {
  var index;
  while ((index = name.indexOf("-")) >= 0) {
    var nextChar = name.charAt(index + 1);
    name = name.replace(new RegExp("-" + nextChar), nextChar.toUpperCase());
  }
  return name;
};
uiHtml_ElementWrapper.prototype.getCascadedStyleAttribute = function(domElement, name) {
  if (domElement.currentStyle) {  
    return domElement.currentStyle[this.__normalizeStyleAttributeName(name)];
  }
  else if (document.defaultView) {  
    var cascadedStyle = document.defaultView.getComputedStyle(domElement, "");
    return cascadedStyle.getPropertyValue(name);
  }
  else {
    return null;
  }
};
uiHtml_ElementWrapper.prototype.setStyleAttribute = function(
      domElement, name, value) {
  domElement.style[this.__normalizeStyleAttributeName(name)] = value;
};
uiHtml_ElementWrapper.prototype.__getExtendedProperties = function(
    domElement) {
  if (domElement.uitagsProps == null) {
    domElement.uitagsProps = new uiHtml_ElementWrapper.DomExtProps();
    uiHtml_ElementWrapper.__registerElementToFinalize(domElement);
  }
  else if (!(domElement.uitagsProps instanceof
      uiHtml_ElementWrapper.DomExtProps)) {
    throw new uiUtil_IllegalStateException(
        "domElement.uitagsProps is not a valid uitags properties object.");
  }
  return domElement.uitagsProps;
};
uiHtml_ElementWrapper.prototype.__setExtendedProperty = function(
    domElement, key, value) {
  var uitagsProps = this.__getExtendedProperties(domElement);
  uitagsProps[key] = value;
};
uiHtml_ElementWrapper.prototype.__getExtendedProperty = function(
    domElement, key) {
  var uitagsProps = this.__getExtendedProperties(domElement);
  return uitagsProps[key];
};
uiHtml_ElementWrapper.prototype._setClassProperty = function(
    domElement, ownerClass, value) {
  var uitagsProps = this.__getExtendedProperties(domElement);
  var className = uiUtil_Object.getClassName(ownerClass);
  uitagsProps.__classProperty[className] = value;
};
uiHtml_ElementWrapper.prototype._getClassProperty = function(
    domElement, ownerClass) {
  var uitagsProps = this.__getExtendedProperties(domElement);
  var className = uiUtil_Object.getClassName(ownerClass);
  return uitagsProps.__classProperty[className];
};
uiHtml_ElementWrapper.prototype.__getInherittedStyleAttribute = function(
    domElement, attrName, inheritValue, defaultValue) {
  var currentElement = domElement;
  while (currentElement != document.body.parentNode) {
    var styleValue = this.getCascadedStyleAttribute(currentElement, attrName);
    if (styleValue != inheritValue) {
      return styleValue;
    }
    currentElement = currentElement.parentNode;
  }
  return defaultValue;
};
uiHtml_ElementWrapper.prototype.__setShowing = function(domElement, showing) {
  domElement.style.visibility = (showing) ? "visible" : "hidden";
};
uiHtml_ElementWrapper.prototype.isShowing = function(domElement) {
  var styleValue = this.__getInherittedStyleAttribute(
      domElement, "visibility", "inherit", "visible");
  return styleValue == "visible";
};
uiHtml_ElementWrapper.prototype.show = function(domElement) {
  this.__setShowing(domElement, true);
};
uiHtml_ElementWrapper.prototype.hide = function(domElement) {
  this.__setShowing(domElement, false);
};
uiHtml_ElementWrapper.prototype.isAppearing = function(domElement) {
  return this.getCascadedStyleAttribute(domElement, "display") != "none";
};
uiHtml_ElementWrapper.prototype.appear = function(domElement) {
  if (this.isAppearing(domElement)) {
    return;
  }
  var expectedValue = this.__getExtendedProperty(domElement, "__appearDisplay");
  domElement.style.display = expectedValue;
};
uiHtml_ElementWrapper.prototype.disappear = function(domElement) {
  if (!this.isAppearing(domElement)) {
    return;
  }
  var appearValue = this.getCascadedStyleAttribute(domElement, "display");
  this.__setExtendedProperty(domElement, "__appearDisplay", appearValue);
  if (appearValue == null) {
    this.__logger.warn("Display style property is null");
    this.__setExtendedProperty(domElement, "__appearDisplay", "block");
  }
  domElement.style.display = "none";
};
uiHtml_ElementWrapper.prototype.setDepth = function(domElement, depth) {
  if (!uiUtil_Type.isNumber(depth)) {
    throw new uiUtil_IllegalArgumentException("Not a number: " + depth);
  }
  domElement.style.zIndex = depth;
};
uiHtml_ElementWrapper.prototype.getDepth = function(domElement) {
  var origValue = this.__getInherittedStyleAttribute(
      domElement, "z-index", "auto", "0");
  var value = parseInt(origValue);
  if (uiUtil_Type.isNumber(value)) {
    return value;
  }
  throw new uiUtil_IllegalStateException("Depth value is not a valid number");
};
uiHtml_ElementWrapper.prototype.setDimension = function(
    domElement, x, y, width, height) {
  if (x) {
    domElement.style.left = x + "px";
  }
  if (y) {
    domElement.style.top = y + "px";
  }
  if (width) {
    domElement.style.width = width + "px";
  }
  if (height) {
    domElement.style.height = height + "px";
  }
};
uiHtml_ElementWrapper.prototype.setDimensionObject = function(domElement, dimension) {
  this.setDimension(domElement,
      dimension.getLeft(), dimension.getTop(),
      dimension.getWidth(), dimension.getHeight());
};
uiHtml_ElementWrapper.prototype.__addAggregateEventHandler = function(
    domElement, eventName, extPropName, eventHandler) {
  var aggregateHandler = this.__getAggregateEventHandler(
      domElement, eventName, extPropName);
  aggregateHandler.push(eventHandler);
  if (!this.__isEventPropertyInitialized(domElement, eventName)) {
    this._initializeEventProperty(domElement, eventName, 
        this._getActualHandler(domElement, eventName));
  }
  return aggregateHandler.length;
};
uiHtml_ElementWrapper.prototype.__isEventPropertyInitialized = function(
    domElement, eventName) {
  var initializedHandlers = this.__getExtendedProperty(
      domElement, "__initializedEventHandlers");
  return initializedHandlers[eventName] == true;
};
uiHtml_ElementWrapper.prototype._initializeEventProperty = function(
    domElement, eventName, actualHandler) {
  domElement["on" + eventName] = actualHandler;
  var initializedHandlers = this.__getExtendedProperty(
      domElement, "__initializedEventHandlers");
  initializedHandlers[eventName] = true;
};
uiHtml_ElementWrapper.prototype._getActualHandler = function(
    domElement, eventName) {
  var wrapper = this;
  var origHandler = domElement["on" + eventName];
  return function(e) {
    var backwardAggregateHandler = wrapper.__getAggregateEventHandler(
        domElement, eventName, "__backwardEventHandlers");
    for (var i = backwardAggregateHandler.length - 1; i >= 0; --i) {
      backwardAggregateHandler[i].call(this, e);
    }
    var retValue = (origHandler == null) ? null : origHandler.call(this, e);
    var forwardAggregateHandler = wrapper.__getAggregateEventHandler(
        domElement, eventName, "__forwardEventHandlers");
    for (var i = 0; i < forwardAggregateHandler.length; ++i) {
      forwardAggregateHandler[i].call(this, e);
    }
    return retValue;
  };
};
uiHtml_ElementWrapper.prototype.__getAggregateEventHandler = function(
    domElement, eventName, extPropName) {
  var allHandlers = this.__getExtendedProperty(domElement, extPropName);
  if (allHandlers[eventName] == null) {
    allHandlers[eventName] = new Array();
  }
  return allHandlers[eventName];
};
uiHtml_ElementWrapper.prototype.prependEventHandler = function(
    domElement, eventName, eventHandler) {
  return -1 * this.__addAggregateEventHandler(
      domElement, eventName, "__backwardEventHandlers", eventHandler);
};
uiHtml_ElementWrapper.prototype.appendEventHandler = function(
    domElement, eventName, eventHandler) {
  return this.__addAggregateEventHandler(
      domElement, eventName, "__forwardEventHandlers", eventHandler);
};
uiHtml_ElementWrapper.prototype.removeEventHandler = function(
    domElement, eventName, handlerId) {
  var actualIndex;
  var extPropName;
  if (handlerId > 0) {
    actualIndex = handlerId - 1;
    extPropName = "__forwardEventHandlers";
  }
  else if (handlerId < 0) {
    actualIndex = handlerId + 1;
    extPropName = "__backwardEventHandlers";
  }
  else {
    throw new uiUtil_IllegalArgumentException(
        "Handler start index should not be 0");
  }
  var aggregateHandler = this.__getAggregateEventHandler(
      domElement, eventName, extPropName);
  uiUtil_ArrayUtils.removeAt(aggregateHandler, actualIndex);
};
uiHtml_ElementWrapper.prototype.clearEventHandlerExtension = function(
    domElement, eventName) {
  var backwardAggregateHandler = this.__getAggregateEventHandler(
      domElement, eventName, "__backwardEventHandlers");
  uiUtil_ArrayUtils.clear(backwardAggregateHandler);
  var forwardAggregateHandler = this.__getAggregateEventHandler(
      domElement, eventName, "__forwardEventHandlers");
  uiUtil_ArrayUtils.clear(forwardAggregateHandler);
};
uiHtml_ElementWrapper.prototype.executeAggregateEventHandler = function(
    domElement, eventName, optDomEvent) {
  if (domElement["on" + eventName] != null) {
    domElement["on" + eventName].call(domElement, optDomEvent);
  }
};
uiHtml_ElementWrapper.prototype.appendMousePressHandler = function(
    domElement, eventHandler) {
  var supporters = this.__getExtendedProperty(
      domElement, "__mousePressHandlingSupporters");
  supporters.push(new uiHtml_ElementWrapper.MousePressHandlingSupporter(
      domElement, eventHandler));
};
uiHtml_ElementWrapper.prototype.enableDragSupport = function(
    domElement, optTrigger, optSetCoordinate) {
  var supporter = this.__getExtendedProperty(domElement, "__dragSupporter");
  if (supporter == null) {
    var wrapper = this;
    setCoordinate = uiUtil_Type.getValue(optSetCoordinate, function(x, y) {
      wrapper.setDimension(domElement, x, y, null, null);
    });
    supporter = new uiHtml_ElementWrapper.DragSupporter(domElement, setCoordinate);
    supporter.__setDragTrigger(uiUtil_Type.getValue(optTrigger, domElement));
    this.__setExtendedProperty(domElement, "__dragSupporter", supporter)
  }
};
uiHtml_ElementWrapper.prototype.restrictDragging = function(
    domElement, optLeft, optTop, optWidth, optHeight) {
  var supporter = this.__getExtendedProperty(domElement, "__dragSupporter");
  if (supporter == null) {
    throw new uiUtil_IllegalStateException(
        "Drag support has not been enabled");
  }
  supporter.__restrictDragging(optLeft, optTop, optWidth, optHeight);
};
uiHtml_ElementWrapper.prototype.getWidth = function(domElement) {
  return domElement.offsetWidth;
};
uiHtml_ElementWrapper.prototype.getHeight = function(domElement) {
  return domElement.offsetHeight;
};
uiHtml_ElementWrapper.prototype._obtainImmediateRelativeDimension = function(
    domElement, width, height) {
  return new uiUtil_Dimension(
      domElement.offsetLeft, domElement.offsetTop, width, height);
};
uiHtml_ElementWrapper.prototype._obtainRelativeDimension = function(
    domElement, width, height) {
  var x = 0;
  var y = 0;
  var currentElement = domElement;
  do {
    if (uiHtml_Element.getTagName(currentElement) == "body") {
      break;
    }
    x += currentElement.offsetLeft;
    y += currentElement.offsetTop;
    currentElement = currentElement.offsetParent;    
  } 
  while (currentElement != null && this.getCascadedStyleAttribute(
      currentElement, "position") != "absolute");
  return new uiUtil_Dimension(x, y, width, height);
};
uiHtml_ElementWrapper.prototype._getDimension = function(
    domElement, obtainDimension, getWidth, getHeight) {
  if (!this.isAppearing(domElement)) {
    var showing = this.isShowing(domElement);  
    this.hide(domElement);
    this.appear(domElement);  
    var dimension = obtainDimension.call(
        this, domElement, getWidth(), getHeight());
    this.__setShowing(domElement, showing);
    this.disappear(domElement);
    return dimension;
  }
  return obtainDimension.call(
      this, domElement, getWidth(), getHeight());
};
uiHtml_ElementWrapper.prototype.getImmediateRelativeDimension =
    function(domElement) {
  var wrapper = this;
  return this._getDimension(domElement, this._obtainImmediateRelativeDimension,
      function() { return wrapper.getWidth(domElement); },
      function() { return wrapper.getHeight(domElement); });
};
uiHtml_ElementWrapper.prototype.getRelativeDimension = function(domElement) {
  var wrapper = this;
  return this._getDimension(domElement, this._obtainRelativeDimension,
      function() { return wrapper.getWidth(domElement); },
      function() { return wrapper.getHeight(domElement); });
};
uiHtml_ElementWrapper.prototype.clearChildDomObjects = function(domElement) {
  while (domElement.hasChildNodes()) {
    domElement.removeChild(domElement.firstChild);
  }
};
uiHtml_ElementWrapper.prototype.getLogicalValue = function(domElement) {
  return domElement.value;
};
uiHtml_ElementWrapper.prototype.isDisabled = function(domElement) {
  return domElement.disabled;
};
uiHtml_ElementWrapper.prototype.setDisabled = function(domElement, value) {
  domElement.disabled = value;
};
uiHtml_ElementWrapper.getInstance = function() {
  if (uiHtml_ElementWrapper.__instance == null) {
    uiHtml_ElementWrapper.__instance = new uiHtml_ElementWrapper();
  }
  return uiHtml_ElementWrapper.__instance;
};
uiHtml_ElementWrapper.__registerElementToFinalize = function(domElement) {
  if (uiHtml_Window.getInstance().isIe()) {
    uiHtml_ElementWrapper.__extendedElements.push(domElement);
  }
};
uiHtml_ElementWrapper._finalizeElements = function() {
  if (uiHtml_Window.getInstance().isIe()) {
    var wrapper = uiHtml_ElementWrapper.getInstance();
    for (var i = 0; i < uiHtml_ElementWrapper.__extendedElements.length; ++i) {
      var domElement = uiHtml_ElementWrapper.__extendedElements[i];
      var initializedHandlers = wrapper.__getExtendedProperty(
        domElement, "__initializedEventHandlers");
      for (var eventName in initializedHandlers) {
        domElement["on" + eventName] = null;
      }
      domElement.uitagsProps = null;
    }
  }
};
function uiHtml_ElementWrapper$DomExtProps() {
  this._super();
  this.__appearDisplay = "inline";
  this.__initializedEventHandlers = new Object();
  this.__backwardEventHandlers = new Object();
  this.__forwardEventHandlers = new Object();
  this.__dragSupporter = null;
  this.__classProperty = new Object();
  this.__mousePressHandlingSupporters = new Array();
}
uiHtml_ElementWrapper.DomExtProps = uiUtil_Object.declareClass(
    uiHtml_ElementWrapper$DomExtProps, uiUtil_Object);
function uiHtml_ElementWrapper$MousePressHandlingSupporter(domElement, eventHandler) {
  this.__intervalTimerId = null;
  this.__initialTimerId = null;
  var supporter = this;
  var wrapper = uiHtml_ElementWrapper.getInstance();
  wrapper.appendEventHandler(domElement, "mouseout", function(e) {
    supporter.__cancelTimer();
  });
  wrapper.appendEventHandler(domElement, "mouseup", function(e) {
    supporter.__cancelTimer();
  });
  wrapper.appendEventHandler(domElement, "mousedown", function(e) {
    eventHandler.call(this);
    supporter.__initialTimerId = window.setTimeout(function(e) {
      supporter.__intervalTimerId = window.setInterval(function(e) {
        eventHandler.call(this);
      }, 50);
    }, 200);
  });
}
uiHtml_ElementWrapper.MousePressHandlingSupporter = uiUtil_Object.declareClass(
    uiHtml_ElementWrapper$MousePressHandlingSupporter, uiUtil_Object);
uiHtml_ElementWrapper.MousePressHandlingSupporter.prototype.__cancelTimer = function() {
  window.clearInterval(this.__intervalTimerId);
  window.clearTimeout(this.__initialTimerId);
};
function uiHtml_ElementWrapper$DragSupporter(domElement, setCoordinate) {
  this.__ieUnselectableDomElements = null;
  this.__mouseUpHandlerIndex = 0;
  this.__mouseMoveHandlerIndex = 0;
  this.__domElement = domElement;
  this.__trigger = null;
  this.__leftDistance = -1;
  this.__topDistance = -1;
  this.__setCoordinate = setCoordinate;
  this.__restrict = false;
  this.__borderLeft = -1;
  this.__borderTop = -1;
  this.__borderRight = -1;
  this.__borderBottom = -1;
}
uiHtml_ElementWrapper.DragSupporter = uiUtil_Object.declareClass(
    uiHtml_ElementWrapper$DragSupporter, uiUtil_Object);
uiHtml_ElementWrapper.DragSupporter.prototype.__setDragTrigger = function(trigger) {
  this.__trigger = trigger;
  var dragger = this;
  this.__trigger.appendEventHandler("mousedown", function(e) {
    dragger.__startDrag(e);
  });
  this.__trigger.setStyleAttribute("cursor", "move");
};
uiHtml_ElementWrapper.DragSupporter.prototype.__initDragBoundary = function(
    maxWidth, maxHeight) {
  var uiWindow = uiHtml_Window.getInstance();
  this.__dragMaxWidth = (maxWidth) ? maxWidth : uiWindow.getWidth();
  this.__dragMaxHeight = (maxHeight) ? maxHeight : uiWindow.getHeight();
};
uiHtml_ElementWrapper.DragSupporter.prototype.__restrictDragging = function(
    optLeft, optTop, optMaxWidth, optMaxHeight) {
  this.__restrict = true;
  this.__borderLeft = (optLeft) ? optLeft : 0;
  this.__borderTop = (optTop) ? optTop : 0;
  this.__initDragBoundary(optMaxWidth, optMaxHeight);
  var element = this;
  uiHtml_Window.getInstance().appendEventHandler("resize", function(e) {
    element.__initDragBoundary(optMaxWidth, optMaxHeight);
  });
}
uiHtml_ElementWrapper.DragSupporter.prototype.__startDrag = function(e) {
  this.__logger.debug("Start drag");
  var uiDoc = uiHtml_Document.getInstance();
  if (this.__mouseMoveHandlerIndex != 0) {
    uiDoc.removeEventHandler("mousemove", this.__mouseMoveHandlerIndex);
  }
  if (this.__mouseUpHandlerIndex != 0) {
    uiDoc.removeEventHandler("mouseup", this.__mouseUpHandlerIndex);
  }
  var dragger = this;
  this.__mouseMoveHandlerIndex = uiDoc.appendEventHandler("mousemove", function(e) {
    dragger.__drag(e);
  });
  this.__mouseUpHandlerIndex = uiDoc.appendEventHandler("mouseup", function(e) {
    dragger.__endDrag(e);
  });
  var event = new uiHtml_Event(e);
  var position = event.getViewPortPosition();
  var dimension = uiHtml_ElementWrapper.getInstance().
      getImmediateRelativeDimension(this.__domElement);
  this.__leftDistance = position.getLeft() - dimension.getLeft();
  this.__topDistance = position.getTop() - dimension.getTop();
  if (this.__restrict) {
    this.__borderRight = this.__dragMaxWidth - dimension.getWidth();
    this.__borderBottom = this.__dragMaxHeight - dimension.getHeight();
  }
  if (uiHtml_Window.getInstance().isIe()) {
    this.__ieMakeUnselectableRecursively(this.__domElement);
  }
  else {
    event.preventDefault();
  }
};
uiHtml_ElementWrapper.DragSupporter.prototype
    .__ieMakeUnselectable = function(domElement) {
  if (domElement.unselectable != "on") {
    domElement.unselectable = "on";
    this.__ieUnselectableDomElements.push(domElement);
  }
};
uiHtml_ElementWrapper.DragSupporter.prototype
    .__ieMakeUnselectableRecursively = function(domElement) {
  this.__logger.debug("Make unselectable");
  if (this.__ieUnselectableDomElements == null) {
    this.__ieUnselectableDomElements = new Array();
  }
  this.__ieMakeUnselectable(domElement);
  var childNodes = domElement.childNodes;
  for (var i = 0; i < childNodes.length; ++i) {
    var node = childNodes.item(i);
    if (!uiUtil_Type.isTextNode(node)) {
      this.__ieMakeUnselectableRecursively(node);
    }
  }
};
uiHtml_ElementWrapper.DragSupporter.prototype.__ieCancelUnselectable = function() {
  if (this.__ieUnselectableDomElements != null) {
    this.__logger.debug("cancel unselectable");
    for (var i = 0; i < this.__ieUnselectableDomElements.length; ++i) {
      this.__ieUnselectableDomElements[i].unselectable = "off";
    }
    this.__ieUnselectableDomElements = null;
  }
};
uiHtml_ElementWrapper.DragSupporter.prototype.__drag = function(e) {
  var position = uiHtml_Event.getViewPortPosition(e);
  var x = position.getLeft() - this.__leftDistance;
  var y = position.getTop() - this.__topDistance;
  this.__logger.debug(position.getLeft() + ", " +
      position.getTop() + " => " + x + ", " + y);
  if (this.__restrict) {
    if (x < this.__borderLeft) {
      x = this.__borderLeft;
    }
    else if (x > this.__borderRight) {
      x = this.__borderRight;
    }
    if (y < this.__borderTop) {
      y = this.__borderTop;
    }
    else if (y > this.__borderBottom) {
      y = this.__borderBottom;
    }
  }
  this.__setCoordinate(x, y);
};
uiHtml_ElementWrapper.DragSupporter.prototype.__endDrag = function(e) {
  this.__logger.debug("End drag");
  uiHtml_Document.getInstance().removeEventHandler(
      "mousemove", this.__mouseMoveHandlerIndex);
  uiHtml_Document.getInstance().removeEventHandler(
      "mouseup", this.__mouseUpHandlerIndex);
  this.__mouseMoveHandlerIndex = 0;
  this.__mouseUpHandlerIndex = 0;
  if (uiHtml_Window.getInstance().isIe()) {
    this.__ieCancelUnselectable();  
  }
};
function uiHtml_RadioWrapper() {
  this._super();
}
uiHtml_RadioWrapper =
    uiUtil_Object.declareSingleton(uiHtml_RadioWrapper, uiHtml_ElementWrapper);
uiHtml_RadioWrapper.__selectedRadio = new Array();
uiHtml_RadioWrapper.prototype.appendEventHandler = function(domRadio, event, handler) {
  var isOpera = uiHtml_Window.getInstance().isOpera();
  var isIe = uiHtml_Window.getInstance().isIe();
  if (event == "change" && (isOpera || isIe)) {
    if (domRadio.checked) {
      uiHtml_RadioWrapper.__selectedRadio[domRadio.name] = domRadio;
    }
    var wrapper = this;
    return this._callSuper(
        "appendEventHandler", domRadio, "click", function(e) {
      var previouslySelected =
          uiHtml_RadioWrapper.__selectedRadio[domRadio.name];
      if (previouslySelected != domRadio) {
        handler();
        uiHtml_RadioWrapper.__selectedRadio[domRadio.name] = domRadio;
      }
    });
  }
  else {
    return this._callSuper("appendEventHandler", domRadio, event, handler);
  }
};
uiHtml_RadioWrapper.prototype.isSelected = function(domRadio) {
  return domRadio.checked;
};
uiHtml_RadioWrapper.prototype.setSelected = function(domRadio, value, optDomEvent) {
  if (domRadio.checked != value) {
    domRadio.checked = value;
    this.executeAggregateEventHandler(domRadio, "change", optDomEvent);
  }
};
uiHtml_RadioWrapper.prototype.getLogicalValue = function(domElement) {
  return (this.isSelected(domElement))? domElement.value : null;
};
function uiHtml_CheckBoxWrapper() {
  this._super();
}
uiHtml_CheckBoxWrapper =
    uiUtil_Object.declareSingleton(uiHtml_CheckBoxWrapper, uiHtml_ElementWrapper);
uiHtml_CheckBoxWrapper.prototype.prependEventHandler = function(
    domCheckBox, eventName, eventHandler) {
  throw new uiUtil_IllegalStateException("Currently not supported", new Error());
};
uiHtml_CheckBoxWrapper.prototype.appendEventHandler = function(
    domCheckBox, eventName, eventHandler) {
  if (eventName == "change" && uiHtml_Window.getInstance().isIe()) {
    return this._callSuper(
        "appendEventHandler", domCheckBox, "click", eventHandler);
  }
  else {
    return this._callSuper("appendEventHandler", 
        domCheckBox, eventName, eventHandler);
  }
};
uiHtml_CheckBoxWrapper.prototype.isSelected = function(domCheckBox) {
  return domCheckBox.checked;
};
uiHtml_CheckBoxWrapper.prototype.setSelected = function(
    domCheckBox, value, optDomEvent) {
  if (domCheckBox.checked != value) {
    domCheckBox.checked = value;
    this.executeAggregateEventHandler(domCheckBox, "change", optDomEvent);
  }
};
uiHtml_CheckBoxWrapper.prototype.getLogicalValue = function(domElement) {
  return (this.isSelected(domElement))? domElement.value : null;
};
function uiHtml_SelectOptionWrapper() {
  this._super();
}
uiHtml_SelectOptionWrapper =
    uiUtil_Object.declareSingleton(uiHtml_SelectOptionWrapper, uiHtml_ElementWrapper);
uiHtml_SelectOptionWrapper.__ieDisablingInitialized = false;
uiHtml_SelectOptionWrapper.prototype.isSelected = function(domOption) {
  return domOption.selected;
};
uiHtml_SelectOptionWrapper.prototype.setSelected = function(
    domOption, value, optDomEvent) {
  if (domOption.selected != value) {
    domOption.selected = value;
    var domSelect = domOption.parentNode;
    if (domSelect != null &&
        uiHtml_Element.getWidgetType(domSelect) == "select") {
      this.executeAggregateEventHandler(domSelect, "change", optDomEvent);
    }
  }
};
uiHtml_SelectOptionWrapper.prototype.setDisabled = function(
    domOption, value) {
  domOption.disabled = value;
  if (uiHtml_Window.getInstance().isIe()) {
    var extProps = this.__getOptionExtProps(domOption);
    if (domOption.disabled) {
      if (!uiHtml_SelectOptionWrapper.__ieDisablingInitialized) {
        this.__initializeIeDisabling(domOption);
      }
      extProps.__originalColor = this.getCascadedStyleAttribute(
          domOption, "color");
      this.setStyleAttribute(domOption, "color", "gray");
    }
    else {
      this.setStyleAttribute(domOption, "color", extProps.__originalColor);
    }
  }
}
uiHtml_SelectOptionWrapper.prototype.__initializeIeDisabling = function(domOption) {
  var domSelect = domOption.parentNode;
  if (domSelect != null &&
      uiHtml_Element.getWidgetType(domSelect) == "select") {
    this.appendEventHandler(domSelect, "change", function(e) {
      for (var i = 0; i < domSelect.options.length; ++i) {
        var domOption = domSelect.options[i];
        if (domOption.disabled && domOption.selected) {
          domOption.selected = false;
        }
      }
    });
  }
  uiHtml_SelectOptionWrapper.__ieDisablingInitialized = true;
}
uiHtml_SelectOptionWrapper.prototype.__getOptionExtProps = function(domOption) {
  var extProps = this._getClassProperty(domOption, uiHtml_SelectOptionWrapper);
  if (extProps == null) {
    extProps = new uiHtml_SelectOptionWrapper.DomExtProps();
    this._setClassProperty(domOption, uiHtml_SelectOptionWrapper, extProps);
  }
  return extProps;
}
uiHtml_SelectOptionWrapper.prototype.getLogicalValue = function(domElement) {
  return (this.isSelected(domElement))? domElement.value : null;
};
uiHtml_SelectOptionWrapper.prototype.clone = function(domOption) {
  var newOption = domOption.cloneNode(false);
  newOption.text = domOption.text;
  newOption.selected = domOption.selected;
  newOption.defaultSelected = domOption.defaultSelected;
  return newOption;
};
uiHtml_SelectOptionWrapper.prototype.equals = function(domOption1, domOption2) {
  return domOption1.value == domOption2.value;
};
uiHtml_SelectOptionWrapper.create = function(text, value, optDefaultSelected, optSelected) {
  var domOption = new Option(text, value,
      uiUtil_Type.getBoolean(optDefaultSelected, false),
      uiUtil_Type.getBoolean(optSelected, false));
  return domOption;
};
function uiHtml_SelectOptionWrapper$DomExtProps() {
  this.__originalColor = "black";
}
uiHtml_SelectOptionWrapper.DomExtProps = uiUtil_Object.declareClass(
    uiHtml_SelectOptionWrapper$DomExtProps, uiUtil_Object);
function uiHtml_Group(domObjects, optHandler) {
  this._super();
  this.__items = domObjects;
  this.__handler = optHandler;
  if (this.__handler == null) {
    var firstItem = domObjects[0];
    if (firstItem == null) {
      throw new uiUtil_IllegalStateException(
          "A group should contain at least one item.");
    }
    this.__handler = uiHtml_Group.__getWrapper(firstItem);
  }
}
uiHtml_Group = uiUtil_Object.declareClass(uiHtml_Group, uiUtil_Object);
uiHtml_Group.prototype.prependEventHandler = function(
    eventName, eventHandler) {
  throw new uiUtil_IllegalStateException("Currently not supported", new Error());
};
uiHtml_Group.prototype.appendEventHandler = function(event, handler) {
  for (var i = 0; i < this.__items.length; ++i) {
    this.__handler.appendEventHandler(this.__items[i], event, handler);
  }
  return 0;
};
uiHtml_Group.prototype.removeEventHandler = function(
    eventName, startIndex) {
  throw new uiUtil_IllegalStateException("Currently not supported", new Error());
};
uiHtml_Group.prototype.clearEventHandlerExtension = function(eventName) {
  throw new uiUtil_IllegalStateException("Currently not supported", new Error());
};
uiHtml_Group.prototype.executeAggregateEventHandler = function(
    eventName, optDomEvent) {
  for (var i = 0; i < this.__items.length; ++i) {
    this.__handler.executeAggregateEventHandler(
        this.__items[i], eventName, optDomEvent);
  }
};
uiHtml_Group.prototype.__constructItemArgs = function(item, args) {
  var argArray = new Array();
  var outputIndex = 0;
  argArray[outputIndex++] = item;
  var start = args.callee.length - 1;
  for (var i = start; i < args.length; ++i) {
    argArray[outputIndex++] = args[i];
  }
  return argArray;
};
uiHtml_Group.prototype.traverse = function(
    handlerOwner, handlerFunction, optArgN) {
  var argArray = this.__constructItemArgs(null, arguments);
  var results = new Array(this.__items.length);
  for (var i = 0; i < this.__items.length; ++i) {
    argArray[0] = this.__items[i];
    results[i] = handlerFunction.apply(handlerOwner, argArray);
  }
  return results;
};
uiHtml_Group.prototype.getItemHandler = function() {
  return this.__handler;
};
uiHtml_Group.prototype.size = function() {
  return this.__items.length;
};
uiHtml_Group.prototype.getItemAt = function(index) {
  return this.__items[index];
};
uiHtml_Group.prototype.setItemAt = function(index, item) {
  this.__items = uiUtil_ArrayUtils.toArrayIfNotAlready(this.__items);
  this.__items[index] = item;
};
uiHtml_Group.prototype.addItem = function(item) {
  this.__items = uiUtil_ArrayUtils.toArrayIfNotAlready(this.__items);
  this.__items.push(item);
};
uiHtml_Group.prototype._getItems = function() {
  return this.__items;
};
uiHtml_Group.prototype.hasValue = function(value) {
  for (var i = 0; i < this.__items.length; ++i) {
    if (this.__handler.getLogicalValue(this.__items[i]) == value) {
      return true;
    }
  }
  return false;
};
uiHtml_Group.prototype.getValues = function() {
  var values = new Array();
  for (var i = 0; i < this.__items.length; ++i) {
    var value = this.__handler.getLogicalValue(this.__items[i]);
    if (value != null) {
      values.push(value);
    }
  }
  return values;
};
uiHtml_Group.prototype.handleItemAtIndex = function(
    index, handlerOwner, handlerFunction, optArgN) {
  if (index < 0 || index >= this.__items.length) {
    throw new uiUtil_IllegalArgumentException("Invalid index " + index);
  }
  var argArray = this.__constructItemArgs(this.__items[index], arguments);
  return handlerFunction.apply(handlerOwner, argArray);
};
uiHtml_Group.prototype.handleItemWithValue = function(
    value, handlerOwner, handlerFunction, optArgN) {
  for (var i = 0; i < this.__items.length; ++i) {
    if (this.__items[i].value == value) {
      var argArray = this.__constructItemArgs(this.__items[i], arguments);
      return handlerFunction.apply(handlerOwner, argArray);
    }
  }
  throw new uiUtil_IllegalArgumentException("Invalid value " + value);
};
uiHtml_Group.__getDomObjectsByEither = function(id, name) {
  var domObjects;
  var domObject = uiHtml_Document.getInstance().getDomObjectById(id, false);
  if (domObject == null) {
    domObjects = uiHtml_Document.getInstance().getDomObjectsByName(name, false);
  }
  else {
    domObjects = new Array(domObject);
  }
  if (domObjects[0] == null) {
    throw new uiUtil_IllegalArgumentException(
        "Invalid element ID: " + id + " and name: " + name);
  }
  return domObjects;
};
uiHtml_Group.createByEither = function(id, name) {
  var domObjects = uiHtml_Group.__getDomObjectsByEither(id, name);
  try {
    if (uiHtml_Element.getWidgetType(domObjects[0]) == "select") {
      return new uiHtml_Select(domObjects[0]);
    }
    else {
      return new uiHtml_Group(domObjects);
    }
  }
  catch (e) {
    if (e instanceof uiUtil_Exception) {
      throw new uiUtil_CreateException("[" + name + "] " + e.getMessage());
    }
  }
};
uiHtml_Group.__getWrapper = function(domElement) {
  switch(uiHtml_Element.getWidgetType(domElement)) {
    case "checkbox" :
        return uiHtml_CheckBoxWrapper.getInstance();
    case "radio"    :
        return uiHtml_RadioWrapper.getInstance();
    default         :
        return uiHtml_ElementWrapper.getInstance();
  }
};
function uiHtml_Select(domSelect, optOptions) {
  this._super(domSelect);
  this.__domSelect = domSelect;
  this.__options = domSelect.options;
  this.__optionMap = new Object();
  this.__valueMapping = false;
  this.__handler = uiHtml_SelectOptionWrapper.getInstance();
  this.__group = new uiHtml_Group(this.__options, this.__handler);
  this.__scrollSupporter = new uiHtml_ScrollSupporter(this.__domSelect);
  if (optOptions != null) {
    this.addItems(optOptions);
  }
}
uiHtml_Select = uiUtil_Object.declareClass(uiHtml_Select, uiHtml_Element);
uiHtml_Select.INVALID_INDEX = -1;
uiHtml_Select.HISTORY_UPPER_LIMIT = 20;
uiHtml_Select.HISTORY_REMOVE_RATE  = 5;
uiHtml_Select.__historyEnabled = new Array();
uiHtml_Select.prototype.getItemHandler = function() {
  return this.__group.getItemHandler();
};
uiHtml_Select.prototype.size = function() {
  return this.__group.size();
};
uiHtml_Select.prototype.getItemAt = function(index) {
  return this.__group.getItemAt(index);
};
uiHtml_Select.prototype._getItems = function() {
  return this.__group._getItems();
};
uiHtml_Select.prototype.hasValue = function(value) {
  return this.__group.hasValue(value);
};
uiHtml_Select.prototype.getValues = function() {
  return this.__group.getValues();
};
uiHtml_Select.prototype.handleItemAtIndex = function(index, owner, handler) {
  return this.__group.handleItemAtIndex.apply(this.__group, arguments);
};
uiHtml_Select.prototype.handleItemWithValue = function(value, owner, handler) {
  return this.__group.handleItemWithValue.apply(this.__group, arguments);
};
uiHtml_Select.prototype.traverse = function(handlerOwner, handlerFunction, optArgN) {
  this.__group.traverse.apply(this.__group, arguments);
};
uiHtml_Select.prototype.setItemAt = function(index, item) {
  this.__options[index] = item;
};
uiHtml_Select.prototype.addItem = function(option) {
  this.__options.add(option);
  if (this.__valueMapping) {
    this.__optionMap[option.value] = option;
  }
};
uiHtml_Select.prototype.enableOptionValueMapping = function() {
  this.__valueMapping = true
  var listLength = this.size();
  for (var i = 0; i < listLength; ++i) {
    var option = this.getItemAt(i);
    this.__optionMap[option.value] = option;
  }
}
uiHtml_Select.prototype.showScrollBars = function(always) {
  this.__scrollSupporter.showScrollBars(always);
};
uiHtml_Select.prototype.hideScrollBars = function() {
  this.__scrollSupporter.hideScrollBars();
};
uiHtml_Select.prototype.scrollToTop = function() {
  this.__scrollSupporter.scrollToTop();
};
uiHtml_Select.prototype.scrollToBottom = function() {
  if (uiHtml_Window.getInstance().isIe()) {
    var selectedItems = new Array();
    var listLength = this.size();
    for (var i = 0; i < listLength; ++i) {
      var item = this.getItemAt(i);
      if (this.__handler.isSelected(item)) {
        selectedItems.push(item);
      }
    }
    var domSelect = this.__domSelect;
    domSelect.multiple = false;
    window.setTimeout(function(e) {
      domSelect.selectedIndex = listLength - 1;
    }, 50);  
    window.setTimeout(function(e) {
      domSelect.multiple = true;
    }, 10);
    var item = this.getItemAt(listLength - 1);
    item.selected = false;
    window.setTimeout(function(e) {
      for (var i = 0; i < selectedItems.length; ++i) {
        selectedItems[i].selected = true;
      }
    }, 100);
  }
  else {
    this.__scrollSupporter.scrollToBottom();
  }
};
uiHtml_Select.prototype.getDomObject = function() {
  return this.__domSelect;
};
uiHtml_Select.prototype.getItemByValue = function(value) {
  if (!this.__valueMapping) {
    throw new uiUtil_IllegalStateException(
        "Option value mapping is not enabled");
  }
  return this.__optionMap[value];
};
uiHtml_Select.prototype.addItems = function(options) {
  for (var i = 0; i < options.length; ++i) {
    this.addItem(options[i]);
  }
};
uiHtml_Select.prototype.sortItems = function(comparator, reverse) {
  var options = this.__domSelect.options;
  var tempArray = new Array(options.length);
  for(var i = 0; i < options.length; ++i) {
    tempArray[i] = options[i];
  }
  tempArray.sort(function(a, b) {
    return comparator.compare(a,b);
  })
  if (reverse) {
    tempArray.reverse();
  }
  this.clearItems();
  for (var i = 0; i < tempArray.length; ++i) {
    options.add(tempArray[i]);
  }
};
uiHtml_Select.prototype.setSelectedIndex = function(index, optDomEvent) {
  this.setSelectedItem(this.__options[index], optDomEvent);
};
uiHtml_Select.prototype.setSelectedItem = function(item, optDomEvent) {
  this.__handler.setSelected(item, true, optDomEvent);
};
uiHtml_Select.prototype.setSelectedValue = function(value, optDomEvent) {
  var option = this.getItemByValue(value);
  this.setSelectedItem(option, optDomEvent);
};
uiHtml_Select.prototype.clearItems = function() {
  var options = this.__domSelect.options;
  while (options.length > 0) {
    options[0] = null;
  }
};
uiHtml_Select.prototype.removeItemAt = function(index) {
  this.__options[index] = null;
};
uiHtml_Select.prototype.enableHistoryTracking = function() {
  var id = this.__domSelect.id;
  if (!uiHtml_Select.__historyEnabled[id]) {
    uiHtml_Select.__historyEnabled[id] = this;
    this.__changeHistory = new uiUtil_Vector(new Array());
    this.__historyIndex = -1;
    this.__lastSelected = new Array();
    this.__pushHistory();  
    var select = this;
    this.appendEventHandler("change", function(e) {
      select.__pushHistory();
    });
    this.appendEventHandler("keydown", function(e) {
      var event = new uiHtml_Event(e);
      if (!event.isAltPressed() &&
          event.isCtrlPressed() &&
          !event.isShiftPressed()) {
        var ch = event.getPressedChar(true);
        if (ch == "z") {  
          select.__undoHistory(e);
        }
        else if (ch == "y") {  
          select.__redoHistory(e);
        }
      }
    });
  }
};
uiHtml_Select.prototype.__pushHistory = function() {
  var currSelected = new Array();
  var options = this.__domSelect.options;
  for(var i = 0; i < options.length; ++i) {
    if (this.__handler.isSelected(options[i])) {
      currSelected[options[i].value] = options[i];
    }
  }
  if (this.__historyIndex < this.__changeHistory.length - 1) {
    this.__changeHistory.removeAt(
        -1, this.__changeHistory.length - this.__historyIndex - 1);
  }
  var currChanges = this.__getChanges(currSelected, this.__lastSelected);
  this.__changeHistory.add(currChanges);
  if (this.__changeHistory.length >= uiHtml_Select.HISTORY_UPPER_LIMIT) {
    this.__changeHistory.removeAt(0, uiHtml_Select.HISTORY_REMOVE_RATE);
  }
  this.__historyIndex = this.__changeHistory.length - 1;
  this.__lastSelected = currSelected;
  this.__logger.debug("history size: " + this.__changeHistory.length);
};
uiHtml_Select.prototype.__getChanges = function(currSelected, lastSelected) {
  var changes = new Array();
  for (var key in currSelected) {
    if (!lastSelected[key] && currSelected[key]) {  
      changes.push(currSelected[key]);
    }
  }
  for (var key in lastSelected) {
    if (!currSelected[key] && lastSelected[key]) {  
      changes.push(lastSelected[key]);
    }
  }
  return changes;
};
uiHtml_Select.prototype.__undoHistory = function(domEvent) {
  if (this.__historyIndex < 1) {
    return;
  }
  this.__playHistory(domEvent, this.__historyIndex--);
};
uiHtml_Select.prototype.__redoHistory = function(domEvent) {
  if (this.__historyIndex >= this.__changeHistory.length - 1) {
    return;
  }
  this.__playHistory(domEvent, ++this.__historyIndex);
};
uiHtml_Select.prototype.__playHistory = function(domEvent, historyIndex) {
  var changes = this.__changeHistory.get(historyIndex);
  for (var i = 0; i < changes.length; ++i) {
    var selected = this.__handler.isSelected(changes[i]);
    var key = changes[i].value;
    if (selected) {
      this.__handler.setSelected(changes[i], false, domEvent);
      this.__lastSelected[key] = null;
    }
    else {
      this.__handler.setSelected(changes[i], true, domEvent);
      this.__lastSelected[key] = changes[i];
    }
  }
};
uiHtml_Select.createByEither = function(id, name) {
  return uiHtml_Element.createByEither(id, name, uiHtml_Select);
};
uiHtml_Select.create = function(options, optAppear) {
  return new uiHtml_Select(
      uiHtml_Document.getInstance().createDomObject("select", optAppear), options);
};
function uiHtml_Toggle(triggerOn, triggerOff, initialIsOn, toggleEvent) {
  this._super();
  this.__triggerOn = triggerOn;
  this.__debugId = this.__triggerOn.getDomObject().id;
  this.__onPropertyArray = new Array();
  this.__offPropertyArray = new Array();
  this.__toggleEvent = uiUtil_Type.getString(
      toggleEvent, uiHtml_Toggle.DEFAULT_EVENT);
  if (triggerOff != null) {  
    this.__triggerOff = triggerOff;
    this.__strategyDisplayOn = this.__doubleDisplayOn;
    this.__strategyDisplayOff = this.__doubleDisplayOff;
    this.__strategyAppendOnStateOn = this.__doubleAppendOnStateOn;
    this.__strategyAppendOnStateOff = this.__doubleAppendOnStateOff;
    this.__strategyPrependOnStateOn = this.__doublePrependOnStateOn;
    this.__strategyPrependOnStateOff = this.__doublePrependOnStateOff;
    var toggle = this;
    this.__triggerOn.prependEventHandler(this.__toggleEvent, function(e) {
      toggle.switchOff();
    });
    this.__triggerOff.prependEventHandler(this.__toggleEvent, function(e) {
      toggle.switchOn();
    });
  }
  else {  
    this.__triggerOff = this.__triggerOn;  
    this.__strategyDisplayOn = this.__singleDisplayOn;
    this.__strategyDisplayOff = this.__singleDisplayOff;
    this.__strategyAppendOnStateOn = this.__singleAppendOnStateOn;
    this.__strategyAppendOnStateOff = this.__singleAppendOnStateOff;
    this.__strategyPrependOnStateOn = this.__singlePrependOnStateOn;
    this.__strategyPrependOnStateOff = this.__singlePrependOnStateOff;
    var toggle = this;
    this.__triggerOn.prependEventHandler(this.__toggleEvent, function(e) {
      toggle._switchState();
    });
  }
  if (uiUtil_Type.getBoolean(initialIsOn, true)) {
    this.switchOn();
  }
  else {
    this.switchOff();
  }
}
uiHtml_Toggle = uiUtil_Object.declareClass(uiHtml_Toggle, uiUtil_Object);
uiHtml_Toggle.DEFAULT_EVENT = "click";
uiHtml_Toggle.__toggles = new Array();
uiHtml_Toggle.prototype._switchState = function() {
  if (this.__stateOn) {
    this.switchOff();
  }
  else {
    this.switchOn();
  }
};
uiHtml_Toggle.prototype.switchOn = function() {
  this.__logger.info("switching on " + this.__debugId);
  this.__stateOn = true;
  this.__strategyDisplayOn();
  var domTrigger = this.__triggerOn.getDomObject();
  for (prop in this.__onPropertyArray) {
    domTrigger[prop] = this.__onPropertyArray[prop];
  }
};
uiHtml_Toggle.prototype.switchOff = function() {
  this.__logger.info("switching off " + this.__debugId);
  this.__stateOn = false;
  this.__strategyDisplayOff();
  var domTrigger = this.__triggerOff.getDomObject();
  for (prop in this.__offPropertyArray) {
    domTrigger[prop] = this.__offPropertyArray[prop];
  }
};
uiHtml_Toggle.prototype.appendOnStateOn = function(eventHandler) {
  this.__strategyAppendOnStateOn(eventHandler);
};
uiHtml_Toggle.prototype.appendOnStateOff = function(eventHandler) {
  this.__strategyAppendOnStateOff(eventHandler);
};
uiHtml_Toggle.prototype.setOnProperties = function(propArray) {
  this.__onPropertyArray = propArray;
};
uiHtml_Toggle.prototype.setOffProperties = function(propArray) {
  this.__offPropertyArray = propArray;
};
uiHtml_Toggle.prototype.__doubleDisplayOn = function() {
  this.__triggerOff.disappear();
  this.__triggerOn.appear();
};
uiHtml_Toggle.prototype.__doubleDisplayOff = function() {
  this.__triggerOn.disappear();
  this.__triggerOff.appear();
};
uiHtml_Toggle.prototype.__doublePrependOnStateOn = function(eventHandler) {
  this.__triggerOff.prependEventHandler(this.__toggleEvent, eventHandler);
};
uiHtml_Toggle.prototype.__doublePrependOnStateOff = function(eventHandler) {
  this.__triggerOn.prependEventHandler(this.__toggleEvent, eventHandler);
};
uiHtml_Toggle.prototype.__doubleAppendOnStateOn = function(eventHandler) {
  this.__triggerOff.appendEventHandler(this.__toggleEvent, eventHandler);
};
uiHtml_Toggle.prototype.__doubleAppendOnStateOff = function(eventHandler) {
  this.__triggerOn.appendEventHandler(this.__toggleEvent, eventHandler);
};
uiHtml_Toggle.prototype.__singleDisplayOn = function() {
};
uiHtml_Toggle.prototype.__singleDisplayOff = function() {
};
uiHtml_Toggle.prototype.__singlePrependOnStateOn = function(eventHandler) {
  var obj = this;
  this.__triggerOn.prependEventHandler(this.__toggleEvent, function(e) {
    if (!obj.__stateOn) {
      eventHandler.call(this, e);
    }
  });
};
uiHtml_Toggle.prototype.__singlePrependOnStateOff = function(eventHandler) {
  var obj = this;
  this.__triggerOn.prependEventHandler(this.__toggleEvent, function(e) {
    if (obj.__stateOn) {
      eventHandler.call(this, e);
    }
  });
};
uiHtml_Toggle.prototype.__singleAppendOnStateOn = function(eventHandler) {
  var obj = this;
  this.__triggerOn.appendEventHandler(this.__toggleEvent, function(e) {
    if (obj.__stateOn) {
      eventHandler.call(this, e);
    }
  });
};
uiHtml_Toggle.prototype.__singleAppendOnStateOff = function(eventHandler) {
  var obj = this;
  this.__triggerOn.appendEventHandler(this.__toggleEvent, function(e) {
    if (!obj.__stateOn) {
      eventHandler.call(this, e);
    }
  });
};
uiHtml_Toggle.createByEither = function(
    onId, onName, offId, offName, initialIsOn, eventType) {
  var triggerOn = uiHtml_Element.createByEither(onId, onName);
  var triggerOff = null;
  try {
    triggerOff = uiHtml_Element.createByEither(offId, offName);
  }
  catch(e) {
    uiUtil_Logger.getInstance(uiHtml_Toggle).warn(
        onId + ": triggerOff does not exist.");
  }
  return new uiHtml_Toggle(triggerOn, triggerOff, initialIsOn, eventType);
};
function uiHtml_Panel(domDiv, optUseIFrame) {
  this._super(domDiv);
  this.__domDiv = domDiv;
  this.__contentDomElement = null;
  this.__focusSupportEnabled = false;
  this.__willFocus = false;
  this.__isFocused = false;
  this.__scrollSupporter = new uiHtml_ScrollSupporter(this.__domDiv);
  this.__iframe = null;
  if (uiUtil_Type.getBoolean(optUseIFrame, true) &&
      uiHtml_Window.getInstance().isIe()) {
    this.__createIFrame();
  }
}
uiHtml_Panel = uiUtil_Object.declareClass(uiHtml_Panel, uiHtml_Element);
uiHtml_Panel.__focusEnabledPanels = new Array();
uiHtml_Panel.prototype.showScrollBars = function(always) {
  this.__scrollSupporter.showScrollBars(always);
  this.__updateIFrameDimension();
};
uiHtml_Panel.prototype.hideScrollBars = function() {
  this.__scrollSupporter.hideScrollBars();
  this.__updateIFrameDimension();
};
uiHtml_Panel.prototype.scrollToTop = function() {
  this.__scrollSupporter.scrollToTop();
};
uiHtml_Panel.prototype.scrollToBottom = function() {
  this.__scrollSupporter.scrollToBottom();
};
uiHtml_Panel.prototype.__createIFrame = function() {
  this.__iframe = new uiHtml_Element(
      uiHtml_Document.getInstance().createDomObject("iframe"));
  var domIFrame = this.__iframe.getDomObject();
  domIFrame.frameBorder = "0";
  domIFrame.scrolling = "no";
  domIFrame.src = "javascript: false;";
  domIFrame.style.filter =
      "progid:DXImageTransform.Microsoft.Alpha(style = 0, opacity = 0)";
  this.__iframe.setDepth(this.getDepth() - 1);
  this.__iframe.setStyleAttribute("position", "absolute");
  this.__updateIFrameDimension();
  if (this.isAppearing()) {
    this.__iframe.appear();
  }
  else {
    this.__iframe.disappear();
  }
  if (this.isShowing()) {
    this.__iframe.show();
  }
  else {
    this.__iframe.hide();
  }
};
uiHtml_Panel.prototype.__updateIFrameDimension = function() {
  if (this.__iframe == null) {
    return;
  }
  this.__iframe.setDimensionObject(this.getRelativeDimension());
};
uiHtml_Panel.prototype.show = function() {
  this._callSuper("show");
  if (this.__iframe != null) {
    this.__iframe.show();
  }
};
uiHtml_Panel.prototype.hide = function() {
  this._callSuper("hide");
  if (this.__iframe != null) {
    this.__iframe.hide();
  }
};
uiHtml_Panel.prototype.appear = function() {
  this._callSuper("appear");
  if (this.__iframe != null) {
    this.__iframe.appear();
  }
};
uiHtml_Panel.prototype.disappear = function() {
  this._callSuper("disappear");
  if (this.__iframe != null) {
    this.__iframe.disappear();
  }
};
uiHtml_Panel.prototype.setStyleAttribute = function(name, value) {
  this._callSuper("setStyleAttribute", name, value);
  switch (name) {
    case "position" :
        this.__updateIFrameDimension();
        break;
  }
};
uiHtml_Panel.prototype.setDimensionObject = function(dimension) {
  this._callSuper("setDimensionObject", dimension);
  this.__updateIFrameDimension();
};
uiHtml_Panel.prototype.setDimension = function(x, y, width, height) {
  this._callSuper("setDimension", x, y, width, height);
  this.__updateIFrameDimension();
};
uiHtml_Panel.prototype.setDepth = function(depth) {
  this._callSuper("setDepth", depth);
  if (this.__iframe != null) {
    this.__iframe.setDepth(depth - 1);
  }
};
uiHtml_Panel.prototype.__enableFocusSupport = function() {
  if (this.__focusSupportEnabled == true) {
    return;
  }
  this.__focusSupportEnabled = true;
  var panel = this;
  this.appendEventHandler("mouseover", function(e) {
    panel.__willFocus = true;
  });
  this.appendEventHandler("mouseout", function(e) {
    panel.__willFocus = false;
  });
  uiHtml_Document.getInstance().appendEventHandler("mousedown", function(e) {
    uiHtml_Panel.__executeFocusHandlers(e);
  });
  uiHtml_Panel.__focusEnabledPanels.push(this);
};
uiHtml_Panel.prototype.prependEventHandler = function(event, handler) {
  if (event == "focus" || event == "blur") {
    this.__enableFocusSupport();
  }
  return this._callSuper("prependEventHandler", event, handler);
};
uiHtml_Panel.prototype.appendEventHandler = function(event, handler) {
  if (event == "focus" || event == "blur") {
    this.__enableFocusSupport();
  }
  return this._callSuper("appendEventHandler", event, handler);
};
uiHtml_Panel.prototype.focus = function() {
  this.__isFocused = true;
};
uiHtml_Panel.prototype.__executeFocusFunction = function(
    eventName, domEvent, focusRequired) {
  this.__logger.debug("isFocused: " + this.__isFocused);
  if (this.__isFocused == focusRequired) {
    this.executeAggregateEventHandler(eventName, domEvent);
    this.__isFocused = !this.__isFocused;
  }
};
uiHtml_Panel.prototype.setContent = function(domElement) {
  this.__contentDomElement = domElement;
  var domChild = this.__contentDomElement;
  var domParent = domChild.parentNode;
  var domThis = this.getDomObject();
  if (domParent != domThis) {
    domParent.removeChild(domChild);
    domParent.appendChild(domThis);
    domThis.appendChild(domChild);
  }
};
uiHtml_Panel.prototype.getContent = function() {
  return this.__contentDomElement;
};
uiHtml_Panel.prototype.enableDragSupport = function(optTriggerElement) {
  this._callSuper("enableDragSupport", optTriggerElement);
  try {
    optTriggerElement.hideScrollBars();
  }
  catch (e) {
  }
  this.hideScrollBars();
  this.setStyleAttribute("position", "absolute");
};
uiHtml_Panel.__executeFocusHandlers = function(domEvent) {
  for (var i = 0; i < uiHtml_Panel.__focusEnabledPanels.length; ++i) {
    var panel = uiHtml_Panel.__focusEnabledPanels[i];
    if (panel.__willFocus == true) {
      panel.__executeFocusFunction("focus", domEvent, false);
    }
    else {
      panel.__executeFocusFunction("blur", domEvent, true);
    }
  }
};
uiHtml_Panel.createByEither = function(id, name) {
  return uiHtml_Element.createByEither(id, name, uiHtml_Panel);
};
uiHtml_Panel.create = function(optUseIFrame, optAppear) {
  var domDiv = uiHtml_Document.getInstance().createDomObject("div", optAppear);
  return new uiHtml_Panel(domDiv, optUseIFrame);
};
function uiHtml_DebugPanel(initialText) {
  this._super(uiHtml_Document.getInstance().createDomObject("div"));
  this.__initialize(initialText);
}
uiHtml_DebugPanel = uiUtil_Object.declareClass(uiHtml_DebugPanel, uiHtml_Panel);
uiHtml_DebugPanel.__fallbackInstance = null;
uiHtml_DebugPanel.__instance = null;
uiHtml_DebugPanel.prototype.__initialize = function(initialText) {
  this.__contentPane = uiHtml_Panel.create(false);
  this.setContent(this.__contentPane.getDomObject());
  this.__printStream = new uiHtml_PrintSupporter(
      this.__contentPane.getDomObject());
  this.println(initialText);
  this.__logger = uiUtil_Logger.getInstance(uiHtml_DebugPanel);
};
uiHtml_DebugPanel.prototype.enableDragHandle = function() {
  var domDiv = uiHtml_Document.getInstance().createDomObject("div");
  this.getDomObject().appendChild(domDiv);
  var dragHandle = new uiHtml_Panel(domDiv, false);
  this.enableDragSupport(dragHandle);
  dragHandle.setStyleAttribute("border-bottom", "1px solid blue");
  dragHandle.setStyleAttribute("background-color", "#cdd8e3");
  dragHandle.setStyleAttribute("position", "absolute");
  dragHandle.setDimension(0, 0, this.getWidth(), 18);
  if (this.getContent() != null) {
    var content = uiHtml_Element.createElementByType(this.getContent());
    content.setStyleAttribute("position", "absolute");
    content.setDimension(0, 20);
  }
  this.setDimension(null, null, null, this.getHeight() + 18);
};
uiHtml_DebugPanel.prototype.print = function(text) {
  if (this.__printStream) {
    this.__printStream.print(text);
    this.__contentPane.scrollToBottom();
  }
  else {  
    alert(text);
  }
};
uiHtml_DebugPanel.prototype.println = function(text) {
  if (this.__printStream) {
    this.__printStream.println(text);
    this.__contentPane.scrollToBottom();
  }
  else {  
    alert(text);
  }
};
uiHtml_DebugPanel.__initializeDefaultStyle = function() {
  var panel = uiHtml_DebugPanel.__instance;
  panel.__contentPane.showScrollBars();
  panel.__contentPane.setDimension(0, 0, 400, 300);
  panel.__contentPane.setStyleAttribute("background-color", "#ffffe1");
  panel.setDepth(5);
  panel.setStyleAttribute("position", "absolute");
  panel.setDimension(400, 300, 400, 300);
  panel.setStyleAttribute("border", "1px solid blue");
  panel.enableDragHandle();
  panel.show();
};
uiHtml_DebugPanel.getInstance = function(initialText) {
  if (uiHtml_DebugPanel.__instance == null) {
    uiHtml_DebugPanel.__fallbackInstance = uiUtil_Logger.getDefaultPrintStream();
    uiHtml_DebugPanel.__instance = uiHtml_DebugPanel.__fallbackInstance;
  }
  if (uiHtml_DebugPanel.__instance == uiHtml_DebugPanel.__fallbackInstance) {
    var tempHolder = new uiHtml_DebugPanel(initialText);
    uiHtml_DebugPanel.__instance = tempHolder;
    uiHtml_DebugPanel.__initializeDefaultStyle();
  }
  return uiHtml_DebugPanel.__instance;
};
function uiHtml_LifeCycleNotifier() {
  this._super();
}
uiHtml_LifeCycleNotifier = uiUtil_Object.declareClass(
    uiHtml_LifeCycleNotifier, uiUtil_Object);
uiHtml_LifeCycleNotifier.prototype.setListener = function(listener) {
  this.__lifeCycleListener = listener;
};
uiHtml_LifeCycleNotifier.prototype.notify = function(
    eventHander, domEvent, optArgN) {
  if (this.__lifeCycleListener) {
    var eventHandler = this.__lifeCycleListener[eventHander];
    if (eventHandler != null) {
      var argArray = uiUtil_ArrayUtils.toArrayIfNotAlready(arguments);
      uiUtil_ArrayUtils.removeFirst(argArray);
      return eventHandler.apply(this.__lifeCycleListener, argArray);
    }
  }
  return true;
};
function uiOptionTransfer_Suite(sourceList, targetList) {
  this._super();
  this.__srcList = sourceList;
  this.__tgtList = targetList;
  this.__srcHandler = this.__srcList.getItemHandler();
  this.__tgtHandler = this.__tgtList.getItemHandler();
  var suite = this;
  this.__srcList.appendEventHandler("dblclick", function(e) {
    suite.__transfer(e, false);
  });
  this.__tgtList.appendEventHandler("dblclick", function(e) {
    suite.__return(e, false);
  });
  var domForm = this.__tgtList.getDomObject().form;
  if (domForm != null) {
    uiHtml_ElementWrapper.getInstance().prependEventHandler(
        domForm, "submit",  function(e) {
      suite.__selectAllTargetItems(e);
    });
  }
  uiOptionTransfer_Suite.syncItems(this.__srcList, this.__tgtList);
}
uiOptionTransfer_Suite =
    uiUtil_Object.declareClass(uiOptionTransfer_Suite, uiUtil_Object);
uiOptionTransfer_Suite.prototype.__selectAllTargetItems = function(domEvent) {
  var listSize = this.__tgtList.size();
  for(var i = 0; i < listSize; i++) {
    this.__tgtHandler.setSelected(this.__tgtList.getItemAt(i), true, domEvent);
  }
};
uiOptionTransfer_Suite.prototype.__transfer = function(domEvent, all) {
  var listSize = this.__srcList.size();
  for(var i = 0; i < listSize; ++i) {
    var item = this.__srcList.getItemAt(i);
    if((all || this.__srcHandler.isSelected(item)) &&
        !this.__srcHandler.isDisabled(item) &&
        this.__find(this.__tgtList, item) < 0) {
      this.__transferItem(domEvent, item);
      if (!this.__srcList.getDomObject().multiple && !all) {
        var nextIndex = i + 1;
        if (nextIndex < listSize) {
          this.__srcList.setSelectedIndex(nextIndex);
        }
        return;
      }
    }
  }
};
uiOptionTransfer_Suite.prototype.__transferItem = function(domEvent, item) {
  var clone = this.__srcHandler.clone(item);
  this.__srcHandler.setDisabled(item, true);
  this.__srcHandler.setSelected(item, false, domEvent);
  this.__tgtList.addItem(clone);
  this.__srcHandler.setSelected(clone, true, domEvent);
};
uiOptionTransfer_Suite.prototype.__find = function(group, needle) {
  var wrapper = uiHtml_SelectOptionWrapper.getInstance();
  var listSize = group.size();
  for(var i = 0; i < listSize; ++i) {
    var item = group.getItemAt(i);
    if(item.value == needle.value && item.text == needle.text) {
      return i;
    }
  }
  return -1;
};
uiOptionTransfer_Suite.prototype.__return = function(domEvent, all) {
  var listSize = this.__tgtList.size();
  for (var i = listSize - 1; i >= 0; --i) {
    var item = this.__tgtList.getItemAt(i);
    if (all || this.__tgtHandler.isSelected(item)) {
      var index = this.__find(this.__srcList, item);
      if(index >= 0) {
        this.__returnItem(domEvent, this.__srcList.getItemAt(index), i);
      }
    }
  }
};
uiOptionTransfer_Suite.prototype.__returnItem = function(domEvent, sourceItem, targetIndex) {
  this.__srcHandler.setDisabled(sourceItem, false);
  this.__srcHandler.setSelected(sourceItem, true, domEvent);
  this.__tgtList.removeItemAt(targetIndex);
};
uiOptionTransfer_Suite.prototype._setTransferTrigger = function(trigger) {
  var suite = this;
  trigger.appendEventHandler("click", function(e) {
    suite.__transfer(e, false);
  });
};
uiOptionTransfer_Suite.prototype._setReturnTrigger = function(trigger) {
  var suite = this;
  trigger.appendEventHandler("click", function(e) {
    suite.__return(e, false);
  });
};
uiOptionTransfer_Suite.prototype._setTransferAllTrigger = function(trigger) {
  var suite = this;
  trigger.appendEventHandler("click", function(e) {
    suite.__transfer(e, true);
  });
};
uiOptionTransfer_Suite.prototype._setReturnAllTrigger = function(trigger) {
  var suite = this;
  trigger.appendEventHandler("click", function(e) {
    suite.__return(e, true);
  });
};
uiOptionTransfer_Suite.syncItems = function(srcList, tgtList) {
  srcList.enableOptionValueMapping();
  var listSize = tgtList.size();
  var srcHandler = srcList.getItemHandler();
  for(var i = 0; i < listSize; ++i) {
    var tgtItem = tgtList.getItemAt(i);
    var srcItem = srcList.getItemByValue(tgtItem.value);
    if (srcItem != null) {
      srcHandler.setDisabled(srcItem, true);
    }
  }
}
function uiOptionTransfer_Driver() {
  this._super();
  this.__suites = new Array();
}
uiOptionTransfer_Driver =
    uiUtil_Object.declareSingleton(uiOptionTransfer_Driver, uiUtil_Object);
uiHtml_Window.getInstance().prependEventHandler("load", function(e) {
  uiOptionTransfer_driver = new uiOptionTransfer_Driver();
});
uiOptionTransfer_Driver.prototype.createSuite = function(
    sourceId, sourceName,
    targetId, targetName) {
  var sourceList = uiHtml_Select.createByEither(sourceId, sourceName);
  var targetList = uiHtml_Select.createByEither(targetId, targetName);
  var suiteId = this.__suites.length;
  this.__suites[suiteId] = new uiOptionTransfer_Suite(sourceList, targetList);
  return suiteId;
};
uiOptionTransfer_Driver.prototype.registerTransferTrigger = function(
    suiteId, triggerId, triggerName) {
  var trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  this.__suites[suiteId]._setTransferTrigger(trigger);
};
uiOptionTransfer_Driver.prototype.registerReturnTrigger = function(
    suiteId, triggerId, triggerName) {
  var trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  this.__suites[suiteId]._setReturnTrigger(trigger);
};
uiOptionTransfer_Driver.prototype.registerTransferAllTrigger = function(
    suiteId, triggerId, triggerName) {
  var trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  this.__suites[suiteId]._setTransferAllTrigger(trigger);
};
uiOptionTransfer_Driver.prototype.registerReturnAllTrigger = function(
    suiteId, triggerId, triggerName) {
  var trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  this.__suites[suiteId]._setReturnAllTrigger(trigger);
};
function uiPanel_TriggerBlocker(divId, triggerId, triggerName) {
  this._super();
  this.__trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  var domDiv = uiHtml_Document.getInstance().getDomObjectById(divId);
  var showing = uiHtml_ElementWrapper.getInstance().isShowing(domDiv);
  this.__blocker = uiHtml_Panel.create(true, showing);
  this.__blocker.setStyleAttribute("position", "absolute");
  this.__blocker.setDimensionObject(this.__trigger.getRelativeDimension());
  this.__blocker.setDepth(this.__trigger.getDepth() + 2);
}
uiPanel_TriggerBlocker = uiUtil_Object.declareClass(
    uiPanel_TriggerBlocker, uiUtil_Object);
uiPanel_TriggerBlocker.prototype.onAfterShow = function(domEvent, domDiv) {
  this.__blocker.appear();
};
uiPanel_TriggerBlocker.prototype.onAfterHide = function(domEvent, domDiv) {
  this.__blocker.disappear();
};
function uiPanel_Suite(domDiv) {
  this._super(domDiv);
  this.__domDiv = domDiv;
  this.__automaticallyStuck = false;
  this.__explicitlyStuck = false;
  this.__positionAnchor = null;
  this.__showTimerId = null;
  this.__hideTimerId = null;
  this.__lifeCycleNotifier = new uiHtml_LifeCycleNotifier();
  this.__originalZIndex = this.getDepth();
  uiPanel_Suite.__addToZIndexGroup(this, this.__originalZIndex);
  var event = (uiHtml_Window.getInstance().isOpera())? "click" : "mousedown" ;
  var panel = this;
  this.appendEventHandler(event, function(e) {
    panel.__moveToTop();
  });
  var suite = this;
  this.appendEventHandler("mouseover", function(e) {
    suite.__disableHide(true);
  });
  this.appendEventHandler("mouseout", function(e) {
    suite.__enableHide(true);
  });
}
uiPanel_Suite = uiUtil_Object.declareClass(uiPanel_Suite, uiHtml_Panel);
uiPanel_Suite.__zIndexGroups = new Array();
uiPanel_Suite.prototype._setLifeCycleListener = function(listener) {
  this.__lifeCycleNotifier.setListener(listener);
};
uiPanel_Suite.prototype._setSticker = function(toggle) {
  this.__sticker = toggle;
  var suite = this;
  this.__sticker.appendOnStateOn(function(e) {
    suite.__disableHide();
  });
  this.__sticker.appendOnStateOff(function(e) {
    suite.__enableHide();
  });
};
uiPanel_Suite.prototype.__activateShowTimer = function(domEvent, msDelay) {
  this.__logger.debug("Activating panel show timer");
  var suite = this;
  this.__showTimerId = window.setTimeout(function() {
    suite.requestShow(domEvent);
  }, msDelay);
};
uiPanel_Suite.prototype.__deactivateShowTimer = function() {
  if (this.__showTimerId != null) {
    this.__logger.debug("Deactivating panel show timer");
    window.clearTimeout(this.__showTimerId);
    this.__showTimerId = null;
  }
};
uiPanel_Suite.prototype.__activateHideTimer = function(domEvent, msDelay, force) {
  this.__logger.debug("Activating panel hide timer");
  var suite = this;
  this.__hideTimerId = window.setTimeout(function() {
    suite.requestHide(domEvent, force);
  }, msDelay);
};
uiPanel_Suite.prototype.__deactivateHideTimer = function() {
  if (this.__hideTimerId != null) {
    this.__logger.debug("Deactivating panel hide timer");
    window.clearTimeout(this.__hideTimerId);
    this.__hideTimerId = null;
  }
};
uiPanel_Suite.prototype._setShowTrigger =
    function(trigger, eventType, actionDelay, attachedToMouse) {
  var suite = this;
  trigger.appendEventHandler(eventType, function(e) {
    if (!suite.isShowing()) {
      suite.__adjustPosition(attachedToMouse, new uiHtml_Event(e));
    }
    suite.__activateShowTimer(e, actionDelay);
  });
  if (eventType == "mouseover") {
    trigger.appendEventHandler("mouseout", function(e) {
      suite.__deactivateShowTimer();
    });
  }
  else if (eventType == "focus") {
    trigger.appendEventHandler("blur", function(e) {
      suite.__deactivateShowTimer();
    });
  }
};
uiPanel_Suite.prototype._setHideTrigger =
    function(trigger, eventType, actionDelay, force) {
  var suite = this;
  trigger.appendEventHandler(eventType, function(e) {
    suite.__activateHideTimer(e, actionDelay, force);
  });
  if (eventType == "mouseout") {
    trigger.appendEventHandler("mouseover", function(e) {
      suite.__deactivateHideTimer();
    });
  }
  else if (eventType == "blur") {
    trigger.appendEventHandler("focus", function(e) {
      suite.__deactivateHideTimer();
    });
  }
};
uiPanel_Suite.prototype._setPositionAnchor = function(anchor) {
  this.__positionAnchor = anchor;
  this.__adjustPosition(false, null);
};
uiPanel_Suite.prototype.__disableHide = function(auto) {
  if (auto) {
    this.__automaticallyStuck = true;
  }
  else {
    this.__explicitlyStuck = true;
  }
};
uiPanel_Suite.prototype.__enableHide = function(auto) {
  if (auto) {
    this.__automaticallyStuck = false;
  }
  else {
    this.__explicitlyStuck = false;
  }
};
uiPanel_Suite.prototype.__shouldHide = function() {
  if (!this.__automaticallyStuck && !this.__explicitlyStuck) {
    return true;
  }
  return false;
};
uiPanel_Suite.prototype.__adjustPosition = function(attachedToMouse, event) {
  if (attachedToMouse) {
    this.setStyleAttribute("position", "absolute");
    var position = event.getAbsolutePosition();
    var wrapper = uiHtml_ElementWrapper.getInstance();
    var x = position.getLeft();
    var y = position.getTop();
    var currentElement = this.getDomObject().offsetParent;
    while (currentElement != null &&
        uiHtml_Element.getTagName(currentElement) != "body") {
      if (wrapper.getCascadedStyleAttribute(currentElement, "position") == "absolute") {
        x -= currentElement.offsetLeft;
        y -= currentElement.offsetTop;
      }
      currentElement = currentElement.offsetParent;
    }
    this.setDimension(x, y);
  }
  else if (this.__positionAnchor) {
    this.setStyleAttribute("position", "absolute");
    this.__adjustPositionRelativeTo(this.__positionAnchor);
  }
};
uiPanel_Suite.prototype.requestShow = function(domEvent) {
  if (!this.__lifeCycleNotifier.notify("onBeforeShow", domEvent)) {
    return;
  }
  this.show();
  this.__lifeCycleNotifier.notify("onAfterShow", domEvent);
};
uiPanel_Suite.prototype.show = function() {
  this.focus();
  this.__moveToTop();
  this._callSuper("show");
};
uiPanel_Suite.prototype.requestHide = function(domEvent, force) {
  if (this.__shouldHide() || force) {
    if (!this.__lifeCycleNotifier.notify("onBeforeHide", domEvent)) {
      return;
    }
    this.hide();
    this.__lifeCycleNotifier.notify("onAfterHide", domEvent);
  }
};
uiPanel_Suite.prototype.hide = function() {
  this._callSuper("hide");
};
uiPanel_Suite.prototype.__adjustPositionRelativeTo = function(anchor) {
  var maxWidth = uiHtml_Document.getInstance().getWidth();
  var anchorDimension = anchor.getRelativeDimension();
  var anchorLeft = anchorDimension.getLeft();
  var anchorRight = anchorDimension.getRight();
  var anchorTop = anchorDimension.getTop();
  var panelWidth = this.getWidth();
  var lhsLeft = anchorLeft - panelWidth;
  var crossesLeftBoundary = (lhsLeft < 0);
  var crossesRightBoundary = ((anchorRight + panelWidth) > maxWidth);
  if (crossesRightBoundary && !crossesLeftBoundary) {
    this.setDimension(lhsLeft, anchorTop);
  }
  else {
    this.setDimension(anchorRight, anchorTop);
  }
};
uiPanel_Suite.prototype.__moveToTop = function() {
  var zIndexGroup = uiPanel_Suite.__zIndexGroups[this.__originalZIndex];
  var topZIndex = this.__originalZIndex + zIndexGroup.length - 1;
  var oldZIndex = this.getDepth();
  for (var i = 0; i < zIndexGroup.length; i++) {
    if (zIndexGroup[i].getDepth() > oldZIndex) {
      zIndexGroup[i].setDepth(zIndexGroup[i].getDepth() - 1);
    }
  }
  this.setDepth(topZIndex);
};
uiPanel_Suite.createByEither = function(id, name) {
  return uiHtml_Element.createByEither(id, name, uiPanel_Suite);
};
uiPanel_Suite.__addToZIndexGroup = function(panel, zIndexValue) {
  if (uiPanel_Suite.__zIndexGroups[zIndexValue] == null) {
    uiPanel_Suite.__zIndexGroups[zIndexValue] = new Array();
  }
  var zIndexGroup = uiPanel_Suite.__zIndexGroups[zIndexValue];
  panel.setDepth(zIndexValue + zIndexGroup.length);
  zIndexGroup.push(panel);
};
function uiPanel_Driver() {
  this._super();
  this.__suites = new Object();
}
uiPanel_Driver = uiUtil_Object.declareSingleton(uiPanel_Driver, uiUtil_Object);
uiHtml_Window.getInstance().prependEventHandler("load", function(e) {
  uiPanel_driver = new uiPanel_Driver();
});
uiPanel_Driver.prototype.createSuite = function(divId) {
  var suite = uiPanel_Suite.createByEither(divId, null);
  this.__suites[divId] = suite;
  return divId;  
};
uiPanel_Driver.prototype.getSuite = function(panelId) {
  return this.__suites[panelId];
};
uiPanel_Driver.prototype.setLifeCycleListener = function(panelId, listener) {
  this.__suites[panelId]._setLifeCycleListener(listener);
};
uiPanel_Driver.prototype.setPositionAnchor = function(panelId, anchorId, anchorName) {
  var anchor = uiHtml_Element.createByEither(anchorId, anchorName);
  this.__suites[panelId]._setPositionAnchor(anchor);
};
uiPanel_Driver.prototype.registerDragElement = function(
    panelId, draggerId, draggerName) {
  var handle = uiHtml_Element.createByEither(draggerId, draggerName);
  this.__suites[panelId].enableDragSupport(handle);
};
uiPanel_Driver.prototype.registerStickElement = function(
    panelId, stickerId, stickerName) {
  var toggle = uiHtml_Toggle.createByEither(
      stickerId, stickerName, null, null, false);
  this.__suites[panelId]._setSticker(toggle);
};
uiPanel_Driver.prototype.registerShowTrigger = function(
    panelId, triggerId, triggerName, eventName, actionDelay, attachedToMouse) {
  var trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  this.__suites[panelId]._setShowTrigger(trigger, eventName, actionDelay, attachedToMouse);
};
uiPanel_Driver.prototype.registerHideTrigger = function(
    panelId, triggerId, triggerName, eventName, actionDelay, force) {
  var trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  this.__suites[panelId]._setHideTrigger(trigger, eventName, actionDelay, force);
};
function uiShift_Suite(list) {
  this._super();
  this.__list = list;
  this.__handler = this.__list.getItemHandler();
}
uiShift_Suite = uiUtil_Object.declareClass(uiShift_Suite, uiUtil_Object);
uiShift_Suite.prototype._initUpTrigger = function(trigger) {
  this.__upTrigger = trigger;
  var suite = this;
  this.__upTrigger.appendMousePressHandler(function(e) {
    suite.__shiftUp();
  });
};
uiShift_Suite.prototype._initDownTrigger = function(trigger) {
  this.__downTrigger = trigger;
  var suite = this;
  this.__downTrigger.appendMousePressHandler(function(e) {
    suite.__shiftDown();
  });
};
uiShift_Suite.prototype._initFirstTrigger = function(trigger) {
  this.__firstTrigger = trigger;
  var suite = this;
  this.__firstTrigger.appendEventHandler("mousedown", function(e) {
    suite.__shiftFirst();
  });
};
uiShift_Suite.prototype._initLastTrigger = function(trigger) {
  this.__lastTrigger = trigger;
  var suite = this;
  this.__lastTrigger.appendEventHandler("mousedown", function(e) {
    suite.__shiftLast();
  });
};
uiShift_Suite.prototype.__shiftItemUp = function(index) {
  var shiftedUp = this.__handler.clone(this.__list.getItemAt(index));
  var shiftedDown = this.__list.getItemAt(index - 1);
  this.__list.setItemAt(index - 1, shiftedUp);
  this.__list.setItemAt(index, shiftedDown);
};
uiShift_Suite.prototype.__shiftUp = function() {
  var num = 1;
  if (this.__distanceText != null) {
    num = parseInt(this.__distanceText.getDomObject().value);
    if(isNaN(num)) {
      return;
    }
  }
  var listSize = this.__list.size();
  var selectedIndices = new Array();
  for (var i = 0; i < listSize; ++i) {
    var item = this.__list.getItemAt(i);
    if (this.__handler.isSelected(item)) {
      selectedIndices.push(i);
    }
  }
  for (var i = 0; i < selectedIndices.length; ++i) {
    var index = selectedIndices[i];
    if(index - num < 0) {
      num = index;
      break;
    }
    else {
      this.__unselect(this.__list.getItemAt(index));
      for(var j = 0; j < num; ++j) {
        this.__shiftItemUp(index - j);
      }
      selectedIndices[i] = index - num;
    }
  }
  if (num > 0) {
    this.__selectItems(selectedIndices);
  }
};
uiShift_Suite.prototype.__shiftFirst = function() {
  var listSize = this.__list.size();
  var selectedIndices = new Array();
  for(var i = 0; i < listSize; ++i) {
    var item = this.__list.getItemAt(i);
    if (this.__handler.isSelected(item)) {
      selectedIndices.push(i);
    }
  }
  var numPushed = 0;
  for (var i = 0; i < selectedIndices.length; ++i) {
    var index = selectedIndices[i];
    this.__unselect(this.__list.getItemAt(index));
    var num = index - numPushed;
    for(var j = 0; j < num; ++j) {
      this.__shiftItemUp(index - j);
      selectedIndices[i] = numPushed;
    }
    ++numPushed;
  }
  this.__selectItems(selectedIndices);
  this.__list.scrollToTop();
};
uiShift_Suite.prototype.__select = function(item) {
  item.selected = true;
};
uiShift_Suite.prototype.__unselect = function(item) {
  item.selected = false;
};
uiShift_Suite.prototype.__shiftItemDown = function(index) {
  var shiftedDown = this.__handler.clone(this.__list.getItemAt(index));
  var shiftedUp = this.__list.getItemAt(index + 1);
  this.__list.setItemAt(index + 1, shiftedDown);
  this.__list.setItemAt(index, shiftedUp);
};
uiShift_Suite.prototype.__shiftDown = function() {
  var num = 1;
  if (this.__distanceText != null) {
    num = parseInt(this.__distanceText.getDomObject().value);
    if(isNaN(num)) {
      return;
    }
  }
  var selectedIndices = new Array();
  var listSize = this.__list.size();
  var lastIndex = listSize - 1;
  for(var i = lastIndex; i >= 0; --i) {
    var item = this.__list.getItemAt(i);
    if (this.__handler.isSelected(item)) {
      selectedIndices.push(i);
    }
  }
  for (var i = 0; i < selectedIndices.length; ++i) {
    var index = selectedIndices[i];
    if(index + num > lastIndex) {
      num = lastIndex - index;
      break;
    }
    else {
      this.__unselect(this.__list.getItemAt(index));
      for(var j = 0; j < num; ++j) {
        this.__shiftItemDown(index + j);
      }
      selectedIndices[i] = index + num;
    }
  }
  if (num > 0) {
    this.__selectItems(selectedIndices);
  }
};
uiShift_Suite.prototype.__shiftLast = function() {
  var listSize = this.__list.size();
  var selectedIndices = new Array();
  for(var i = listSize - 1; i >= 0; --i) {
    var item = this.__list.getItemAt(i);
    if (this.__handler.isSelected(item)) {
      selectedIndices.push(i);
    }
  }
  var numPushed = 0;
  for (var i = 0; i < selectedIndices.length; ++i) {
    var index = selectedIndices[i];
    this.__unselect(this.__list.getItemAt(index));
    var last = listSize - 1;
    var num = last - index - numPushed;
    for(var j = 0; j < num; ++j) {
      this.__shiftItemDown(index + j);
      selectedIndices[i] = last - numPushed;
    }
    ++numPushed;
  }
  this.__selectItems(selectedIndices);
  this.__list.scrollToBottom();
};
uiShift_Suite.prototype.__selectItems = function(selectedIndices) {
  if (uiHtml_Window.getInstance().isOpera()) {
    var suite = this;
    window.setTimeout(function(e) {
      suite.__implSelectItems(selectedIndices);
    }, 0);
  }
  else {
    this.__implSelectItems(selectedIndices);
  }
}
uiShift_Suite.prototype.__implSelectItems = function(selectedIndices) {
  for(var i = 0; i < selectedIndices.length; ++i) {
    this.__select(this.__list.getItemAt(selectedIndices[i]));
  }
}
function uiShift_Driver() {
  this._super();
}
uiShift_Driver = uiUtil_Object.declareSingleton(uiShift_Driver, uiUtil_Object);
uiHtml_Window.getInstance().prependEventHandler("load", function(e) {
  uiShift_driver = new uiShift_Driver();
});
uiShift_Driver.prototype.createUpSuite = function(triggerId, triggerName, listId, listName) {
  var suite = new uiShift_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initUpTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
uiShift_Driver.prototype.createDownSuite = function(triggerId, triggerName, listId, listName) {
  var suite = new uiShift_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initDownTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
uiShift_Driver.prototype.createFirstSuite = function(triggerId, triggerName, listId, listName) {
  var suite = new uiShift_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initFirstTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
uiShift_Driver.prototype.createLastSuite = function(triggerId, triggerName, listId, listName) {
  var suite = new uiShift_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initLastTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
function uiFormGuide_Observed(widgetGroup) {
  this._super();
  this.__ruleSets = new Array();
  var observed = this;
  widgetGroup.appendEventHandler("change", function(e) {
    observed._respond(e);
  });
}
uiFormGuide_Observed = uiUtil_Object.declareClass(uiFormGuide_Observed, uiUtil_Object);
uiFormGuide_Observed.prototype.addRuleSet = function(ruleSet) {
  this.__ruleSets.push(ruleSet);
};
uiFormGuide_Observed.prototype._respond = function(domEvent) {
  var ruleSetsToExecute = new Array();
  for (var i = 0; i < this.__ruleSets.length; ++i) {
    if (this.__ruleSets[i]._allRulesHold()) {
      ruleSetsToExecute.push(this.__ruleSets[i]);
    }
    else {
      this.__ruleSets[i]._undoAction(domEvent);
    }
  }
  for (var i = 0; i < ruleSetsToExecute.length; i++) {
    ruleSetsToExecute[i]._doAction(domEvent);
  }
};
function uiFormGuide_Rule(widgetGroup, expectedValue) {
  this._super();
  this.__widgetGroup = widgetGroup;
  this.__expectedValue = expectedValue;
}
uiFormGuide_Rule = uiUtil_Object.declareClass(uiFormGuide_Rule, uiUtil_Object);
uiFormGuide_Rule.prototype._holds = function() {
  if (this.__expectedValue == null) {
    return (this.__widgetGroup.getValues().length == 0);
  }
  return this.__widgetGroup.hasValue(this.__expectedValue);
};
uiFormGuide_Rule.prototype.getWidgetGroup = function() {
  return this.__widgetGroup;
};
uiFormGuide_Rule.prototype.getExpectedValue = function() {
  return this.__expectedValue;
};
function uiFormGuide_RuleSet(doAction, undoAction) {
  this._super();
  this.__rules = new Array();
  this.__doAction = doAction;
  this.__undoAction = undoAction;
  this.__elementHandler = new uiHtml_ElementWrapper();
  this.__lifeCycleNotifier = new uiHtml_LifeCycleNotifier();
}
uiFormGuide_RuleSet = uiUtil_Object.declareClass(uiFormGuide_RuleSet, uiUtil_Object);
uiFormGuide_RuleSet.prototype.addRule = function(rule) {
  this.__rules.push(rule);
};
uiFormGuide_RuleSet.prototype._allRulesHold = function() {
  for (var i = 0; i < this.__rules.length; ++i) {
    if (!this.__rules[i]._holds()) {
      return false;
    }
  }
  return true;
};
uiFormGuide_RuleSet.prototype.getRules = function() {
  return this.__rules;
};
uiFormGuide_RuleSet.prototype._doAction = function(domEvent) {
  this.__doAction(domEvent, this);
};
uiFormGuide_RuleSet.prototype._undoAction = function(domEvent) {
  this.__undoAction(domEvent, this);
};
uiFormGuide_RuleSet.prototype.setLifeCycleListener = function(listener) {
  this.__lifeCycleNotifier.setListener(listener);
};
uiFormGuide_RuleSet.prototype.__enableEachElement = function(
    domElement, domEvent) {
  if (!this.__lifeCycleNotifier.notify("onBeforeEnable", domEvent, domElement)) {
    return;
  }
  this.__elementHandler.setDisabled(domElement, false);
  this.__lifeCycleNotifier.notify("onAfterEnable", domEvent, domElement);
};
uiFormGuide_RuleSet.prototype.__disableEachElement = function(
    domElement, domEvent) {
  if (!this.__lifeCycleNotifier.notify("onBeforeDisable", domEvent, domElement)) {
    return;
  }
  this.__elementHandler.setDisabled(domElement, true);
  this.__lifeCycleNotifier.notify("onAfterDisable", domEvent, domElement);
};
uiFormGuide_RuleSet.prototype.__insertEachElement = function(
    domElement, domEvent) {
  if (!this.__lifeCycleNotifier.notify("onBeforeInsert", domEvent, domElement)) {
    return;
  }
  this.__elementHandler.appear(domElement);
  this.__lifeCycleNotifier.notify("onAfterInsert", domEvent, domElement);
};
uiFormGuide_RuleSet.prototype.__removeEachElement = function(
    domElement, domEvent) {
  if (!this.__lifeCycleNotifier.notify("onBeforeRemove", domEvent, domElement)) {
    return;
  }
  this.__elementHandler.disappear(domElement);
  this.__lifeCycleNotifier.notify("onAfterRemove", domEvent, domElement);
};
uiFormGuide_RuleSet.prototype.enableElements = function(
    domEvent, elementId, elementName) {
  var group = this.__createGroup(elementId, elementName);
  group.traverse(this, this.__enableEachElement, domEvent);
};
uiFormGuide_RuleSet.prototype.disableElements = function(
    domEvent, elementId, elementName) {
  var group = this.__createGroup(elementId, elementName);
  group.traverse(this, this.__disableEachElement, domEvent);
};
uiFormGuide_RuleSet.prototype.insertElements = function(
    domEvent, elementId, elementName) {
  var group = this.__createGroup(elementId, elementName);
  group.traverse(this, this.__insertEachElement, domEvent);
};
uiFormGuide_RuleSet.prototype.removeElements = function(
    domEvent, elementId, elementName) {
  var group = this.__createGroup(elementId, elementName);
  group.traverse(this, this.__removeEachElement, domEvent);
};
uiFormGuide_RuleSet.prototype.__createGroup = function(elementId, elementName) {
  var domObjects = uiHtml_Group.__getDomObjectsByEither(elementId, elementName);
  return new uiHtml_Group(domObjects);
}
function uiFormGuide_Driver() {
  this._super();
  this.__observedMap = new Object();
}
uiFormGuide_Driver = uiUtil_Object.declareSingleton(uiFormGuide_Driver, uiUtil_Object);
uiHtml_Window.getInstance().prependEventHandler("load", function(e) {
  uiFormGuide_driver = new uiFormGuide_Driver();
});
uiFormGuide_Driver.prototype.createRuleSet = function(doAction, undoAction) {
  return new uiFormGuide_RuleSet(doAction, undoAction);
};
uiFormGuide_Driver.prototype.createRule =
    function(widgetId, widgetName, value) {
  var widgetGroup = uiHtml_Group.createByEither(widgetId, widgetName);
  return new uiFormGuide_Rule(widgetGroup, value);
};
uiFormGuide_Driver.prototype.createObservedIfNotInCache =
    function(widgetId, widgetName) {
  var key = this.__getObservedMapKey(widgetId, widgetName);
  var observed = this.__observedMap[key];
  if (observed == null) {
    var widgetGroup = uiHtml_Group.createByEither(widgetId, widgetName);
    observed = new uiFormGuide_Observed(widgetGroup);
    this.__observedMap[key] = observed;
  }
  return observed;
};
uiFormGuide_Driver.prototype.__getObservedMapKey =
    function(widgetId, widgetName) {
  return "id:" + widgetId + "name:" + widgetName;
};
uiFormGuide_Driver.prototype.simulateOnChangeEvent = function(observed) {
  observed._respond();
};
function uiCalendar_YearListObtainerStrategy() {
  this._super();
}
uiCalendar_YearListObtainerStrategy = uiUtil_Object.declareClass(
    uiCalendar_YearListObtainerStrategy, uiUtil_Object);
uiCalendar_YearListObtainerStrategy.prototype.getYearArray =
    function(selectedYear) {
  var yearArray = new Array();
  for (var i = 5; i > 0; i--) {
    yearArray.push(selectedYear - i);
  }
  yearArray.push(selectedYear);
  for (var i = 1; i <= 5; i++) {
    yearArray.push(selectedYear + i);
  }
  return yearArray;
};
function uiCalendar_ActionResolverStrategy(inputId, inputName, optPanelId, optFormat) {
  this._super();
  var input = uiHtml_Element.createByEither(inputId, inputName);
  this.__domInput = input.getDomObject();
  this.__panelId = optPanelId;
  this.__format = uiUtil_Type.getString(optFormat, "MM/dd/yyyy");
  this.__origColor = null;
}
uiCalendar_ActionResolverStrategy =
    uiUtil_Object.declareClass(uiCalendar_ActionResolverStrategy, uiUtil_Object);
uiCalendar_ActionResolverStrategy.prototype.getAction = function(
    eventName, calendarSuite, processedDate, selectedDate) {
  switch (eventName) {
    case "click" :
        return this.__getClickAction(
            calendarSuite, processedDate, selectedDate);
    case "mouseover" :
        return this.__getMouseOverAction(processedDate, selectedDate);
    case "mouseout" :
        return this.__getMouseOutAction(processedDate, selectedDate);
  }
};
uiCalendar_ActionResolverStrategy.prototype.__inTheSameMonth = function(
    date1, date2) {
  if (date1.getMonth() == date2.getMonth()) {
    return true;
  }
  return false;
};
uiCalendar_ActionResolverStrategy.prototype.__getClickAction = function(
    calendarSuite, processedDate, selectedDate) {
  if (!this.__inTheSameMonth(processedDate, selectedDate)) {
    return null;
  }
  var strategy = this;
  return function(e) {
    calendarSuite.update(processedDate);
    strategy.__domInput.value = (new uiUtil_Calendar(
        processedDate)).format(strategy.__format);
    if (strategy.__panelId != null) {
      var panel = uiPanel_driver.getSuite(strategy.__panelId);
      if (panel != null) {
        panel.requestHide(e, true);
      }
    }
  };
};
uiCalendar_ActionResolverStrategy.prototype.__getMouseOverAction = function(
    processedDate, selectedDate) {
  if (!this.__inTheSameMonth(processedDate, selectedDate)) {
    return null;
  }
  return function(e) {
    this.__origColor = this.style.backgroundColor;
    this.style.backgroundColor = "#ffd0d7";
  };
};
uiCalendar_ActionResolverStrategy.prototype.__getMouseOutAction = function(
    processedDate, selectedDate) {
  if (!this.__inTheSameMonth(processedDate, selectedDate)) {
    return null;
  }
  return function(e) {
    this.style.backgroundColor = this.__origColor;
  };
};
uiCalendar_ActionResolverStrategy.prototype.getEventsOfInterest = function() {
  return new Array("click", "mouseover", "mouseout");
};
function uiCalendar_CssClassResolverStrategy() {
  this._super();
}
uiCalendar_CssClassResolverStrategy =
    uiUtil_Object.declareClass(uiCalendar_CssClassResolverStrategy, uiUtil_Object);
CALENDAR_INDEX_SUNDAY = 0;
CALENDAR_INDEX_MONDAY = 1;
CALENDAR_INDEX_TUEDAY = 2;
CALENDAR_INDEX_WEDNESDAY = 3;
CALENDAR_INDEX_THURSDAY = 4;
CALENDAR_INDEX_FRIDAY = 5;
CALENDAR_INDEX_SATURDAY = 6;
uiCalendar_CssClassResolverStrategy.prototype.__dateEquals = function(date1, date2) {
  return (date1.getDate() == date2.getDate() &&
      date1.getMonth() == date2.getMonth() &&
      date1.getFullYear() == date2.getFullYear());
};
uiCalendar_CssClassResolverStrategy.prototype.getForDate =
    function(processedDate, selectedDate) {
  var currentlyProcessedMonth = processedDate.getMonth();
  var currentlySelectedMonth = selectedDate.getMonth();
  var classNames = "";
  if (currentlyProcessedMonth != currentlySelectedMonth) {
    classNames += "uiCalendar_otherMonth ";
  }
  if (this.__dateEquals(processedDate, selectedDate)) {
    classNames += "uiCalendar_selected ";
  }
  switch (processedDate.getDay()) {
    case CALENDAR_INDEX_SUNDAY:
    case CALENDAR_INDEX_SATURDAY:
        classNames += "uiCalendar_cellWeekend ";
        break;
    default:
        classNames += "uiCalendar_cellWeekday ";
  }
  return classNames;
};
uiCalendar_CssClassResolverStrategy.prototype.getForHeader =
    function(dayIndex) {
  switch (dayIndex) {
    case CALENDAR_INDEX_SUNDAY   : return "uiCalendar_headWeekend";
    case CALENDAR_INDEX_SATURDAY : return "uiCalendar_headWeekend";
    default                      : return "uiCalendar_headWeekday";
  }
};
function uiCalendar_SelectedDateObtainerStrategy() {
  this._super();
}
uiCalendar_SelectedDateObtainerStrategy =
    uiUtil_Object.declareClass(uiCalendar_SelectedDateObtainerStrategy, uiUtil_Object);
uiCalendar_SelectedDateObtainerStrategy.prototype.getNewDate = function(selectedDate) {
  return new Date();
};
function uiCalendar_WidgetDateObtainerStrategy(inputId, inputName, optFormat) {
  this._super();
  var input = uiHtml_Element.createByEither(inputId, inputName);
  this.__domInput = input.getDomObject();
  this.__format = uiUtil_Type.getString(optFormat, "MM/dd/yyyy");
}
uiCalendar_WidgetDateObtainerStrategy = uiUtil_Object.declareClass(
    uiCalendar_WidgetDateObtainerStrategy, uiUtil_Object);
uiCalendar_WidgetDateObtainerStrategy.prototype.getNewDate =
    function(selectedDate) {
  try {
    var newDate = uiUtil_Calendar.createFromString(
        this.__domInput.value, this.__format);
    return newDate.toDate();
  }
  catch (e) {
    if (e instanceof uiUtil_CreateException) {
      alert("Invalid date: " + this.__domInput.value +
          ". Make sure that the date format is correct.");
      return new Date();
    }
    else {
      throw e;
    }
  }
};
function uiCalendar_Suite(domTable, dayLabels, classResolver, actionResolver) {
  this._super();
  this.__elementHandler = uiHtml_ElementWrapper.getInstance();
  this.__selectedDate = new uiUtil_Calendar();
  this.__domTable = domTable;
  this.__yearListers = new Array();
  this.__monthListers = new Array();
  this.__classResolver = classResolver;
  this.__actionResolver = actionResolver;
  this.__selectedDate.addUpdateListener(this);
  this.__initGrid(this.__domTable, dayLabels);
}
uiCalendar_Suite = uiUtil_Object.declareClass(uiCalendar_Suite, uiUtil_Object);
uiCalendar_Suite.GRID_TOTAL_ROW_COUNT = 7;  
uiCalendar_Suite.GRID_DATA_ROW_START = 1;
uiCalendar_Suite.GRID_TOTAL_COL_COUNT = uiUtil_Calendar.NUM_DAYS_IN_A_WEEK;
uiCalendar_Suite.prototype.__initGrid = function(domTable, dayLabels) {
  this.__addHeaderTo(domTable, dayLabels);
  this.__addBodyTo(domTable);
  this.__updateGrid(domTable);
};
uiCalendar_Suite.prototype.__translateToCustomDayIndex = function(origDayOfWeekId) {
  return origDayOfWeekId;  
};
uiCalendar_Suite.prototype.__addHeaderTo = function(gridTable, dayLabels) {
  var dayNameRow = this.__addRowTo(gridTable);
  var maxDayId = uiUtil_Calendar.NUM_DAYS_IN_A_WEEK;
  for (var dayOfWeekId = 0; dayOfWeekId < maxDayId; ++dayOfWeekId) {
    var dayOfThisCell = this.__translateToCustomDayIndex(dayOfWeekId);
    var cell = this.__addCellTo(dayNameRow, dayLabels[dayOfThisCell]);
    var classOfThisCell = this.__classResolver.getForHeader(dayOfWeekId);
    cell.className = classOfThisCell;
  }
};
uiCalendar_Suite.prototype.__addRowTo = function(table) {
  return table.insertRow(-1);
};
uiCalendar_Suite.prototype.__addCellTo = function(row, text) {
  var cell = row.insertCell(-1);
  uiHtml_Document.createTextNode(text, cell);
  return cell;
};
uiCalendar_Suite.prototype.__addBodyTo = function(gridTable) {
  var rowStart = uiCalendar_Suite.GRID_DATA_ROW_START;
  var rowCount = uiCalendar_Suite.GRID_TOTAL_ROW_COUNT;
  for (var row = rowStart; row < rowCount; row++) {
    var currentRow = this.__addRowTo(gridTable);
    for (var col=0; col < uiCalendar_Suite.GRID_TOTAL_COL_COUNT; col++) {
      this.__addCellTo(currentRow, " ");
    }
  }
};
uiCalendar_Suite.prototype.dateUpdated = function(date) {
  for (var i = 0; i < this.__yearListers.length; i++) {
    this.__updateYearLister(this.__yearListers[i], date);
  }
  for (var i = 0; i < this.__monthListers.length; i++) {
    this.__updateMonthLister(this.__monthListers[i]);
  }
};
uiCalendar_Suite.prototype.__updateYearLister = function(lister, date) {
  var select = lister.__select;
  select.clearItems();
  var years = lister.__strategy.getYearArray(this.__selectedDate.getYear());
  for (var i = 0; i < years.length; ++i) {
    select.addItem(uiHtml_SelectOptionWrapper.create(years[i], years[i]));
  }
  select.setSelectedValue(this.__selectedDate.getYear());
};
uiCalendar_Suite.prototype._addYearLister = function(select, strategy) {
  var lister = new uiCalendar_Suite.YearLister(select, strategy);
  this.__yearListers.push(lister);
  this._addUpdater(select, "change",
      new uiCalendar_Suite.YearExtractor(select.getDomObject()));
  this.__updateYearLister(lister);
};
uiCalendar_Suite.prototype.__updateMonthLister = function(lister) {
  lister.__select.setSelectedValue(this.__selectedDate.getMonth());
};
uiCalendar_Suite.prototype._addMonthLister = function(select, monthLabels) {
  var lister = new uiCalendar_Suite.MonthLister(select);
  this.__monthListers.push(lister);
  select.clearItems();
  for (var i = 0; i < monthLabels.length; ++i) {
    select.addItem(uiHtml_SelectOptionWrapper.create(monthLabels[i], i));
  }
  this._addUpdater(select, "change",
      new uiCalendar_Suite.MonthExtractor(select.getDomObject()));
  this.__updateMonthLister(lister);
};
uiCalendar_Suite.prototype._addUpdater = function(trigger, event, strategy) {
  var suite = this;
  trigger.appendEventHandler(event, function(e) {
    var jsSelectedDate = new Date(suite.__selectedDate.toDate());
    var jsNewDate = strategy.getNewDate(jsSelectedDate);
    suite.update(jsNewDate);
  });
};
uiCalendar_Suite.prototype.update = function(jsNewDate) {
  var newDate = new uiUtil_Calendar(jsNewDate);
  if (this.__selectedDate.getDay() != newDate.getDay() ||
      this.__selectedDate.getMonth() != newDate.getMonth() ||
      this.__selectedDate.getYear() != newDate.getYear()) {
    this.__selectedDate.fromDate(jsNewDate);
    this.__updateGrid(this.__domTable);
  }
};
uiCalendar_Suite.prototype.__updateGrid = function(gridTable) {
  var firstDayInMonth = this.__selectedDate.getFirstDayInMonth();
  var numDaysInMonth = this.__selectedDate.getNumDaysInMonth();
  var currentDate = new uiUtil_Calendar(this.__selectedDate.toDate());
  currentDate.setDay(1);
  for (var i = 0; i <= firstDayInMonth; ++i) {
    currentDate.decrementDay();
  }
  var rowIndex = uiCalendar_Suite.GRID_DATA_ROW_START;
  var rowCount = uiCalendar_Suite.GRID_TOTAL_ROW_COUNT;
  for (var row = rowIndex; row < rowCount; ++row) {  
    currentRow = gridTable.rows[row];
    for (var col=0; col < uiUtil_Calendar.NUM_DAYS_IN_A_WEEK; ++col) {
      currentDate.incrementDay();
      this.__updateCellData(currentRow.cells[col], currentDate);
    }
  }
};
uiCalendar_Suite.prototype.__updateCellData = function(cell, date) {
  this.__detachCellClickHandler(cell);
  this.__elementHandler.clearChildDomObjects(cell);
  if (date == null) {
    uiHtml_Document.createTextNode(" ", cell);
  }
  else {
    uiHtml_Document.createTextNode(date.getDay(), cell);
    this.__attachCellClickHandler(cell, date);
    this.__updateCellClass(cell, date);
  }
};
uiCalendar_Suite.prototype.__updateCellClass = function(cell, date) {
  var cssClass = this.__classResolver.getForDate(
      date.toDate(), this.__selectedDate.toDate());
  cell.className = cssClass;
};
uiCalendar_Suite.prototype.__attachCellClickHandler = function(domCell, date) {
  if (this.__actionResolver == null) {
    return null;
  }
  var eventNames = this.__actionResolver.getEventsOfInterest();
  for (var i = 0; i < eventNames.length; ++i) {
    var action = this.__actionResolver.getAction(
        eventNames[i], this, date.toDate(), this.__selectedDate.toDate());
    if (action != null) {
      this.__elementHandler.appendEventHandler(domCell, eventNames[i], action);
    }
  }
};
uiCalendar_Suite.prototype.__detachCellClickHandler = function(domCell) {
  if (this.__actionResolver == null) {
    return;
  }
  var eventNames = this.__actionResolver.getEventsOfInterest();
  for (var i = 0; i < eventNames.length; ++i) {
    this.__elementHandler.clearEventHandlerExtension(domCell, eventNames[i]);
  }
};
function uiCalendar_Suite$YearLister(select, strategy) {
  this.__select = select;
  this.__strategy = strategy;
  this.__select.enableOptionValueMapping();
}
uiCalendar_Suite.YearLister =
    uiUtil_Object.declareClass(uiCalendar_Suite$YearLister, uiUtil_Object);
function uiCalendar_Suite$MonthLister(select) {
  this.__select = select;
  this.__select.enableOptionValueMapping();
}
uiCalendar_Suite.MonthLister =
    uiUtil_Object.declareClass(uiCalendar_Suite$MonthLister, uiUtil_Object);
function uiCalendar_Suite$MonthExtractor(domMonthInput) {
  this.__domMonthInput = domMonthInput;
}
uiCalendar_Suite.MonthExtractor = uiUtil_Object.declareClass(
    uiCalendar_Suite$MonthExtractor, uiUtil_Object);
uiCalendar_Suite.MonthExtractor.prototype.getNewDate = function(selectedDate) {
  selectedDate.setMonth(this.__domMonthInput.value);
  return selectedDate;
};
function uiCalendar_Suite$YearExtractor(domYearInput) {
  this.__domYearInput = domYearInput;
}
uiCalendar_Suite.YearExtractor = uiUtil_Object.declareClass(
    uiCalendar_Suite$YearExtractor, uiUtil_Object);
uiCalendar_Suite.YearExtractor.prototype.getNewDate = function(selectedDate) {
  selectedDate.setYear(this.__domYearInput.value);
  return selectedDate;
};
function uiCalendar_Driver() {
  this._super();
  this.__suites = new Array();
}
uiCalendar_Driver = uiUtil_Object.declareSingleton(uiCalendar_Driver, uiUtil_Object);
uiHtml_Window.getInstance().prependEventHandler("load", function(e) {
  uiCalendar_driver = new uiCalendar_Driver();
});
uiCalendar_Driver.prototype.createSuite = function(
    calendarGridId, dayLabels, classResolver, actionResolver) {
  var domTable = uiHtml_Document.getInstance().getDomObjectById(calendarGridId);
  var suite = new uiCalendar_Suite(
      domTable, dayLabels, classResolver, actionResolver);
  var suiteId = this.__suites.length;
  this.__suites[suiteId] = suite;
  return suiteId;
};
uiCalendar_Driver.prototype.registerUpdateTrigger = function(
    suiteId, triggerId, triggerName, eventName, strategy) {
  var trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  this.__suites[suiteId]._addUpdater(trigger, eventName, strategy);
};
uiCalendar_Driver.prototype.registerYearLister = function(
    suiteId, listerId, listerName, strategy) {
  var select = uiHtml_Select.createByEither(listerId, listerName);
  this.__suites[suiteId]._addYearLister(select, strategy);
};
uiCalendar_Driver.prototype.registerMonthLister = function(
    suiteId, listerId, listerName, monthLabels) {
  var select = uiHtml_Select.createByEither(listerId, listerName);
  this.__suites[suiteId]._addMonthLister(select, monthLabels);
};
function uiSort_OptionComparatorStrategy() {
}
uiSort_OptionComparatorStrategy =
    uiUtil_Object.declareClass(uiSort_OptionComparatorStrategy, uiUtil_Object);
uiSort_OptionComparatorStrategy.prototype.compare = function(first, second) {
  var str1 = first.text.toLowerCase();
  var str2 = second.text.toLowerCase();
  if(str1 == str2) {
    return 0;
  }
  return (str1 > str2) ? 1 : -1;
};
function uiSort_Suite(list, comparator) {
  this._super();
  this.__list = list;
  this.__comparator = comparator;
}
uiSort_Suite = uiUtil_Object.declareClass(uiSort_Suite, uiUtil_Object);
uiSort_Suite.prototype._initAscendingTrigger = function(trigger) {
  this.__ascendingTrigger = trigger;
  var suite = this;
  this.__ascendingTrigger.appendEventHandler("click", function(e) {
    suite.__sortAsc();
  });
};
uiSort_Suite.prototype._initDescendingTrigger = function(trigger) {
  this.__descendingTrigger = trigger;
  var suite = this;
  this.__descendingTrigger.appendEventHandler("click", function(e) {
    suite.__sortDesc();
  });
};
uiSort_Suite.prototype.__sortAsc = function() {
  this.__list.sortItems(this.__comparator, false);
};
uiSort_Suite.prototype.__sortDesc = function() {
  this.__list.sortItems(this.__comparator, true);
};
function uiSort_Driver() {
  this._super();
}
uiSort_Driver = uiUtil_Object.declareSingleton(uiSort_Driver, uiUtil_Object);
uiHtml_Window.getInstance().prependEventHandler("load", function(e) {
  uiSort_driver = new uiSort_Driver();
});
uiSort_Driver.prototype.createAscendingSuite = function(
    triggerId, triggerName, listId, listName, comparator) {
  var suite = new uiSort_Suite(uiHtml_Group.createByEither(listId, listName), comparator);
  suite._initAscendingTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
uiSort_Driver.prototype.createDescendingSuite = function(
    triggerId, triggerName, listId, listName, comparator) {
  var suite = new uiSort_Suite(uiHtml_Group.createByEither(listId, listName), comparator);
  suite._initDescendingTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
function uiSelect_Suite(selectableList) {
  this._super();
  this.__list = selectableList;
  this.__itemHandler = selectableList.getItemHandler();
  if (this.__list instanceof uiHtml_Select) {
  }
}
uiSelect_Suite = uiUtil_Object.declareClass(uiSelect_Suite, uiUtil_Object);
uiSelect_Suite.prototype._initAllNoneToggle = function(toggle) {
  this.__allNoneToggle = toggle;
  var suite = this;
  this.__allNoneToggle.appendOnStateOn(function(e) {
    suite.__selectAll(e);
  });
  this.__allNoneToggle.appendOnStateOff(function(e) {
    suite.__selectNone(e);
  });
};
uiSelect_Suite.prototype._initAllTrigger = function(trigger) {
  this.__allTrigger = trigger;
  var suite = this;
  this.__allTrigger.appendEventHandler("click", function(e) {
    suite.__selectAll(e);
  });
};
uiSelect_Suite.prototype._initNoneTrigger = function(trigger) {
  this.__noneTrigger = trigger;
  var suite = this;
  this.__noneTrigger.appendEventHandler("click", function(e) {
    suite.__selectNone(e);
  });
};
uiSelect_Suite.prototype._initInverseTrigger = function(trigger) {
  this.__inverseTrigger = trigger;
  var suite = this;
  this.__inverseTrigger.appendEventHandler("click", function(e) {
    suite.__selectInverse(e);
  });
};
uiSelect_Suite.prototype._initRangeTrigger = function(trigger) {
  this.__rangeTrigger = trigger;
  var suite = this;
  this.__rangeTrigger.appendEventHandler("click", function(e) {
    suite.__selectRange(e);
  });
};
uiSelect_Suite.prototype.__selectAll = function(domEvent) {
  var listSize = this.__list.size();
  for(var i = 0; i < listSize; i++) {
    var item = this.__list.getItemAt(i);
    this.__itemHandler.setSelected(item, true, domEvent);
  }
};
uiSelect_Suite.prototype.__selectNone = function(domEvent) {
  var listSize = this.__list.size();
  for(var i = 0; i < listSize; ++i) {
    var item = this.__list.getItemAt(i);
    this.__itemHandler.setSelected(item, false, domEvent);
  }
};
uiSelect_Suite.prototype.__selectInverse = function(domEvent) {
  var listSize = this.__list.size();
  for(var i = 0; i < listSize; ++i) {
    var item = this.__list.getItemAt(i);
    if (this.__itemHandler.isSelected(item)) {
      this.__itemHandler.setSelected(item, false, domEvent);
    }
    else {
      this.__itemHandler.setSelected(item, true, domEvent);
    }
  }
};
uiSelect_Suite.prototype.__selectRange = function(domEvent) {
  var nowSelecting = false;
  var listSize = this.__list.size();
  for (var i = 0; i < listSize; ++i) {
    var currItem = this.__list.getItemAt(i);
    var nextItem = this.__list.getItemAt(i + 1);
    if (this.__itemHandler.isSelected(currItem) &&
        (i + 1 < listSize) && !this.__itemHandler.isSelected(nextItem)) {
      nowSelecting = !nowSelecting;
      var endPairIndex = -1;
      for (var j = i + 2; j < listSize; ++j) {
        var item = this.__list.getItemAt(j);
        if (this.__itemHandler.isSelected(item)) {
          endPairIndex = j;
          break;
        }
      }
      if (endPairIndex == -1) {
        return;
      }
      if (nowSelecting) {
        for (var j=i+1; j < endPairIndex; j++) {
          var item = this.__list.getItemAt(j);
          this.__itemHandler.setSelected(item, true, domEvent);
        }
      }
      i = endPairIndex - 1;
    }
  }
};
function uiSelect_Driver() {
  this._super();
}
uiSelect_Driver = uiUtil_Object.declareSingleton(uiSelect_Driver, uiUtil_Object);
uiHtml_Window.getInstance().prependEventHandler("load", function(e) {
  uiSelect_driver = new uiSelect_Driver();
});
uiSelect_Driver.prototype.createAllNoneSuite = function(
    toggleId, toggleName, listId, listName,
    optIsOn, optOnPropArray, optOffPropArray) {
  var toggle = uiHtml_Toggle.createByEither(
      toggleId, toggleName, null, null, uiUtil_Type.getBoolean(optIsOn, false));
  if (optOnPropArray) {
    toggle.setOnProperties(optOnPropArray);
  }
  if (optOffPropArray) {
    toggle.setOffProperties(optOffPropArray);
  }
  var suite = new uiSelect_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initAllNoneToggle(toggle);
};
uiSelect_Driver.prototype.createAllSuite = function(triggerId, triggerName, listId, listName) {
  var suite = new uiSelect_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initAllTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
uiSelect_Driver.prototype.createNoneSuite = function(triggerId, triggerName, listId, listName) {
  var suite = new uiSelect_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initNoneTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
uiSelect_Driver.prototype.createInverseSuite = function(triggerId, triggerName, listId, listName) {
  var suite = new uiSelect_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initInverseTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
uiSelect_Driver.prototype.createRangeSuite = function(triggerId, triggerName, listId, listName) {
  var suite = new uiSelect_Suite(uiHtml_Group.createByEither(listId, listName));
  suite._initRangeTrigger(uiHtml_Element.createByEither(triggerId, triggerName));
};
function uiSearch_Suite(trigger, eventName, searchStrategy, targetPopulationStrategy) {
  this._super();
  this.__searchStrategy = searchStrategy;
  this.__targetPopulationStrategy = targetPopulationStrategy;
  this.__lifeCycleNotifier = new uiHtml_LifeCycleNotifier();
  var suite = this;
  trigger.appendEventHandler(eventName, function(e) {
    suite._performSearch(e);
  });
}
uiSearch_Suite = uiUtil_Object.declareClass(uiSearch_Suite, uiUtil_Object);
uiSearch_Suite.prototype._setLifeCycleListener = function(listener) {
  this.__lifeCycleNotifier.setListener(listener);
};
uiSearch_Suite.prototype._performSearch = function(domEvent) {
  if (!this.__lifeCycleNotifier.notify("onBeforeSearch", domEvent)) {
    return;
  }
  var suite = this;
  this.__searchStrategy.initiateSearch(function(options) {
    suite.__targetPopulationStrategy.populate(options);
    suite.__lifeCycleNotifier.notify("onAfterSearch", domEvent);
  });
};
function uiSearch_Driver() {
  this._super();
  this.__suites = new Array();
}
uiSearch_Driver = uiUtil_Object.declareSingleton(uiSearch_Driver, uiUtil_Object);
uiHtml_Window.getInstance().prependEventHandler("load", function(e) {
  uiSearch_driver = new uiSearch_Driver();
});
uiSearch_Driver.prototype.createSuite = function(
    triggerId, triggerName, eventName,
    searchStrategy, targetPopulationStrategy) {
  var trigger = uiHtml_Element.createByEither(triggerId, triggerName);
  var suiteId = this.__suites.length;
  this.__suites[suiteId] = new uiSearch_Suite(trigger,
      eventName, searchStrategy, targetPopulationStrategy);
  return suiteId;
};
uiSearch_Driver.prototype.setLifeCycleListener = function(suiteId, listener) {
  this.__suites[suiteId]._setLifeCycleListener(listener);
};
uiSearch_Driver.prototype.performSearch = function(suiteId, domEvent) {
  this.__suites[suiteId]._performSearch(domEvent);
};
function uiSearch_OptionTransferHook(sourceId, sourceName, targetId, targetName) {
  this._super();
  this.__source = uiHtml_Select.createByEither(sourceId, sourceName);
  this.__target = uiHtml_Select.createByEither(targetId, targetName);
}
uiSearch_OptionTransferHook = uiUtil_Object.declareClass(
    uiSearch_OptionTransferHook, uiUtil_Object);
uiSearch_OptionTransferHook.prototype.onAfterSearch = function(domEvent) {
  uiOptionTransfer_Suite.syncItems(this.__source, this.__target);
};
function uiSearch_SearchStrategy(inputId, inputName, options) {
  this._super();
  this.__input = uiHtml_Group.createByEither(inputId, inputName);
  this.__options = options;
}
uiSearch_SearchStrategy =
    uiUtil_Object.declareClass(uiSearch_SearchStrategy, uiUtil_Object);
uiSearch_SearchStrategy.prototype.initiateSearch =
    function(callbackFunction) {
  var keywords = this.__input.getValues();
  var aggregateOptions = new Array();
  for (var i = 0; i < keywords.length; ++i) {
    var options = this.__options[keywords[i]];
    if (options != null) {
      aggregateOptions = aggregateOptions.concat(options);
    }
  }
  callbackFunction(aggregateOptions);
};
function uiSearch_TargetPopulationStrategy(targetId, targetName) {
  this._super();
   this.__target = uiHtml_Select.createByEither(targetId, targetName);
 }
uiSearch_TargetPopulationStrategy =
    uiUtil_Object.declareClass(uiSearch_TargetPopulationStrategy, uiUtil_Object);
uiSearch_TargetPopulationStrategy.prototype.populate = function(options) {
  this.__target.clearItems();
  for (var i = 0; i < options.length; ++i) {
    this.__target.addItem(options[i]);
  }
};


