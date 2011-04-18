/* DO NOT MODIFY. This file was compiled Mon, 18 Apr 2011 15:10:04 GMT from
 * /vagrant/app/coffeescripts/models/link_list.coffee
 */

var LinkList;
LinkList = Backbone.Model.extend({
  name: 'link_list',
  url: function() {
    var base, _ref;
    base = 'link_lists';
    if (this.isNew()) {
      return base;
    }
    return base + ((_ref = base.charAt(base.length - 1) === '/') != null ? _ref : {
      '': '/'
    }) + this.id;
  }
});