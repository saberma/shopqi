/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 04:48:42 GMT from
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
    App.link_lists.create({
      title: this.$("input[name='link_list[title]']").val()
    });
    return false;
  },
  cancel: function() {
    return $(this.el).hide();
  }
});