/* DO NOT MODIFY. This file was compiled Tue, 19 Apr 2011 03:46:03 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/show.coffee
 */

App.Views.LinkList.Show = Backbone.View.extend({
  initialize: function() {
    return this.render();
  },
  render: function() {
    $(this.el).html($('#show-menu').tmpl(this.model.attributes));
    return $('#menus').append(this.el);
  }
});