// Provide a default path to dwr.engine
if (dwr == null) var dwr = {};
if (dwr.engine == null) dwr.engine = {};
if (DWREngine == null) var DWREngine = dwr.engine;

dwr.engine._defaultPath = '/dwr';

if (Chat == null) var Chat = {};
Chat._path = '/dwr';
Chat.addMessage = function(p0, callback) {
  dwr.engine._execute(Chat._path, 'Chat', 'addMessage', p0, callback);
}
Chat.initSession = function(callback) {
  dwr.engine._execute(Chat._path, 'Chat', 'initSession', callback);
}
