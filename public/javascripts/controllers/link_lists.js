/* DO NOT MODIFY. This file was compiled Mon, 18 Apr 2011 14:06:16 GMT from
 * /home/saberma/Documents/shopqi/app/coffeescripts/controllers/link_lists.coffee
 */

App.Controllers.LinkLists = Backbone.Controller.extend({
  routes: {
    "link_lists/:id": "edit",
    "": "index",
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
    return $.getJSON('/link_lists', function(data) {
      var link_lists;
      if (data) {
        link_lists = _(data).map(function(i) {
          return new LinkList(i);
        });
        return new App.Views.LinkList.Index({
          link_lists: link_lists
        });
      }
    });
  },
  newOne: function() {
    return new App.Views.LinkList.New({
      model: new LinkList()
    });
  }
});