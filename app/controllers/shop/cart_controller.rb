#encoding: utf-8
class Shop::CartController < Shop::ApplicationController
  layout nil

  expose(:shop) { Shop.at(request.subdomain) }
end
