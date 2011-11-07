if ((typeof ShopQi) === 'undefined') {
  ShopQi = {};
}

/* 

Override so that ShopQi.formatMoney returns pretty
money values instead of cents.

*/

ShopQi.money_format = '$ {{amount}}';

/* 

Events (override!)

Example override:
  ... add to your theme.liquid's script tag....

  ShopQi.onItemAdded = function(line_item) {
    $('message').update('加入 '+line_item.title + '...');
  }
  
*/

ShopQi.onError = function(XMLHttpRequest, textStatus) {
  // ShopQi returns a description of the error in XMLHttpRequest.responseText.
  // It is JSON.
  // Example: {"description":"The product 'Amelia - Small' is already sold out.","status":500,"message":"Cart Error"}
  var data = eval('(' + XMLHttpRequest.responseText + ')');
  if (!!data.message) {
    alert(data.message + '(' + data.status  + '): ' + data.description);
  } else {
    alert('错误 : ' + ShopQi.fullMessagesFromErrors(data).join('; ') + '.');
  }
};

ShopQi.fullMessagesFromErrors = function(errors) {
  var fullMessages = [];
  jQuery.each(errors, function(attribute, messages) {
    jQuery.each(messages, function(index, message) {
      fullMessages.push(attribute + ' ' + message);
    });
  });
  return fullMessages
}

ShopQi.onCartUpdate = function(cart) {
  alert('购物车中现有' + cart.item_count + '个商品.');
};  

ShopQi.onCartShippingRatesUpdate = function(rates, shipping_address) {
  var readable_address = '';
  if (shipping_address.zip) readable_address += shipping_address.zip + ', ';
  if (shipping_address.province) readable_address += shipping_address.province + ', ';
  readable_address += shipping_address.country
  alert('有' + rates.length + '种物流方式支持配送至' + readable_address +', 最低价格为:'+ ShopQi.formatMoney(rates[0].price) +'.');
};  

ShopQi.onItemAdded = function(line_item) {
  alert(line_item.title + '已经加入您的购物车.');
};

ShopQi.onProduct = function(product) {
  alert('成功接收' + product.title + '的信息.');
};

/* Tools */

/* 
Examples of call:
ShopQi.formatMoney(600000, '€{{amount_with_comma_separator}} EUR')
ShopQi.formatMoney(600000, '€{{amount}} EUR')
ShopQi.formatMoney(600000, '${{amount_no_decimals}}')
ShopQi.formatMoney(600000, '{{ shop.money_format }}') in a Liquid template!

In a Liquid template, you have access to a shop money formats with:
{{ shop.money_format }}
{{ shop.money_with_currency_format }}
{{ shop.money_without_currency_format }}
All these formats are editable on the Preferences page in your admin.
*/
ShopQi.formatMoney = function(cents, format) {
  if (typeof cents == 'string') cents = cents.replace('.','');
  var value = '';
  var patt = /\{\{\s*(\w+)\s*\}\}/;
  var formatString = (format || this.money_format);

  function addCommas(moneyString) {
    return moneyString.replace(/(\d+)(\d{3}[\.,]?)/,'$1,$2');
  }

  switch(formatString.match(patt)[1]) {
  case 'amount':
    value = addCommas(floatToString(cents, 2));
    break;
  case 'amount_no_decimals':
    value = addCommas(floatToString(cents, 0));
    break;
  case 'amount_with_comma_separator':
    value = floatToString(cents, 2).replace(/\./, ',');
    break;
  }
  return formatString.replace(patt, value);
};

ShopQi.resizeImage = function(image, size) {
  try {
    if(size == 'original') { return image; }
    else {      
      var matches = image.match(/(.*\/[\w\-\_\.]+)\.(\w{2,4})/);
      return matches[1] + '_' + size + '.' + matches[2];
    }    
  } catch (e) { return image; }
};

/* Ajax API */

