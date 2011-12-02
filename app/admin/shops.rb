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
     column "商店恢复" do |shop|
       unless shop.access_enabled
         link_to "恢复商店",restore_active_admin_shop_path(shop),method: :put
       end
     end
     column :password_enabled
     column :created_at
     default_actions
   end

   member_action :restore, method: :put do
     shop = Shop.find(params[:id])
     shop.update_attribute(:access_enabled,true)
     Resque.remove_delayed(DeleteShop, shop.id)
     redirect_to active_admin_shop_path(shop), notice: '商店已恢复'
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
       asset_host = ActionController::Base.asset_host # 可能为Proc对象
       asset_host_for_shop = asset_host.respond_to?(:call) ? asset_host.call : asset_host
       @shop_global_js = "#{asset_host_for_shop}/s/global/jquery/1.5.2/jquery.js"
       @shop_shopqi_js = "#{asset_host_for_shop}/s/shopqi/option_selection.js"
       @shop = Shop.where(email: 'admin@shopqi.com', :id.lt => 10).order('id asc').first
       if @shop
         theme = @shop.themes.where(name: '乔木林地').first
         if theme
           @shop_shop_css = "#{asset_host_for_shop}#{theme.asset_url('stylesheet.css')}"
           @shop_shop_js = "#{asset_host_for_shop}#{theme.asset_url('fancybox.js')}"
         end
         @shop_product_photo = @shop.products.first.try(:index_photo)
       end
     end
     begin 'server' # 服务器
       begin
         @server_redis = Resque.redis.ping
       rescue => e
         puts "Redis Server Error:#{e}"
       end
       begin
         id = @shop.id
         @server_sunspot = Sunspot.search(Page) do
           keywords '关于'
           with :shop_id, id
         end.results
       rescue => e
         puts "Sunspot Server Error:#{e}"
       end
       begin
         keywords = 'héllo'
         url = "#{Sunspot.config.solr.url}/select?q=#{URI.escape(keywords)}&params=explicit&wt=json"
         response_keywords = JSON(HTTParty.get(url).body)['responseHeader']['params']['q']
         @server_solr_get = (keywords == response_keywords)
         response_keywords = JSON(HTTParty.post(url).body)['responseHeader']['params']['q']
         @server_solr_post = (keywords == response_keywords)
       rescue => e
         puts "Solr Server UTF-8 Error:#{e}"
       end
     end
   end
end
