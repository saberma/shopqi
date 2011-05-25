App.Controllers.Articles = Backbone.Controller.extend

  routes:
    "articles/edit":      "edit"
    "":                "index"

  edit: ->
    $('#article-edit').show()
    $('#article-edit-link').attr("href","#")
    #返回
    $('#article-edit-link').html('返回')
    $('#article-show').hide()

  index: ->
    $('#article-edit').hide()
    $('#article-edit-link').html('修改')
    $('#article-show').show().bind 'click', ->
      window.location = '#articles/edit'
