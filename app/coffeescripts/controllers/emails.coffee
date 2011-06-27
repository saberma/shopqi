App.Controllers.Emails = Backbone.Controller.extend

  initialize: ->
    $('#add-notify').click ->
      $('#add-subscription-details').toggle()
      $('#add-subscription').hide()
      $('#email-detail').show()

    $('#subscription-type').change ->
      $('#email-detail,#cellphone-detail').hide()
      id = $(this).val() + '-detail'
      $("##{id}").show()
