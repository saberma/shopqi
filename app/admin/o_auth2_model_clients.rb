#encoding: utf-8
ActiveAdmin.register Doorkeeper::Application do

  index do
    column :id
    column :name
    column :uid
    column :redirect_uri
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "新增client" do
      f.input :name
      f.input :redirect_uri
    end
    f.buttons
  end
end
