/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 02:45:12 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/edit.coffee
 */

App.Views.LinkList.Edit = Backbone.View.extend({
  events: {
    "submit form": "save",
    "click .cancel": "cancel"
  },
  initialize: function() {
    return this.render();
  },
  save: function() {
    var self;
    self = this;
    this.model.save({
      title: this.$("input[name='link_list[title]']").val()
    }, {
      success: function(model, resp) {
        $(self.el).hide();
        return Backbone.history.saveLocation("link_lists/" + model.id);
      },
      error: function() {
        return new App.Views.Error;
      }
    });
    return false;
  },
  render: function() {
    $(this.el).html($('#edit-menu').tmpl(this.model.attributes));
    return $(this.el).show();
  },
  cancel: function() {
    return $(this.el).hide();
  }
});