/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 09:02:06 GMT from
 * /vagrant/app/coffeescripts/controllers/link_lists.coffee
 */

App.Controllers.LinkLists = Backbone.Controller.extend({
  initialize: function() {
    return this.index();
  },
  routes: {
    "link_lists/:id/edit": "edit",
    "new": "newOne"
  },
  edit: function(id) {
    var model;
    model = App.link_lists.get(id);
    if (model) {
      return new App.Views.LinkList.Edit({
        model: model,
        el: $("#edit_form_link_container_link_list_" + model.id)
      });
    }
  },
  index: function() {
    return new App.Views.LinkList.Index({
      collection: App.link_lists
    });
  },
  newOne: function() {
    return new App.Views.LinkList.New;
  }
});