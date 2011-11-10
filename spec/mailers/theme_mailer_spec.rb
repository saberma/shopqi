require "spec_helper"

describe ThemeMailer do

  let(:user_admin) { Factory(:user_admin) }
  let(:theme) { Factory :theme_woodland_dark }
  let(:shop) do
      model = user_admin.shop
      model.update_attributes password_enabled: false
      model.themes.install theme
      model
    end

  it 'should be export' do
    with_resque do
      Resque.enqueue(ThemeExporter, shop.id, theme.id)
      ActionMailer::Base.deliveries.empty?.should be_false
    end
  end

end
