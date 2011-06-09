require 'spec_helper'

describe Order do

  let(:shop) { Factory(:user).shop }

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

    let(:order) { Factory :order, shop: shop }

    it 'should save address' do
      expect do
        expect do
          expect do
            order
          end.should change(Order, :count).by(1)
        end.should change(OrderBillingAddress, :count).by(1)
      end.should change(OrderShippingAddress, :count).by(1)
    end

    it 'should save address' do
    end

  end

  describe 'update' do

    let(:order) { Factory :order, shop: shop }

    it 'should validate gateway' do
      order.save
      order.errors[:gateway].should_not be_nil
    end

  end

end
