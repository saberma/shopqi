# encoding: utf-8
require 'spec_helper'

describe TagFilter do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:link_list) { Factory :link_list, shop: shop }

  it 'should get stylesheet_tag' do
    variant = "{{ 'textile.css' | stylesheet_tag }}"
    Liquid::Template.parse(variant).render.should eql "<link href='textile.css' rel='stylesheet' type='text/css' media='all' />"
  end

  it 'should get script_tag' do
    variant = "{{ 'jquery.js' | script_tag }}"
    Liquid::Template.parse(variant).render.should eql "<script src='jquery.js' type='text/javascript'></script>"
  end

  it 'should get img_tag' do
    variant = "{{ 'avatar.jpg' | img_tag }}"
    Liquid::Template.parse(variant).render.should eql "<img src='avatar.jpg' alt='' />"
  end

  it 'should get link_to' do
    link = LinkDrop.new link_list.links.build title: '查询', link_type: 'search', url: '/search'
    variant = "{{ link.title | escape | link_to: link.url }}"
    Liquid::Template.parse(variant).render('link' => link).should eql "<a href='/search'>查询</a>"
  end

  it "should get type url" do
    variant = "{{ product.type | link_to_type}}"
    result = "<a title=#{iphone4.product_type} href='/collections/types?q=#{iphone4.product_type}'>#{iphone4.product_type}</a>"
    Liquid::Template.parse(variant).render('product' => ProductDrop.new(iphone4)).should eql result
  end

  it "should get vendor url" do
    variant = "{{ vendor | link_to_vendor}}"
    result = "<a title=Cola href='/collections/vendors?q=Cola'>Cola</a>"
    Liquid::Template.parse(variant).render('vendor' => 'Cola').should eql result
  end

  it "should get vendor url" do
    variant = "{{ vendor | link_to_vendor}}"
    result = "<a title=Cola href='/collections/vendors?q=Cola'>Cola</a>"
    Liquid::Template.parse(variant).render('vendor' => 'Cola').should eql result
  end

  it "should get errors" do
    variant = "{{ errors | default_errors}}"
    errors = { email: '不能为空' }
    result = '<div class="errors"><ul><li> email不能为空 </li></ul></div>'
    Liquid::Template.parse(variant).render('errors' => errors).should eql result
  end

  describe CustomerDrop do

    it "should get customer_login_link" do
      variant = '{{ "登录" | customer_login_link }}'
      result = "<a href='/account/login' id='customer_login_link'>登录</a>"
      Liquid::Template.parse(variant).render().should eql result
    end

    it "should get customer_regist_link" do
      variant = '{{ "注册" | customer_regist_link }}'
      result = "<a href='/account/sign_up' id='customer_regist_link'>注册</a>"
      Liquid::Template.parse(variant).render().should eql result
    end

    it "should get customer_logout_link" do
      variant = '{{ "退出" | customer_logout_link }}'
      result = "<a href='/account/logout' id='customer_logout_link'>退出</a>"
      Liquid::Template.parse(variant).render().should eql result
    end

  end

end
