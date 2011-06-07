require 'spec_helper'

describe Order do

  let(:shop) { Factory(:user).shop }

  let(:order) { shop.orders.build }

  describe 'validate' do

    it 'should validate email' do
      order.valid?.should be_false
      ap order.errors
      order.errors[:email].should_not be_nil
      order.errors[:billing_address].should_not be_nil
    end

    it 'should validate billing_address' do
      order.update_attributes email: 'mahb45@gmail.com', billing_address_attributes: { name: '' }
      order.errors['billing_address.name'].should_not be_empty
    end

    it 'should validate gateway' do
      order.next_step
      order.errors[:gateway].should_not be_nil
    end

  end

end
