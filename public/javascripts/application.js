/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 13:08:15 GMT from
 * /vagrant/app/coffeescripts/application.coffee
 */

var App;
App = {
  Views: {
    LinkList: {},
    Link: {}
  },
  Controllers: {},
  Collections: {},
  init: function() {
    new App.Controllers.LinkLists;
    return Backbone.history.start();
  }
};
$(document).ready(function() {
  return App.init();
});