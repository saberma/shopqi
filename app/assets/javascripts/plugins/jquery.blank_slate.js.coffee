###
# jquery.blank_slate. The jQuery blank slate plugin
#
# Copyright (c) 2011 saberma
# http://www.shopqi.com
#
# Licensed under MIT
# http://www.opensource.org/licenses/mit-license.php
#
# Launch  : Aug 2011
# Version : 1.0.0
# Released: Tue 16th Aug, 2011 - 00:00
###
(($) ->
  BlankSlate = (element, options) ->
    self = this
    $this = $(element)
    defaults = {}
    settings = $.extend(defaults, options or {})

    @blank_slate = () ->
      self = this
      @id = $this.attr('id')
      @features = $("##{@id}-features") # 左边特性列表
      @screenshot = $("##{@id}-screenshot") # 右边截图
      @features_selector = "##{@id}-features li" # 左边特性列表项
      @screenshot_selector = "##{@id}-screenshot div.overlay" # 右边辅助层
      @initializeMask()
      $(@features_selector).each -> $('<div/>').addClass('feature-overlay').html('&nbsp;').appendTo(this)
      $this.mouseover (event) -> self.hoverEvent(event)

    @hoverEvent = (event) ->
      @resetActive("#{@features_selector}, #{@screenshot_selector}")
      element = $(event.target)
      if (element[0].nodeName is 'DIV' and element.hasClass("overlay"))
        selector = ".#{element.attr('class')}".replace "overlay ", ""
        @displayActive(selector)
      if element[0].nodeName is 'DIV' and element.hasClass("feature-overlay")
        selector = ".#{element.parent().attr('class')}".replace "last ", ""
        @displayActive(selector)

    @displayActive = (selector) ->
      $this.find(selector).each -> $(this).addClass("active")
      if (@screenshot.find(selector).length > 0)
        @displayMask(@screenshot.find(selector).first())
        @features.removeClass("default")

    @resetActive = (selector) ->
      $(selector).each -> $(this).removeClass("active")
      unless $this.find(".active")[0]
        @features.addClass("default")
        @resetMask()

    @initializeMask = () ->
      @topMask = $('<div/>').addClass('overlay-mask').html '&nbsp;'
      @rightMask = $('<div/>').addClass('overlay-mask').html '&nbsp;'
      @bottomMask = $('<div/>').addClass('overlay-mask').html '&nbsp;'
      @leftMask = $('<div/>').addClass('overlay-mask').html '&nbsp;'
      @screenshot.append(@topMask)
      @screenshot.append(@rightMask)
      @screenshot.append(@bottomMask)
      @screenshot.append(@leftMask)

    @displayMask = (b) ->
      c = @screenshot.width() - 2
      e = @screenshot.height() - 2
      g = b.position().top
      k = b.position().left
      o = b.width() + 4
      b = b.height() + 4
      @topMask.css top: "1px", left: "1px", width: c + "px", height: g + "px",
      @rightMask.css top: g + "px", left: k + o + "px", width: c - (k + o) + "px", height: b + "px",
      @bottomMask.css top: g + b + "px", left: "1px", width: c + "px", height: e - (g + b) + "px",
      @leftMask.css top: g + "px", left: "1px", width: k + "px", height: b + "px",

    @resetMask = () ->
      @topMask.css top: "0px", left: "0px", width: "0px", height: "0px"
      @rightMask.css top: "0px", left: "0px", width: "0px", height: "0px"
      @bottomMask.css top: "0px", left: "0px", width: "0px", height: "0px"
      @leftMask.css top: "0px", left: "0px", width: "0px", height: "0px"

    @blank_slate()

  $.fn.extend blank_slate: (options) ->
    @each ->
      return if $(this).data("blank_slate")
      blank_slate = new BlankSlate(this, options)
      $(this).data "blank_slate", blank_slate
) jQuery
