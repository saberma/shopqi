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

      if $('#email_include_html').attr('checked') is 'checked'
        $('#html_form').show()

      if $('.order-subscription').size() == 0
        $('#order-notification-list').hide()
        $('#add-subscription-btn').show()
        false

      #预览
      Preview = (id)  ->
        oldAction = $('#edit_email_form').attr('action')
        $form = $($('#edit_email_form').get(0))
        $form.attr('action', "/admin/notifications/#{id}")
        $form.attr('target', '_blank')
        $form.submit()
        $form.attr('action', oldAction)
        $form.removeAttr('target')
        return false

      $('.preview a').each ->
        $(this).click ->
          Preview($(this).attr('id'))
