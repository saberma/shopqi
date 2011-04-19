/* DO NOT MODIFY. This file was compiled Tue, 19 Apr 2011 09:31:22 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/index.coffee
 */

App.Views.LinkList.Index = Backbone.View.extend({
  initialize: function() {
    this.link_lists = this.options.link_lists;
    return this.render();
  },
  render: function() {
    return _(this.link_lists).each(function(model) {
      log(model);
      return new App.Views.LinkList.Show({
        model: model
      });
    });
  }
});