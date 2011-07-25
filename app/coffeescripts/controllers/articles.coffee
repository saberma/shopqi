App.Controllers.Articles = Backbone.Controller.extend

  initialize: ->
    #标签
    TagUtils.init 'article_tags_text'

    $('#article-show,#article-edit-link,.cancel').click ->
      $('#article-edit').toggle()
      val = $('#article-edit-link').html()
      if val == '返回'
        $('#article-edit-link').html('修改')
      else
        $('#article-edit-link').html('返回')
      $('#article-show').toggle()

