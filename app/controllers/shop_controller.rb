# encoding: utf-8
class ShopController < ApplicationController

  expose(:shop) { Shop.where(permanent_domain: request.subdomain).first }

  def show
    path = File.join Rails.root, 'public', 'themes', shop.id.to_s
    theme = File.join path, 'layout', 'theme.liquid'
    html = Liquid::Template.parse(theme).render({
      #content_for_header: '',
      #linklist: shop.link_list
    })
    render text: html, layout: nil
  end

  private
  def theme
    File.join Rails.root, 'public', 'themes', shop.id.to_s, 'layout', 'theme.liquid'
  end

end
