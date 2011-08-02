###
jquery.guide. The jQuery guide plugin

Copyright (c) 2011 saberma
http://www.shopqi.com

Licensed under MIT
http://www.opensource.org/licenses/mit-license.php

Launch  : Aug 2011
Version : 1.0.0
Released: Tue 2nd Aug, 2011 - 00:00
###
(($) ->
  Guide = (element, content, position, animate) ->
    @buildElement = (content) ->
      @el = $("<div/>").html content
      @wrapper = $("<div/>").addClass("guide-outer").css 'position', 'absolute'
      @wrapper.append("<span class='triangle'/>").append(@el).appendTo document.body

    # postion => {hook: bottom, offset: 90}
    @attach = (target, position) ->
      #@wrapper.style.position = "fixed"  if b.up(".position-fixed")
      e =
        left: @attachLeft
        bottom: @attachBelow
        top: @attachAbove
        right: @attachRight
      e[position.hook].call this, target, position.offset
      #@reattach = e[position.hook].bind(this, b)

    @attachBelow = (target, offset) ->
      position = target.offset()
      left =  position.left - (@wrapper.outerWidth() - target.outerWidth()) / 2
      top = 7 + target.outerHeight() + position.top
      top += offset  if offset
      @wrapper.addClass("below").css left: left, top: top

    @attachAbove = (target, offset) ->
      position = target.offset()
      left =  position.left - (@wrapper.outerWidth() - target.outerWidth()) / 2
      top = -25 - target.outerHeight() + position.top
      top += offset  if offset
      @wrapper.addClass("above").css left: left, top: top

    @attachLeft = (target, offset) ->
      position = target.offset()
      top =  position.top - (@wrapper.outerHeight() - target.outerHeight()) / 2
      left = -24 - @el.outerWidth() + position.left
      left -= offset  if offset
      @wrapper.addClass("left").css left: left, top: top

    @attachRight = (target, offset) ->
      position = target.offset()
      top =  position.top - (@wrapper.outerHeight() - target.outerHeight()) / 2
      left = 3 + @el.outerWidth() + position.left
      left -= offset  if offset
      @wrapper.addClass("right").css left: left, top: top

    @clear = ->
      unless @cleared
        @wrapper.remove()
        @cleared = true

    @clickHandler = ->
      @clear()

    @buildElement content
    @attach element, position
    animate && animate.call(this)
    this

  Source = (element, options) ->
    self = this
    $this = $(element)
    defaults = {}
    settings = $.extend(defaults, options or {})

    @guideIt = () ->
      target = $($this.attr('data-guide-target'))
      $(document.body).click()
      text = $this.attr('data-guide-text')
      position = $this.attr('data-guide-position')
      target.closest('ul').closest('li').children('.nav-link').click() # 打开下拉选项
      guide = new Guide target, text, hook: position, offset: {left: 30, bottom: 90, right: 0}[position], ->
        @wrapper.css('opacity', 0).animate self.offset[position], 'slow'
      $(document).click guide.clickHandler.bind(guide) # 关闭
      $this.data 'guide', guide

    @source = ->
      $this.click ->
        guide = $this.data("guide")
        !(guide && !guide.cleared) && self.guideIt()
        false

    @offset =
      bottom:
        opacity: 1
        top: '-=90px'
      left:
        opacity: 1
        left: '+=30px'

    @source()

  $.fn.extend guide: (options) ->
    @each ->
      return if $(this).data("source")
      source = new Source(this, options)
      $(this).data "source", source
) jQuery
