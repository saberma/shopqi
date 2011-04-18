/* DO NOT MODIFY. This file was compiled Mon, 18 Apr 2011 14:06:16 GMT from
 * /home/saberma/Documents/shopqi/app/coffeescripts/collections/link_lists.coffee
 */

App.Collections.LinkLists = Backbone.Collection.extend(function() {
  return {
    model: LinkList,
    url: '/link_lists',
    index: function() {
      var link_lists;
      link_lists = new App.Collections.LinkLists();
      return link_lists.fetch({
        success: function() {
          return new App.Views.Index({
            collection: link_lists
          });
        }
      });
    }
  };
});