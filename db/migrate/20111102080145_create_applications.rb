class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications, force: true do |t|  #各网店关联的应用
      t.references :shop
      t.string     :name
      t.string     :client_id    , limit: 40
      t.string     :client_secret, limit: 40

      t.timestamps
    end
  end
end
