/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 04:36:57 GMT from
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