// -------------------------------------------------------------------------------------
// POST to cart/add.js returns the JSON of the line item associated with the added item.
// -------------------------------------------------------------------------------------
ShopQi.addItem = function(variant_id, quantity, callback) {
  var quantity = quantity || 1;
  var params = {
    type: 'POST',
    url: '/cart/add.js',
    data: 'quantity=' + quantity + '&id=' + variant_id,
    dataType: 'json',
    success: function(line_item) { 
      if ((typeof callback) === 'function') {
        callback(line_item);
      }
      else {
        ShopQi.onItemAdded(line_item);
      }
    },
    error: function(XMLHttpRequest, textStatus) {
      ShopQi.onError(XMLHttpRequest, textStatus);
    }
  };
  jQuery.ajax(params);
};

// ---------------------------------------------------------
// POST to cart/add.js returns the JSON of the line item.
// ---------------------------------------------------------
ShopQi.addItemFromForm = function(form_id, callback) {
    var params = {
      type: 'POST',
      url: '/cart/add.js',
      data: jQuery('#' + form_id).serialize(),
      dataType: 'json',
      success: function(line_item) { 
        if ((typeof callback) === 'function') {
          callback(line_item);
        }
        else {
          ShopQi.onItemAdded(line_item);
        }
      },
      error: function(XMLHttpRequest, textStatus) {
        ShopQi.onError(XMLHttpRequest, textStatus);
      }
    };
    jQuery.ajax(params);
};

// ---------------------------------------------------------
// GET cart.js returns the cart in JSON.
// ---------------------------------------------------------
ShopQi.getCart = function(callback) {
  jQuery.getJSON('/cart.js', function (cart, textStatus) {
    if ((typeof callback) === 'function') {
      callback(cart);
    }
    else {
      ShopQi.onCartUpdate(cart);
    }
  });
};

// ---------------------------------------------------------
// GET cart/shipping_rates.js returns the cart in JSON.
// ---------------------------------------------------------
ShopQi.getCartShippingRatesForDestination = function(shipping_address, callback) {
  var params = {
    type: 'GET',
    url: '/cart/shipping_rates.json',
    data: ShopQi.param({'shipping_address': shipping_address}),
    dataType: 'json',
    success: function(response) { 
      rates = response.shipping_rates
      if ((typeof callback) === 'function') {
        callback(rates, shipping_address);
      }
      else {
        ShopQi.onCartShippingRatesUpdate(rates, shipping_address);
      }
    },
    error: function(XMLHttpRequest, textStatus) {
      ShopQi.onError(XMLHttpRequest, textStatus);
    }
  }
  jQuery.ajax(params);
};

// ---------------------------------------------------------
// GET products/<product-handle>.js returns the product in JSON.
// ---------------------------------------------------------
ShopQi.getProduct = function(handle, callback) {
  jQuery.getJSON('/products/' + handle + '.js', function (product, textStatus) {
    if ((typeof callback) === 'function') {
      callback(product);
    }
    else {
      ShopQi.onProduct(product);
    }
  });
};

// ---------------------------------------------------------
// POST to cart/change.js returns the cart in JSON.
// ---------------------------------------------------------
ShopQi.changeItem = function(variant_id, quantity, callback) {
  var params = {
    type: 'POST',
    url: '/cart/change.js',
    data:  'quantity='+quantity+'&id='+variant_id,
    dataType: 'json',
    success: function(cart) { 
      if ((typeof callback) === 'function') {
        callback(cart);
      }
      else {
        ShopQi.onCartUpdate(cart);
      }
    },
    error: function(XMLHttpRequest, textStatus) {
      ShopQi.onError(XMLHttpRequest, textStatus);
    }
  };
  jQuery.ajax(params);
};

// ---------------------------------------------------------
// POST to cart/change.js returns the cart in JSON.
// ---------------------------------------------------------
ShopQi.removeItem = function(variant_id, callback) {
  var params = {
    type: 'POST',
    url: '/cart/change.js',
    data:  'quantity=0&id='+variant_id,
    dataType: 'json',
    success: function(cart) { 
      if ((typeof callback) === 'function') {
        callback(cart);
      }
      else {
        ShopQi.onCartUpdate(cart);
      }
    },
    error: function(XMLHttpRequest, textStatus) {
      ShopQi.onError(XMLHttpRequest, textStatus);
    }
  };
  jQuery.ajax(params);
};

