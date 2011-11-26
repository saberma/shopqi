class Permission < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user
  belongs_to_active_hash :resource      , class_name: 'KeyValues::Resource'
end
