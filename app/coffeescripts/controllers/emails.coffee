App.Controllers.Emails = Backbone.Controller.extend

  initialize: ->
    $('#add-notify').click ->
      $('#add-subscription-details').toggle()
      $('#add-subscription').hide()
      $('#email-detail').show()
      false

    $('#subscription-type').change ->
      $('#email-detail,#cellphone-detail').hide()
      id = $(this).val() + '-detail'
      $("##{id}").show()
      false

    $('#cancel').click ->
      $('#add-subscription-details').toggle()
      if $('#order-notification-list')
        $('#add-subscription').show()
      else
        $('#add-subscription-btn').show()
      false

    $(document).ready ->
      if $('#order-notification-list').size() == 0
        $('#add-subscription-btn').show()
        false
