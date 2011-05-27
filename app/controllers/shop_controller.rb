# encoding: utf-8
class ShopController < ApplicationController

  expose(:shop) { Shop.where(permanent_domain: request.subdomain).first }

  def show
    path = File.join Rails.root, 'public', 'themes', shop.id.to_s
    theme = File.join path, 'layout', 'theme.liquid'
    render text: Liquid::Template.parse('hi').render(), layout: nil
  end

end
