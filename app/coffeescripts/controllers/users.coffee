App.Controllers.Users = Backbone.Controller.extend
 
  initialize: ->
    $('#add-user').click ->
      $("#new-user-form").toggle()
      $("#add-user").toggle()
      false

    $('#cancel').click ->
      $('#new-user-form').hide()
      $('#add-user').show()
      false

    $(".closure-lightbox").click ->
      id = $(this).attr("href").substr(7)
      $.getJSON "/admin/users/#{id}", (user) ->
        template = Handlebars.compile $('#user-details-area').html()
        $.blockUI {message: template user}
        $('.blockOverlay,.shopify-dialog-title-close').attr('title','单击关闭').click($.unblockUI) 


