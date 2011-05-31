# encoding: utf-8
class Theme < ActiveRecord::Base
  belongs_to :shop
  has_many :settings, class_name: 'ThemeSetting', dependent: :destroy

  validates_presence_of :load_preset
end

class ThemeSetting < ActiveRecord::Base
  belongs_to :theme
end
