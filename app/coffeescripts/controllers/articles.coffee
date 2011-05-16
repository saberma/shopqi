App.Controllers.Articles = Backbone.Controller.extend

  routes:
    "articles/edit":      "edit"
    "":                "index"

  edit: ->
    $('#article-edit').show()
    $('#article-edit-link').attr("href","#")
    #返回
    $('#article-edit-link').html('\u8FD4\u56DE')
    $('#article-show').hide()

  index: ->
    $('#article-edit').hide()
    $('#article-edit-link').html('\u4FEE\u6539')
    $('#article-show').show().bind 'click', ->
      window.location = '#articles/edit'
