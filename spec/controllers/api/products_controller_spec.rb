require 'spec_helper'
require 'shared_stuff'

describe Api::ProductsController do
  let(:user) { Factory(:user) }
  let(:shop) { user.shop }
  it_should_behave_like 'api_examples_index'
end
