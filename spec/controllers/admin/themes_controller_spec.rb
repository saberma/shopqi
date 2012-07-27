require 'spec_helper'

describe Admin::ThemesController do
  include Devise::TestHelpers

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:theme_slate) { Factory :theme_woodland_slate }

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  let(:theme) { shop.theme }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#update' do # 发布主题

    it 'should be update' do
      dark_theme = shop.themes.install theme_dark
      slate_theme = shop.themes.install theme_slate
      dark_theme.reload.role.should eql 'unpublished' # 原主题会置为[未发布]状态
      put :update, id: dark_theme.id, theme: { role: :main }
      dark_theme.reload.role.should eql 'main'
      slate_theme.reload.role.should eql 'unpublished'
    end

  end

  context '#duplicate' do # 复制主题

    before do
      shop.themes.install theme_dark # 原主题会置为[未发布]状态
    end

    it 'should be success' do
      expect do
        put :duplicate, id: theme.id
        JSON(response.body)['shop_theme']['role'].should eql 'unpublished'
      end.to change(ShopTheme, :count).by(1)
    end

    describe 'validate' do

      context 'shop storage is not idle' do # 商店容量已用完

        before { Rails.cache.write(shop.storage_cache_key, 101) }

        after { Rails.cache.delete(shop.storage_cache_key) }

        it 'should be fail' do
          put :duplicate, id: theme.id
          JSON(response.body)['storage_full'].should eql true
        end

      end

    end

  end

  context '#upload' do # 上传主题

    let(:zip_path) { Rails.root.join('spec', 'factories', 'data', 'themes') }

    describe 'support' do

      let(:path) { Rails.root.join 'tmp', 'themes', shop.id.to_s }

      let(:theme_path) { File.join path, "t9527-woodland.zip" }

      before(:each) do
        FileUtils.rm_rf path
        DateTime.stub!(:now).and_return(9527)
      end

      it 'addition root dir' do # 主题目录名称为test，压缩时可能会包含此目录，作为一级目录
        raw_attach_file File.join(zip_path, 'woodland-with-root.zip')
        post :upload, qqfile: 'woodland.zip'
        JSON(response.body)['missing'].should be_nil
      end

      it 'without addition root' do # layout,templates等目录直接作为压缩包文件的一级目录
        raw_attach_file File.join(zip_path, 'woodland-without-root.zip')
        post :upload, qqfile: 'woodland.zip'
        JSON(response.body)['missing'].should be_nil
      end

    end

    describe 'validate' do

      it 'should be valid zip' do
        raw_attach_file File.join(zip_path, 'invalid.file')
        post :upload, qqfile: 'invalid.file'
        JSON(response.body)['error_type'].should be_true
      end

      it 'should contain layout/theme.liquid' do
        raw_attach_file File.join(zip_path, 'woodland-missing-layout-theme.zip')
        post :upload, qqfile: 'woodland.zip'
        JSON(response.body)['missing'].should eql 'layout/theme.liquid'
      end

      it 'should contain templates/index.liquid' do
        raw_attach_file File.join(zip_path, 'woodland-missing-templates-index.zip')
        post :upload, qqfile: 'woodland.zip'
        JSON(response.body)['missing'].should eql 'templates/index.liquid'
      end

    end

    describe 'more than 8 themes' do # 不能超过8个主题

      it 'should be forbid' do
        8.times {|i| shop.themes.create name: "theme_#{i}" }
        raw_attach_file File.join(zip_path, 'woodland-missing-templates-index.zip')
        post :upload, qqfile: 'woodland.zip'
        JSON(response.body)['exceed'].should eql true
      end

    end

    context 'shop storage is not idle' do # 商店容量已用完

      before { Rails.cache.write(shop.storage_cache_key, 101) }

      after { Rails.cache.delete(shop.storage_cache_key) }

      it 'should be fail' do
        raw_attach_file File.join(zip_path, 'woodland-missing-templates-index.zip')
        post :upload, qqfile: 'woodland.zip'
        JSON(response.body)['storage_full'].should eql true
      end

    end

    describe 'ie' do # 支持ie浏览器上传

      it 'should be success' do
        post :upload, qqfile: Rack::Test::UploadedFile.new(File.join(zip_path, 'woodland.zip'))
        response.should be_success
        response.content_type.should eql 'text/html' # context_type不为'text/html'时，ie会将json作为文件下载
      end

    end

  end

end
