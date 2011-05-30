# encoding: utf-8
class ShopController < ApplicationController

  expose(:shop) { Shop.where(permanent_domain: request.subdomain).first }

  def show
    template = 'index'
    collection_drop = CollectionDrop.new(shop)
    html = Liquid::Template.parse(File.read(shop.layout_theme)).render({
      'shop' => ShopDrop.new(shop), #shop将在filter中调用，不能使用symbol key
      'content_for_header' => '', # google analysis js, shopqi tracker
      'content_for_layout' => Liquid::Template.parse(File.read(shop.template_theme(template))).render('collections' => collection_drop),
      'powered_by_link' => '',
      'linklists' => LinkListDrop.new(shop),
      'pages' => PageDrop.new(shop),
      'collections' => collection_drop,
      'template' => template,
    })
    render text: html, layout: nil
  end

end
