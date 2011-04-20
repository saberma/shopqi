/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 03:53:27 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/show.coffee
 */

App.Views.LinkList.Show = Backbone.View.extend({
  tagName: 'li',
  className: 'links toolbox default-menu link-list',
  initialize: function() {
    _.bindAll(this, 'render');
    this.model.bind('change', this.render);
    $(this.el).attr('id', "link_lists/" + this.model.id);
    this.render();
    return $('#menus').append(this.el);
  },
  render: function() {
    return $(this.el).html($('#show-menu').tmpl(this.model.attributes));
  }
});