/* DO NOT MODIFY. This file was compiled Tue, 19 Apr 2011 13:10:46 GMT from
 * /vagrant/app/coffeescripts/application.coffee
 */

var App;
App = {
  Views: {
    LinkList: {}
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