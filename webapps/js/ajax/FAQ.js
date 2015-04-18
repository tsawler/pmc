if (dwr == null) var dwr = {};
if (dwr.engine == null) dwr.engine = {};
if (DWREngine == null) var DWREngine = dwr.engine;

dwr.engine._defaultPath = '/dwr';

if (FAQ == null) var FAQ = {};
FAQ._path = '/dwr';
FAQ.initSession = function(callback) {
  dwr.engine._execute(FAQ._path, 'FAQ', 'initSession', callback);
}
FAQ.updateFAQText = function(p0, callback) {
  dwr.engine._execute(FAQ._path, 'FAQ', 'updateFAQText', p0, callback);
}
