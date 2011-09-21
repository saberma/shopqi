require 'spec_helper'

describe ThemeExporter do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  it 'should be export' do
    Grit.debug = true
    with_resque do
      Resque.enqueue(ThemeExporter, shop.id, theme.id)
    end
    File.exist?("tmp/theme_exporter/test/#{shop.domains.myshopqi.subdomain}").should be_true
    FileUtils.rm_rf("tmp/theme_exporter/test")
  end

end
