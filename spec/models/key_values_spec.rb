#encoding: utf-8
require 'spec_helper'

describe KeyValues do

  context '#find_by' do

    it 'should support symbol argument' do
      KeyValues::Order::FulfillmentStatus.find_by_code(:fulfilled).should_not be_nil
    end

  end

end
