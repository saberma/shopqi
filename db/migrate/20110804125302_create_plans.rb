# encoding: utf-8
#用途：用于存储该商店所有使用的方案
class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer         :plan_type_id          ,comment: '关联方案'
      t.date            :deadline              ,comment: '方案结束日期'
      t.boolean         :status                ,comment: '当前状态（是否是当前用户目前方案状态）', default: true
      t.references      :shop                  ,comment: '关联商店'

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
