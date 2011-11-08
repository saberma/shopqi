require 'spec_helper'

describe Cart do

  let(:shop) do
    model = Factory(:user).shop
    model.update_attributes password_enabled: false
    model
  end

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  let(:cart) { Factory :cart, shop: shop, cart_hash: %Q({"#{variant.id}":1}) }

  context '#destroy' do

    it 'should clear session cart' do
      Resque.redis.hset Cart.key(shop, cart.session_id), variant.id, 1
      cart.destroy
      Resque.redis.exists(Cart.key(shop, cart.session_id)).should be_false
    end

  end

end
