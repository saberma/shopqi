App.Controllers.Articles = Backbone.Controller.extend

  initialize: ->
    #标签
    $('#tag-list a').click ->
      $(this).toggleClass('active-tag')
      tags = StringUtils.to_a($('#article_tags_text').val())
      tag = $(this).text()
      if tag not in tags
        tags.push tag
      else
        tags = _.without tags, tag
      $('#article_tags_text').val(tags.join(', '))
      false
    $('#article_tags_text').keyup ->
      tags = StringUtils.to_a($('#article_tags_text').val())
      $('#tag-list a').each ->
        if $(this).text() in tags
          $(this).addClass('active-tag')
        else
          $(this).removeClass('active-tag')
    .keyup()

    $('#article-show,#article-edit-link,.cancel').click ->
      $('#article-edit').toggle()
      val = $('#article-edit-link').html()
      if val == '返回'
        $('#article-edit-link').html('修改')
      else
        $('#article-edit-link').html('返回')
      $('#article-show').toggle()

