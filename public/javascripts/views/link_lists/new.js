/* DO NOT MODIFY. This file was compiled Tue, 19 Apr 2011 03:03:48 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/new.coffee
 */

App.Views.LinkList.New = Backbone.View.extend({
  el: '#add-menu',
  events: {
    "submit form": "save",
    "click .cancel": "cancel"
  },
  initialize: function() {
    this.model = new LinkList;
    $(this.el).show();
    return $('#link_list_title').focus();
  },
  save: function() {
    var self;
    self = this;
    this.model.save({
      title: this.$('#link_list_title').val()
    }, {
      success: function(model, resp) {
        $(self.el).hide();
        $('#link_list_title').val('');
        new App.Views.LinkList.Show({
          model: model
        });
        return Backbone.history.saveLocation("link_lists/" + model.id);
      },
      error: function() {
        return new App.Views.Error();
      }
    });
    return false;
  },
  cancel: function() {
    return $(this.el).hide();
  }
});