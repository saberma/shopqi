require 'spec_helper'

describe Asset do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  before :each do
    theme.switch Theme.find_by_name('Prettify')
  end

  it 'should be list' do
    list = Asset.all(theme)
    list.should_not be_empty
    ["assets", "config", "layout", "snippets", "templates"].each do |key|
      list.has_key?(key).should be_true
    end
  end

end
