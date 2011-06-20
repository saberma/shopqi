#encoding: utf-8
require 'spec_helper'

describe Order do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop, product_type: '智能手机', vendor: '苹果' }

  let(:variant) { iphone4.variants.first }

  let(:order) do
    o = Factory.build(:order, shop: shop)
    o.line_items.build product_variant: variant, price: 10, quantity: 2
    o.save
    o
  end

  describe OrderTransaction do

    let(:transaction) { order.transactions.create kind: :capture }

    it 'should be add' do
      expect do
        transaction
      end.should change(OrderTransaction, :count).by(1)
    end

    it 'should save history' do
      order
      expect do
        transaction
      end.should change(OrderHistory, :count).by(1)
    end

  end

  describe OrderFulfillment do

    let(:line_item) { order.line_items.first }

    let(:fulfillment) do
      record = order.fulfillments.build
      record.line_items << line_item
      record.save
    end

    it 'should be add' do
      expect do
        fulfillment
        line_item.reload.fulfilled.should be_true
      end.should change(OrderFulfillment, :count).by(1)
    end

    it 'should save history' do
      order
      expect do
        fulfillment
        order.histories.first.url.should_not be_blank
      end.should change(OrderHistory, :count).by(1)
    end

  end

  describe 'validate' do

    let(:order) { shop.orders.build }

    it 'should validate email' do
      order.valid?.should be_false
      order.errors[:email].should_not be_nil
      order.errors[:billing_address].should_not be_nil
    end

    it 'should validate billing_address' do
      order.update_attributes email: 'mahb45@gmail.com', billing_address_attributes: { name: '' }
      order.errors['billing_address.name'].should_not be_empty
    end

  end

  describe 'create' do

    it 'should save address' do
      expect do
        expect do
          expect do
            order
          end.should change(Order, :count).by(1)
        end.should change(OrderBillingAddress, :count).by(1)
      end.should change(OrderShippingAddress, :count).by(1)
    end

    it 'should save name' do
      order.number.should eql 1
      order.order_number.should eql 1001
      order.name.should eql '#1001'
    end

    it 'should save history' do
      expect do
        order
      end.should change(OrderHistory, :count).by(1)
    end

  end

  describe 'update' do

    it 'should validate gateway' do
      order.save
      order.errors[:gateway].should_not be_nil
    end

  end

end