// ---------------------------------------------------------
// POST to cart/clear.js returns the cart in JSON.
// It removes all the items in the cart, but does
// not clear the cart attributes nor the cart note.
// ---------------------------------------------------------
ShopQi.clear = function(callback) {
  var params = {
    type: 'POST',
    url: '/cart/clear.js',
    data:  '',
    dataType: 'json',
    success: function(cart) { 
      if ((typeof callback) === 'function') {
        callback(cart);
      }
      else {
        ShopQi.onCartUpdate(cart);
      }
    },
    error: function(XMLHttpRequest, textStatus) {
      ShopQi.onError(XMLHttpRequest, textStatus);
    }
  };
  jQuery.ajax(params);
};

// ---------------------------------------------------------
// POST to cart/update.js returns the cart in JSON.
// ---------------------------------------------------------
ShopQi.updateCartFromForm = function(form_id, callback) {
  var params = {
    type: 'POST',
    url: '/cart/update.js',
    data: jQuery('#' + form_id).serialize(),
    dataType: 'json',
    success: function(cart) {
      if ((typeof callback) === 'function') {
        callback(cart);
      }
      else {
        ShopQi.onCartUpdate(cart);
      }
    },
    error: function(XMLHttpRequest, textStatus) {
      ShopQi.onError(XMLHttpRequest, textStatus);
    }
  };
  jQuery.ajax(params);
};

// ---------------------------------------------------------
// POST to cart/update.js returns the cart in JSON.
// To clear a particular attribute, set its value to an empty string.
// Receives attributes as a hash or array. Look at comments below.
// ---------------------------------------------------------
ShopQi.updateCartAttributes = function(attributes, callback) {
  var data = '';
  // If attributes is an array of the form:
  // [ { key: 'my key', value: 'my value' }, ... ]
  if (jQuery.isArray(attributes)) {
    jQuery.each(attributes, function(indexInArray, valueOfElement) {
      var key = attributeToString(valueOfElement.key);
      if (key !== '') {
        data += 'attributes[' + key + ']=' + attributeToString(valueOfElement.value) + '&';
      }
    });
  }
  // If attributes is a hash of the form:
  // { 'my key' : 'my value', ... }
  else if ((typeof attributes === 'object') && attributes !== null) {
    jQuery.each(attributes, function(key, value) {
        data += 'attributes[' + attributeToString(key) + ']=' + attributeToString(value) + '&';
    });
  }
  var params = {
    type: 'POST',
    url: '/cart/update.js',
    data: data,
    dataType: 'json',
    success: function(cart) {
      if ((typeof callback) === 'function') {
        callback(cart);
      }
      else {
        ShopQi.onCartUpdate(cart);
      }
    },
    error: function(XMLHttpRequest, textStatus) {
      ShopQi.onError(XMLHttpRequest, textStatus);
    }
  };
  jQuery.ajax(params);
};

// ---------------------------------------------------------
// POST to cart/update.js returns the cart in JSON.
// ---------------------------------------------------------
ShopQi.updateCartNote = function(note, callback) {
  var params = {
    type: 'POST',
    url: '/cart/update.js',
    data: 'note=' + attributeToString(note),
    dataType: 'json',
    success: function(cart) {
      if ((typeof callback) === 'function') {
        callback(cart);
      }
      else {
        ShopQi.onCartUpdate(cart);
      }
    },
    error: function(XMLHttpRequest, textStatus) {
      ShopQi.onError(XMLHttpRequest, textStatus);
    }
  };
  jQuery.ajax(params);
};


ShopQi.param = jQuery.param;

/* Used by Tools */

function floatToString(numeric, decimals) {
  var amount = numeric.toFixed(decimals).toString();
  if(amount.match(/^\.\d+/)) {return "0"+amount; }
  else { return amount; }
}

/* Used by API */

function attributeToString(attribute) {
  if ((typeof attribute) !== 'string') {
    // Converts to a string.
    attribute += '';
    if (attribute === 'undefined') {
      attribute = '';
    }
  }
  // Removing leading and trailing whitespace.
  return jQuery.trim(attribute);
}
