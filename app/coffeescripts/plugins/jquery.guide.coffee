###
jquery.guide. The jQuery guide plugin

Copyright (c) 2011 saberma
http://www.shopqi.com

Licensed under MIT
http://www.opensource.org/licenses/mit-license.php

Launch  : Aug 2011
Version : 1.0.0
Released: Tue 2th Aug, 2011 - 00:00
###
(($) ->
  Guide = (element, content, position) ->
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
      #e[position.hook].call this, target, position.offset
      @attachBelow target, position.offset
      #@reattach = e[position.hook].bind(this, b)

    @attachBelow = (target, offset) ->
      position = target.offset()
      left =  position.left - (@wrapper.outerWidth() - target.outerWidth()) / 2
      top = 7 + target.outerHeight() + position.top
      top += offset  if offset
      @wrapper.addClass "below"
      @wrapper.css left: left, top: top

    @move = () ->
      @wrapper.css('opacity', 0).animate opacity: 1, top: '-=90px', 'slow'

    @buildElement content
    @attach element, position
    @move()

  Source = (element, options) ->
    self = this
    $this = $(element)
    defaults = {}
    settings = $.extend(defaults, options or {})
    @source = ->
      $this.click ->
        target = $($(this).attr('data-guide-target'))
        $(document.body).click()
        text = $(this).attr('data-guide-text')
        position = $(this).attr('data-guide-position')
        new Guide(target, text, hook: position, offset: 90)
        false
    @source()

  $.fn.extend guide: (options) ->
    @each ->
      return if $(this).data("source")
      source = new Source(this, options)
      $(this).data "source", source
) jQuery
