// Provide a default path to dwr.engine
if (dwr == null) var dwr = {};
if (dwr.engine == null) dwr.engine = {};
if (DWREngine == null) var DWREngine = dwr.engine;

dwr.engine._defaultPath = '/dwr';

if (Effects == null) var Effects = {};
Effects._path = '/dwr';
Effects.initSession = function(callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'initSession', callback);
}
Effects.fadeEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'fadeEffect', p0, callback);
}
Effects.fadeEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'fadeEffect', p0, p1, callback);
}
Effects.blindUpEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'blindUpEffect', p0, callback);
}
Effects.blindUpEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'blindUpEffect', p0, p1, callback);
}
Effects.blindDownEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'blindDownEffect', p0, callback);
}
Effects.blindDownEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'blindDownEffect', p0, p1, callback);
}
Effects.appearEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'appearEffect', p0, callback);
}
Effects.appearDownEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'appearDownEffect', p0, p1, callback);
}
Effects.dropOutEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'dropOutEffect', p0, callback);
}
Effects.dropOutEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'dropOutEffect', p0, p1, callback);
}
Effects.foldEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'foldEffect', p0, callback);
}
Effects.foldDownEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'foldDownEffect', p0, p1, callback);
}
Effects.growEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'growEffect', p0, callback);
}
Effects.growEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'growEffect', p0, p1, callback);
}
Effects.highlightEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'highlightEffect', p0, callback);
}
Effects.hightlightEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'hightlightEffect', p0, p1, callback);
}
Effects.puffEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'puffEffect', p0, callback);
}
Effects.puffEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'puffEffect', p0, p1, callback);
}
Effects.pulsateEffect = function(p0, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'pulsateEffect', p0, callback);
}
Effects.pulsateEffect = function(p0, p1, callback) {
  dwr.engine._execute(Effects._path, 'Effects', 'pulsateEffect', p0, p1, callback);
}

