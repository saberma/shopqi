/* DO NOT MODIFY. This file was compiled Tue, 19 Apr 2011 15:04:02 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/show.coffee
 */

App.Views.LinkList.Show = Backbone.View.extend({
  tagName: 'li',
  className: 'links toolbox default-menu link-list',
  initialize: function() {
    return this.render();
  },
  render: function() {
    $(this.el).attr('id', "link_lists/" + this.model.id);
    $(this.el).html($('#show-menu').tmpl(this.model.attributes));
    return $('#menus').append(this.el);
  }
});