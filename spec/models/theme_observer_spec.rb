require 'spec_helper'

describe ThemeObserver do

  let(:shop) { Factory(:user).shop }

  let(:path) { path = File.join Rails.root, 'public', 'themes', shop.id.to_s }

  let(:theme) { File.join path, 'layout', 'theme.liquid' }

  it 'should be create' do
    File.exist?(path).should be_true
    File.exist?(theme).should be_true
  end

  it 'should be delete' do
    shop.destroy
    File.exist?(path).should be_false
    File.exist?(theme).should be_false
  end

end
