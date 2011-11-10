
/* customer address helper */
ShopQi.CustomerAddress = {
  toggleForm: function(id) {
    var editEl = document.getElementById('edit_address_'+id);
    var viewEl = document.getElementById('view_address_'+id);      
    editEl.style.display = editEl.style.display == 'none' ? '' : 'none';
    viewEl.style.display = viewEl.style.display == 'none' ? '' : 'none';
    return false;    
  },
  
  toggleNewForm: function() {
    var el = document.getElementById('add_address');
    el.style.display = el.style.display == 'none' ? '' : 'none';
    return false;
  },
  
  destroy: function(id, confirm_msg) {
    if (confirm(confirm_msg || "您确定要删除这个地址吗?")) {
      ShopQi.postLink('/account/addresses/'+id, {'parameters': {'_method': 'delete'}});
    }      
  }
}
