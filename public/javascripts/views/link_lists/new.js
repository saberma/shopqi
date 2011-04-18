/* DO NOT MODIFY. This file was compiled Mon, 18 Apr 2011 14:06:16 GMT from
 * /home/saberma/Documents/shopqi/app/coffeescripts/views/link_lists/new.coffee
 */

App.Views.LinkList.New = Backbone.View.extend({
  events: {
    "submit form": "save"
  },
  initialize: function() {
    return $('#add-menu').show();
  },
  save: function() {
    var self;
    self = this;
    return this.model.save({
      title: this.$('[name=title]').val()
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
  }
});