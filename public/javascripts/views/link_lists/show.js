/* DO NOT MODIFY. This file was compiled Thu, 21 Apr 2011 08:25:46 GMT from
 * /vagrant/app/coffeescripts/views/link_lists/show.coffee
 */

App.Views.LinkList.Show = Backbone.View.extend({
  tagName: 'li',
  className: 'links toolbox default-menu link-list',
  initialize: function() {
    _.bindAll(this, 'render');
    this.model.bind('change', this.render);
    $(this.el).attr('id', "link_lists/" + this.model.id);
    $('#menus').append(this.el);
    return this.render();
  },
  events: {
    "click .destroy": "destroy"
  },
  render: function() {
    $(this.el).html($('#show-menu').tmpl(this.model.attributes));
    return _.each(this.model.attributes.links, function(link) {
      var model;
      model = new Link(link);
      return new App.Views.Link.Show({
        model: model
      });
    });
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