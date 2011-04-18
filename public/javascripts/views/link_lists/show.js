/* DO NOT MODIFY. This file was compiled Mon, 18 Apr 2011 14:06:16 GMT from
 * /home/saberma/Documents/shopqi/app/coffeescripts/views/link_lists/show.coffee
 */

App.Views.LinkList.Show = Backbone.View.extend({
  initialize: function() {
    return this.render();
  },
  render: function() {
    $(this.el).html($('#show-menu').html());
    return $('#menus').append(this.el);
  }
});