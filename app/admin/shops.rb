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
end
