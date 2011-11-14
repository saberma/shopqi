require 'spec_helper'

describe 'shop::shops' do

  it "routes /s/files/test/:id/theme/:theme_id/assets/:file.:format to shops#asset for file and format" do # issues#272
    { get: "/s/files/test/1/theme/1/assets/jquery.easing.1.3.js" }.should route_to(
      controller: "shop/shops",
      action: "asset",
      id: "1",
      theme_id: "1",
      file: "jquery.easing.1.3",
      format: "js"
    )
  end

  it "should routes no_shop action" do
    { get: "http://aa.lvh.me:4000"}.should route_to(
      controller: "shopqi/home",
      action: "no_shop"
    )

    { get: "http://aa.lvh.me:4000/aaaa"}.should route_to(
      controller: "shopqi/home",
      action: "no_shop",
      any: "aaaa"
    )

    { get: "http://lvh.me:4000/aaaa"}.should route_to(
      controller: "shopqi/home",
      action: "no_page",
      any: "aaaa"
    )
  end

end
