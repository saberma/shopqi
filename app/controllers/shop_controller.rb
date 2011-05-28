# encoding: utf-8
class ShopController < ApplicationController

  expose(:shop) { Shop.where(permanent_domain: request.subdomain).first }

  def show
    html = Liquid::Template.parse(theme).render({
      shop: ShopDrop.new,
      content_for_header: '', # google analysis js, shopqi tracker
      content_for_layout: '',
      powered_by_link: '',
      linklist: LinkListDrop.new,
      collections: CollectionsDrop.new,
      template: :index,
    }, filter: [TagFilter, UrlFilter])
    render text: html, layout: nil
  end

  private
  def theme
    IO.read File.join Rails.root, 'public', 'themes', shop.id.to_s, 'layout', 'theme.liquid'
  end

end
