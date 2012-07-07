class CreateWebHooks < ActiveRecord::Migration
  def change
    create_table :web_hooks do |t|
      t.string :event       , null: false   , limit: 32
      t.string :callback_url, null: false   , limit: 255
      t.datetime :created_at, null: false
    end
  end
end
