#encoding: utf-8
class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.references :shop              , comment: '关联商店'

      t.timestamps
    end
  end
end
