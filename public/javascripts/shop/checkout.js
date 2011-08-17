/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 03:32:01 GMT from
 * /Users/Apple/workplace/shopqi/app/coffeescripts/shop/checkout.coffee
 */

$(document).ready(function() {
  $('#shipping-toggle').change(function() {
    var checked;
    checked = $(this).attr('checked');
    $('#shipping').toggle(!checked);
    return $('#shipping-same').toggle(checked);
  }).change();
  if ($('#no-shipping-rates').size() > 0) {
    $('input#complete-purchase').attr('disabled', true);
  }
  $('#shipping-rates').change(function() {
    var action, href, rate;
    action = $(this).closest('form').attr('action');
    href = action.substr(0, action.lastIndexOf('/')) + '/update_total_price';
    rate = $(this).val();
    $.post(href, {
      shipping_rate: rate
    }, function(data) {
      var img;
      if (data.error === 'shipping_rate') {
        $('#shipping-rate-error').show();
        $("#shipping-rates option[value='" + data.shipping_rate + "']").remove();
        return $('#shipping-rate').change();
      } else {
        $('#shipping-rate-error').hide();
        img = $("#cost :first-child")[0];
        $('#cost').html('¥' + data.total_price).append(img);
        return $('#shipping_span').html(" ..包含快递费" + data.shipping_rate_price + "元");
      }
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