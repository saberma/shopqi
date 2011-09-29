
var selectCallback = function(variant, selector) {
  if (variant && variant.available == true) {
    // selected a valid variant
    jQuery('#purchase').removeClass('disabled').removeAttr('disabled'); // remove unavailable class from add-to-cart button, and re-enable button
    jQuery('.price-field').html(ShopQi.formatMoney(variant.price, "{{shop.money_with_currency_format}}"));  // update price field
  } else {
    // variant doesn't exist
    jQuery('#purchase').addClass('disabled').attr('disabled', 'disabled');      // set add-to-cart button to unavailable class and disable button
    var message = variant ? "Sold Out" : "Unavailable";    
    jQuery('.price-field').text(message); // update price-field message
  }
};


// initialize multi selector for product
jQuery(document).ready(function() {
  new ShopQi.OptionSelectors("product-select", { product: {{ product | json }}, onVariantSelected: selectCallback });
  $('#options label').addClass('selector-label');
  $('#options select').addClass('selector-option');
});


