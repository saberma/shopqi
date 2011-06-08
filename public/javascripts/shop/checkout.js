/* DO NOT MODIFY. This file was compiled Tue, 07 Jun 2011 11:28:53 GMT from
 * /home/saberma/Documents/shopqi/app/coffeescripts/shop/checkout.coffee
 */

$(document).ready(function() {
  $('#shipping-toggle').change(function() {
    var checked;
    checked = $(this).attr('checked');
    $('#shipping').toggle(!checked);
    return $('#shipping-same').toggle(checked);
  }).change();
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