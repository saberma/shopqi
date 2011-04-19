/* DO NOT MODIFY. This file was compiled Tue, 19 Apr 2011 13:09:39 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/index.coffee
 */

App.Views.LinkList.Index = Backbone.View.extend({
  initialize: function() {
    return this.render();
  },
  render: function() {
    return _(this.collection.models).each(function(model) {
      return new App.Views.LinkList.Show({
        model: model
      });
    });
  }
});