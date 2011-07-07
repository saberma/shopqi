require 'spec_helper'

describe AssetsController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  let(:theme) { shop.theme }

  let(:path) { path = File.join Rails.root, 'public', 's', 'files', Rails.env, shop.id.to_s, 'theme'}

  before :each do
    sign_in(user)
  end

  it 'should be create' do
    post :create, key: 'layout/test.liquid', source_key: 'layout/theme.liquid'
    file_path = File.join path, 'layout/test.liquid'
    File.exist?(file_path).should be_true
  end

end
