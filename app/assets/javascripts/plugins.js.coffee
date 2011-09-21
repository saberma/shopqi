window.log = ->
  log.history = log.history or []
  log.history.push arguments
  arguments.callee = arguments.callee.caller
  console.log Array::slice.call(arguments)  if @console

((b) ->
  c = ->
  d = "assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(",")

  while a = d.pop()
    b[a] = b[a] or c
) window.console = window.console or {}

window.msg = (text, delay = null) ->
  flash_message text, 'notice', delay

window.error_msg = (text, delay = null) ->
  flash_message text, 'errors', delay

window.flash_message = (text, type, delay = 2000) ->
  if $("#sticky-progress")[0] # 指引
    $("#sticky-progress").children('.flash').remove()
    $("<div/>").addClass("flash #{type}").html(text).prependTo("#sticky-progress").fadeIn(100).delay(delay).fadeOut()
  else
    $("#flash#{type}").html(text).fadeIn(100).delay(delay).fadeOut 500
