/* DO NOT MODIFY. This file was compiled Thu, 21 Apr 2011 03:51:33 GMT from
 * /vagrant/app/coffeescripts/views/links/new.coffee
 */

App.Views.Link.New = Backbone.View.extend({
  events: {
    "submit form": "save",
    "click .cancel": "cancel"
  },
  initialize: function() {
    this.model = new Link({
      link_list_id: this.options.link_list_id
    });
    $("#add_link_control_link_list_" + this.options.link_list_id).hide();
    return $(this.el).show();
  },
  save: function() {
    var self;
    self = this;
    this.model.save({
      title: this.$("input[name='link[title]']").val(),
      link_type: this.$("input[name='link[link_type]']").val(),
      subject: this.$("input[name='link[subject]']").val()
    }, {
      success: function(model, response) {
        $("#add_link_control_link_list_" + model.attributes.link_list_id).show();
        $(self.el).hide();
        self.$("input[name='link[title]']").val('');
        self.$("input[name='link[subject]']").val('');
        new App.Views.Link.Show({
          model: model
        });
        return Backbone.history.saveLocation("link/" + model.id);
      }
    });
    return false;
  },
  cancel: function() {
    $(this.el).hide();
    return $("#add_link_control_link_list_" + this.options.link_list_id).show();
  }
});