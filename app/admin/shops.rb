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
     begin 'git'
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
     begin 'theme'
       @theme = Theme.first
     end
   end
end
