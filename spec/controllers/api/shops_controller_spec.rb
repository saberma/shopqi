#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe Api::ShopsController do
  let(:user) { Factory(:user) }
  let(:shop) { user.shop }
  it_should_behave_like 'api_examples_index'
end
