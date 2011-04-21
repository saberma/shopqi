/* DO NOT MODIFY. This file was compiled Thu, 21 Apr 2011 03:39:21 GMT from
 * /vagrant/app/coffeescripts/views/links/show.coffee
 */

App.Views.Link.Show = Backbone.View.extend({
  tagName: 'li',
  className: 'sl link',
  initialize: function() {
    var link_list_container_id;
    link_list_container_id = "#default_container_link_list_" + this.model.attributes.link_list_id;
    $('.padding', link_list_container_id).hide();
    $('.sr', link_list_container_id).show();
    _.bindAll(this, 'render');
    $(this.el).attr('id', "link_default_li_" + this.model.id);
    this.render();
    return $('.nobull', link_list_container_id).append(this.el);
  },
  render: function() {
    return $(this.el).html($('#show-link-menu').tmpl(this.model.attributes));
  }
});