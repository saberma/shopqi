# encoding: utf-8
class CustomCollectionsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:custom_collections) { current_user.shop.custom_collections }
  expose(:custom_collection)
  expose(:candidate_products) { current_user.shop.products }
  expose(:products) { custom_collection.products }
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

  #商品加入集合
  def add_product
    flash.now[:notice] = I18n.t("flash.actions.update.notice")
    custom_collection.products.create product_id: params[:product_id], position: 0
    render :template => "shared/msg"
  end

  #商品移除集合
  def remove_product
    flash.now[:notice] = I18n.t("flash.actions.update.notice")
    custom_collection.products.where(product_id: params[:product_id]).first.(&:destroy)
    render :template => "shared/msg"
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
    flash.now[:notice] = '重新排序成功!'
  end

  #获取商品列表
  def available_products
    list = candidate_products
    list = list.where(:title.matches => "%#{params[:q]}%") unless params[:q].blank?
    render json: list.to_json(except: [ :created_at, :updated_at ])
  end

  #手动调整排序
  def sort
    custom_collection.update_attribute :products_order, :manual
    params[:product].each_with_index do |id, index|
      current_user.shop.custom_collections.find(params[:id]).products.find(id).update_attribute :position, index
    end
    render :nothing => true
  end

end
