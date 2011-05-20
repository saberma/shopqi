window.log = function(){
  log.history = log.history || [];  
  log.history.push(arguments);
  arguments.callee = arguments.callee.caller;  
  if(this.console) console.log( Array.prototype.slice.call(arguments) );
};
(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();)b[a]=b[a]||c})(window.console=window.console||{});

window.msg = function(text){
  $('#flashnotice').html(text).fadeIn(100).delay(2000).fadeOut(500)
}

window.error_msg = function(text){
  $('#flasherrors').html(text).fadeIn(100).delay(2000).fadeOut(500)
}
