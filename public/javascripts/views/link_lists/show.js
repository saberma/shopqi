/* DO NOT MODIFY. This file was compiled Tue, 19 Apr 2011 02:18:14 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/show.coffee
 */

App.Views.LinkList.Show = Backbone.View.extend({
  initialize: function() {
    return this.render();
  },
  render: function() {
    var compiled;
    compiled = _.template($('#show-menu').html());
    $(this.el).html(compiled(this.model.toJSON()));
    return $('#menus').append(this.el);
  }
});