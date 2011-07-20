require 'spec_helper'

describe Theme do

  it 'should get default' do
    Theme.default.should_not be_nil
  end

  describe 'oauth2' do

    it 'should get redirect_uri' do
      Theme.redirect_uri.should eql 'http://themes.shopqi.com/callback'
    end

    it 'should get client_id' do
      Theme.client_id.should_not be_blank
    end

    it 'should get client_secret' do
      Theme.client_secret.should_not be_blank
    end

  end

end
