require 'spec_helper'

describe Admin::AssetsController do
  include Devise::TestHelpers

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:user) { Factory(:user) }

  let(:shop) do
    model = user.shop
    model.themes.install theme_dark
    model
  end

  let(:theme) { shop.theme }

  let(:path) { File.join Rails.root, 'data', 'shops', Rails.env, shop.id.to_s, 'themes', theme.id.to_s}

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  it 'should be create' do
    post :create, key: 'layout/test.liquid', source_key: 'layout/theme.liquid', theme_id: theme.id
    file_path = File.join path, 'layout/test.liquid'
    File.exist?(file_path).should be_true
  end

  context '#upload' do # 上传附件

    let(:file_path) { Rails.root.join('spec', 'factories', 'data', 'themes') }

    describe 'ie', focus: true do # 支持ie浏览器上传

      it 'should be success' do
        post :upload, key: 'assets/product.jpg', theme_id: theme.id, id: 0, qqfile: Rack::Test::UploadedFile.new(File.join(file_path, 'product.jpg'))
        response.should be_success
        response.content_type.should eql 'text/html' # context_type不为'text/html'时，ie会将json作为文件下载
      end

    end

  end

end
