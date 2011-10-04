ActiveAdmin.register Shop do
   index do
     column :id
     column :name
     column :deadline
     column :email
     column :phone
     column :guided
     column :theme
     column :password_enabled
     column :created_at
     default_actions
   end
end
