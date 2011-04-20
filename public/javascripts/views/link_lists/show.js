/* DO NOT MODIFY. This file was compiled Wed, 20 Apr 2011 12:04:32 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/show.coffee
 */

App.Views.LinkList.Show = Backbone.View.extend({
  tagName: 'li',
  className: 'links toolbox default-menu link-list',
  initialize: function() {
    _.bindAll(this, 'render');
    this.model.bind('change', this.render);
    $(this.el).attr('id', "link_lists/" + this.model.id);
    this.render();
    return $('#menus').append(this.el);
  },
  events: {
    "click .destroy": "destroy"
  },
  render: function() {
    return $(this.el).html($('#show-menu').tmpl(this.model.attributes));
  },
  destroy: function() {
    var self;
    if (confirm('\u60A8\u786E\u5B9A\u8981\u5220\u9664\u5417')) {
      self = this;
      this.model.destroy({
        success: function(model, response) {
          App.link_lists.remove(self.model);
          self.remove();
          return msg('\u5220\u9664\u6210\u529F\u0021');
        }
      });
    }
    return false;
  }
});