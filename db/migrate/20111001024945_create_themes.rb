# encoding: utf-8
#用途：用于存储主题信息
class CreateThemes < ActiveRecord::Migration
  def up
    create_table :themes do |t|
      t.string :name        , comment: "名称"              , limit: 16
      t.string :handle      , comment: "名称handle"        , limit: 16
      t.string :style       , comment: "风格"              , limit: 16
      t.string :style_handle, comment: "风格handle"        , limit: 16
      t.string :role        , comment: "角色用途(main      , mobile    , unpublished, wait)", limit: 16
      t.float :price        , comment: "价格"              , default: 0
      t.string :color       , comment: "颜色"              , limit: 8
      t.string :desc        , comment: "描述"              , limit: 255
      t.string :shop        , comment: "demo网店的子域名"  , limit: 32
      t.string :site        , comment: "作者官网"          , limit: 64
      t.string :author      , comment: "作者"              , limit: 16
      t.string :email       , comment: "作者Email"         , limit: 32
      t.boolean :published  , comment: "是否启用"          , default: false
      t.string :file        , comment: "对应的压缩文件"    , limit: 64
      t.string :main        , comment: "截图(列表页面)"    , limit: 64
      t.string :collection  , comment: "集合截图(查看页面)", limit: 64
      t.string :product     , comment: "商品截图(查看页面)", limit: 64
    end
  end

  def down
    drop_table :themes
  end
end
