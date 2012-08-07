object @product
attributes :id, :title, :body_html, :handle, :product_type, :vendor, :created_at, :updated_at

child :variants => :variants do
  extends "api/v1/product_variants/show"
end
