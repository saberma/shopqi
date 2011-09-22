require "spec_helper"

describe ThemeMailer do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  it 'should be export' do
    with_resque do
      Resque.enqueue(ThemeExporter, shop.id, theme.id)
      ActionMailer::Base.deliveries.empty?.should be_false
    end
  end

end
