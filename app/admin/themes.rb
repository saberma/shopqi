ActiveAdmin.register Theme do

   index do
     column :id
     column :name
     column :style
     column :color
     column :price
   end

   collection_action :upload, method: :post do
     redirect_to action: :index, notice: "CSV imported successfully!"
   end

end
