/* DO NOT MODIFY. This file was compiled Tue, 16 Aug 2011 03:32:07 GMT from
 * /Users/Apple/workplace/shopqi/app/coffeescripts/shop/checkout.coffee
 */

$(document).ready(function() {
  $('#shipping-toggle').change(function() {
    var checked;
    checked = $(this).attr('checked');
    $('#shipping').toggle(!checked);
    return $('#shipping-same').toggle(checked);
  }).change();
  $('#shipping-rates').change(function() {
    var action, href;
    action = $(this).closest('form').attr('action');
    href = action.substr(0, action.lastIndexOf('/')) + '/update_total_price';
    $.post(href, {
      shipping_rate: $(this).val()
    }, function(data) {
      var img;
      log(data);
      img = $("#cost :first-child")[0];
      return $('#cost').html(data.total_price).append(img);
    });
    $(this).ajaxStart(function() {
      return $('.spinner').show();
    });
    return $(this).ajaxStop(function() {
      return $('.spinner').hide();
    });
  });
  return $(".region").each(function() {
    var selects;
    selects = $('select', this);
    return selects.change(function() {
      var $this, select, select_index;
      $this = this;
      select_index = selects.index($this);
      select = selects.eq(select_index + 1);
      if ($(this).val() && select[0]) {
        return $.get("/district/" + $(this).val(), function(data) {
          var options, result;
          result = eval(data);
          options = select.attr("options");
          $("option:gt(0)", select).remove();
          return $.each(result, function(i, item) {
            return options[options.length] = new Option(item[0], item[1]);
          });
        });
      }
    });
  });
});