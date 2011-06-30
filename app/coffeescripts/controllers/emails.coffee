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
      if $('#order-notification-list').size() > 0
        $('#add-subscription').show()
      else
        $('#add-subscription-btn').show()
      false

    $('#email_include_html').change ->
      $('#html_form').toggle()
      false

    $(document).ready ->

      if $('#email_include_html').attr('checked')
        $('#html_form').show()

      if $('.order-subscription').size() == 0
        $('#order-notification-list').hide()
        $('#add-subscription-btn').show()
        false
