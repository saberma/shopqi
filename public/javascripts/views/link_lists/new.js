/* DO NOT MODIFY. This file was compiled Mon, 18 Apr 2011 15:05:30 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/new.coffee
 */

App.Views.LinkList.New = Backbone.View.extend({
  el: '#add-menu',
  events: {
    "submit form": "save",
    "click .cancel": "cancel"
  },
  initialize: function() {
    return $(this.el).show();
  },
  save: function() {
    var self;
    self = this;
    return this.model.save({
      title: this.$('#link_list_title').val()
    }, function() {
      ({
        success: function(model, resp) {
          self.model = model;
          new App.Views.LinkList.Show({
            model: model
          });
          return Backbone.history.saveLocation('link_lists/' + model.id);
        },
        error: function() {
          return new App.Views.Error();
        }
      });
      return false;
    });
  },
  cancel: function() {
    return $(this.el).hide();
  }
});