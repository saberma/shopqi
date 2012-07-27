#encoding: utf-8
require 'spec_helper'

describe Admin::CustomCollectionsController do
  include Devise::TestHelpers

  let(:user) { Factory(:user_admin) }

  let(:shop) { user.shop }

  let(:custom_collection) { shop.custom_collections.where(handle: 'frontpage').first }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:psp) { Factory :psp, shop: shop }

  before :each do
    custom_collection.products << iphone4
    sleep 1 # 让创建时间不一样
    custom_collection.products << psp
    custom_collection.save
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#update_order' do

    it 'should be success' do # issues#231
      expect do
        put :update_order, id: custom_collection.id, custom_collection: {products_order: 'created_at.asc'}, format: :js
        response.should be_success
        custom_collection.reload.products_order.should eql 'created_at.asc'
      end.not_to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    context 'by title' do # 按标题

      it 'should be asc' do
        put :update_order, id: custom_collection.id, custom_collection: {products_order: 'title.asc'}, format: :js
        response.should be_success
        assigns[:collection_products].map(&:product).map(&:title).should eql %w(iphone4 psp)
        custom_collection.reload.products_order.should eql 'title.asc'
      end

      it 'should be desc' do
        put :update_order, id: custom_collection.id, custom_collection: {products_order: 'title.desc'}, format: :js
        response.should be_success
        assigns[:collection_products].map(&:product).map(&:title).should eql %w(psp iphone4)
        custom_collection.reload.products_order.should eql 'title.desc'
      end

    end

    context 'by created_at' do # 按创建日期

      it 'should be asc' do
        put :update_order, id: custom_collection.id, custom_collection: {products_order: 'created_at.asc'}, format: :js
        response.should be_success
        assigns[:collection_products].map(&:product).map(&:title).should eql %w(iphone4 psp)
        custom_collection.reload.products_order.should eql 'created_at.asc'
      end

      it 'should be desc' do
        put :update_order, id: custom_collection.id, custom_collection: {products_order: 'created_at.desc'}, format: :js
        response.should be_success
        assigns[:collection_products].map(&:product).map(&:title).should eql %w(psp iphone4)
        custom_collection.reload.products_order.should eql 'created_at.desc'
      end

    end

    context 'by price' do # 按价格

      it 'should be asc' do
        put :update_order, id: custom_collection.id, custom_collection: {products_order: 'price.asc'}, format: :js
        response.should be_success
        assigns[:collection_products].map(&:product).map(&:title).should eql %w(psp iphone4)
        custom_collection.reload.products_order.should eql 'price.asc'
      end

      it 'should be desc' do
        put :update_order, id: custom_collection.id, custom_collection: {products_order: 'price.desc'}, format: :js
        response.should be_success
        assigns[:collection_products].map(&:product).map(&:title).should eql %w(iphone4 psp)
        custom_collection.reload.products_order.should eql 'price.desc'
      end

    end

    context 'by manual' do # 按手动

      it 'should be success' do
        put :update_order, id: custom_collection.id, custom_collection: {products_order: 'manual'}, format: :js
        response.should be_success
        assigns[:collection_products].map(&:product).map(&:title).should eql %w(iphone4 psp)
        custom_collection.reload.products_order.should eql 'manual'
      end

    end

  end

end
