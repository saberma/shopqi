# encoding: utf-8
class CustomCollectionsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:custom_collections) { current_user.shop.custom_collections }
  expose(:custom_collection)
  expose(:candidate_products) { current_user.shop.products }
  expose(:products) { custom_collection.products.ordered }
  expose(:smart_collections) { current_user.shop.smart_collections }

  expose(:publish_states) { KeyValues::PublishState.options }
  expose(:orders) { KeyValues::Collection::Order.options }

  def new
  end

  def create
    custom_collection.save
    redirect_to custom_collection_path(custom_collection)
  end

  def update
    custom_collection.save
    flash[:notice] = I18n.t("flash.actions.#{action_name}.notice")
    redirect_to custom_collection_path(custom_collection)
  end

  def destroy
    custom_collection.destroy
    redirect_to custom_collections_path
  end

  #更新可见性
  def update_published
    flash.now[:notice] = I18n.t("flash.actions.update.notice")
    custom_collection.save
    render :template => "shared/msg"
  end

  #更新排序
  def update_order
    custom_collection.save
    custom_collection.ordered_products.each_with_index do |product, index|
      product.update_attribute :position, index
    end
    flash.now[:notice] = '重新排序成功!'
  end

  #获取商品列表
  def available_products
    list = candidate_products
    list = list.where(:title.matches => "%#{params[:q]}%") unless params[:q].blank?
    render json: list.to_json(except: [ :created_at, :updated_at ])
  end

end
