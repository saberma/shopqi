/* DO NOT MODIFY. This file was compiled Thu, 21 Apr 2011 03:27:24 GMT from
 * /vagrant/app/coffeescripts/controllers/link_lists.coffee
 */

App.Controllers.LinkLists = Backbone.Controller.extend({
  initialize: function() {
    return this.index();
  },
  routes: {
    "link_lists/:id/edit": "edit",
    "new": "newOne",
    "link_lists/:id/links/new": "newLink"
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
  },
  newLink: function(id) {
    return new App.Views.Link.New({
      el: "#add_link_form_link_list_" + id,
      link_list_id: id
    });
  }
});