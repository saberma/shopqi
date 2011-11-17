#encoding: utf-8
ActiveAdmin.register Shop do

   index do
     column :id
     column :name
     column :deadline
     column :email
     column :phone
     column :guided
     column :theme
     column "商店地址" do |shop|
       link_to "访问","#{shop.primary_domain.url}#{request.port_string}",target:"_blank"
     end
     column :password_enabled
     column :created_at
     default_actions
   end

   collection_action :state do
     begin 'libxml2' # issues#274
       html_path = Rails.root.join "spec/factories/data/themes/settings_with_class.html"
       settings = Nokogiri::HTML(File.open(html_path), nil, 'utf-8').inner_html
       @libxml2 = !settings.blank?
     end
     begin 'git' # issues#274
       path = File.join '/', 'tmp', 'test_git'
       config = File.join path, 'config'
       readme = File.join config, 'README'
       repo = Grit::Repo.init path
       FileUtils.mkdir config
       FileUtils.touch readme
       Dir.chdir path do
         repo.add '.'
         repo.commit_all 'just for test'
       end
       @git = (repo.tree.trees.size > 0)
       FileUtils.rm_rf path
     end
     begin 'theme' # 主题商店
       @theme = Theme.first
     end
     begin 'shop' # 商店
       @shop_global_js = "#{ActionController::Base.asset_host}/s/global/jquery/1.5.2/jquery.js"
       @shop_shopqi_js = "#{ActionController::Base.asset_host}/s/shopqi/option_selection.js"
       @shop = Shop.where(email: 'admin@shopqi.com', :id.lt => 10).first
       theme = @shop.themes.where(name: '乔木林地').first
       @shop_shop_css = "#{ActionController::Base.asset_host}#{theme.asset_url('stylesheet.css')}"
       @shop_shop_js = "#{ActionController::Base.asset_host}#{theme.asset_url('fancybox.js')}"
       @shop_product_photo = @shop.products.first.index_photo
     end
   end
end
