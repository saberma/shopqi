/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 05:15:22 GMT from
 * /vagrant/app/coffeescripts/collections/link_lists.coffee
 */

App.Collections.LinkLists = Backbone.Collection.extend({
  model: LinkList,
  url: '/admin/link_lists',
  initialize: function() {
    _.bindAll(this, 'addOne');
    return this.bind('add', this.addOne);
  },
  addOne: function(model, collection) {
    $('#add-menu').hide();
    $('#link_list_title').val('');
    new App.Views.LinkList.Show({
      model: model
    });
    return Backbone.history.saveLocation("link_lists/" + model.id);
  }
});