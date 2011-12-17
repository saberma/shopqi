#encoding: utf-8
class Translation < ActiveRecord::Base
  def self.get_value(key)
    value = Translation.find_by_key(key).try(:value)
    value = value.blank? ? key : value
  end

  def self.update_or_create(key,value)
    translation = self.where(key: key).first
    translation = if translation
      translation.update_attribute :value,value
    else
      self.create(key: key, value: value)
    end
  end
end
