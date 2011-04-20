/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 13:25:08 GMT from
 * /vagrant/app/coffeescripts/views/links/new.coffee
 */

App.Views.Link.New = Backbone.View.extend({
  events: {
    "submit form": "save",
    "click .cancel": "cancel"
  },
  initialize: function() {
    $("#add_link_control_link_list_" + this.options.link_id).hide();
    return $(this.el).show();
  },
  save: function() {
    return false;
  },
  cancel: function() {
    $(this.el).hide();
    return $("#add_link_control_link_list_" + this.options.link_id).show();
  }
});