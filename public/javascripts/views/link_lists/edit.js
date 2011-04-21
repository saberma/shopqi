/* DO NOT MODIFY. This file was compiled Thu, 21 Apr 2011 08:02:33 GMT from
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
        msg('\u4FEE\u6539\u6210\u529F\u0021');
        $(self.el).hide();
        $("#default_container_link_list_" + model.id).show();
        $("#add_form_link_container_link_list_" + model.id).show();
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
    $(this.el).show();
    this.$("input[name='link_list[title]']").focus();
    $("#default_container_link_list_" + this.model.id).hide();
    return $("#add_form_link_container_link_list_" + this.model.id).hide();
  },
  cancel: function() {
    $(this.el).hide();
    $("#default_container_link_list_" + this.model.id).show();
    return $("#add_form_link_container_link_list_" + this.model.id).show();
  }
});