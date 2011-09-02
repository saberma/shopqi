/* DO NOT MODIFY. This file was compiled Tue, 09 Aug 2011 14:14:43 GMT from
 * /Users/Apple/workplace/shopqi/app/coffeescripts/plugins.coffee
 */

window.log = function() {
  log.history = log.history || [];
  log.history.push(arguments);
  arguments.callee = arguments.callee.caller;
  if (this.console) {
    return console.log(Array.prototype.slice.call(arguments));
  }
};
(function(b) {
  var a, c, d, _results;
  c = function() {};
  d = "assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(",");
  _results = [];
  while (a = d.pop()) {
    _results.push(b[a] = b[a] || c);
  }
  return _results;
})(window.console = window.console || {});
window.msg = function(text) {
  return flash_message(text, 'notice');
};
window.error_msg = function(text) {
  return flash_message(text, 'errors');
};
window.flash_message = function(text, type) {
  if ($("#sticky-progress")[0]) {
    $("#sticky-progress").children('.flash').remove();
    return $("<div/>").addClass("flash " + type).html(text).prependTo("#sticky-progress").fadeIn(100).delay(2000).fadeOut();
  } else {
    return $("#flash" + type).html(text).fadeIn(100).delay(2000).fadeOut(500);
  }
};