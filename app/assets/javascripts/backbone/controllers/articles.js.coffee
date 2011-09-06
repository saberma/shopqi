App.Controllers.Articles = Backbone.Controller.extend

  routes:
    "nothing": "nothing"

  initialize: ->
    #标签
    Utils.Tag.init 'article_tags_text'

    $('#article-show,#article-edit-link,.cancel').click ->
      $('#article-edit').toggle()
      val = $('#article-edit-link').html()
      if val == '返回'
        $('#article-edit-link').html('修改')
      else
        $('#article-edit-link').html('返回')
      $('#article-show').toggle()

    $('#status-filter-link').click ->
      $('#author-select > ul').hide()
      $('#tag-select > ul').hide()
      $('#article-status-select > ul').toggle()
      false

    $('#author-filter-link').click ->
      $('#author-select > ul').toggle()
      $('#tag-select > ul').hide()
      $('#article-status-select > ul').hide()
      false

    $('#tag-filter-link').click ->
      $('#author-select > ul').hide()
      $('#tag-select > ul').toggle()
      $('#article-status-select > ul').hide()
      false

    $(document).click ->
      $('.dropdown').each ->
        $(this).hide()

