/* DO NOT MODIFY. This file was compiled Mon, 18 Apr 2011 14:08:21 GMT from
 * /vagrant/app/coffeescripts/application.coffee
 */

var App;
App = {
  Views: {
    LinkList: {}
  },
  Controllers: {},
  init: function() {
    new App.Controllers.LinkLists();
    return Backbone.history.start();
  }
};
$(document).ready(function() {
  return App.init();
});