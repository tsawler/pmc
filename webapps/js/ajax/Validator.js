if (dwr == null) var dwr = {};
if (dwr.engine == null) dwr.engine = {};
if (DWREngine == null) var DWREngine = dwr.engine;

dwr.engine._defaultPath = '/dwr';

if (Validator == null) var Validator = {};
Validator._path = '/dwr';
Validator.getIncludedFile = function(p0, callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'getIncludedFile', p0, callback);
}
Validator.URLValid = function(p0, callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'URLValid', p0, callback);
}
Validator.DateValid = function(p0, callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'DateValid', p0, callback);
}
Validator.EmailValid = function(p0, callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'EmailValid', p0, callback);
}
Validator.CreditCardValid = function(p0, callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'CreditCardValid', p0, callback);
}
Validator.userNameOkay = function(p0, callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'userNameOkay', p0, callback);
}
Validator.UpdateMenuItemOrder = function(p0, callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'UpdateMenuItemOrder', p0, callback);
}
Validator.initSession = function(callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'initSession', callback);
}
Validator.isValidUsername = function(p0, callback) {
  dwr.engine._execute(Validator._path, 'Validator', 'isValidUsername', p0, callback);
}
