/* DO NOT MODIFY. This file was compiled Tue, 19 Apr 2011 13:11:31 GMT from
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
    model = new LinkList({
      id: id
    });
    return model.fetch({
      success: function(model, resp) {
        return new App.Views.LinkList.Edit({
          model: model
        });
      }
    });
  },
  index: function() {
    var link_lists;
    link_lists = new App.Collections.LinkLists;
    return link_lists.fetch({
      success: function() {
        return new App.Views.LinkList.Index({
          collection: link_lists
        });
      }
    });
  },
  newOne: function() {
    return new App.Views.LinkList.New;
  }
});