#encoding: utf-8
class AddRecordToShopDomain < ActiveRecord::Migration

  def change
    add_column :shop_domains, :record  , :string , comment: '备案号'          , limit: 32
    add_column :shop_domains, :verified, :boolean, comment: '备案信息是否正确', default: true

    ShopDomain.reset_column_information
    ShopDomain.all.each do |domain|
      domain.update_attributes! record: Setting.domain.record, verified: true
    end
  end

end
