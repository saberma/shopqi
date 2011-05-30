# encoding: utf-8
class ShopsController < ApplicationController
  layout 'admin', only: :edit

  expose(:shop) { Shop.where(permanent_domain: request.subdomain).first }

  def show
    template = 'index'
    collection_drop = CollectionsDrop.new(shop)
    html = Liquid::Template.parse(File.read(shop.layout_theme)).render({
      'shop' => ShopDrop.new(shop), #shop将在filter中调用，不能使用symbol key
      'content_for_header' => '', # google analysis js, shopqi tracker
      'content_for_layout' => Liquid::Template.parse(File.read(shop.template_theme(template))).render('collections' => collection_drop),
      'powered_by_link' => '',
      'linklists' => LinkListsDrop.new(shop),
      'pages' => PagesDrop.new(shop),
      'collections' => collection_drop,
      'template' => template,
    })
    render text: html, layout: nil
  end

  def update
    shop.update_attributes(params[:shop])
    flash[:notice] = I18n.t("flash.actions.#{action_name}.notice")
    redirect_to admin_general_preferences_path
  end

  private
  def theme
    IO.read File.join Rails.root, 'public', 'themes', shop.id.to_s, 'layout', 'theme.liquid'
  end

end
