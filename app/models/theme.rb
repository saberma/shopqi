# encoding: utf-8
# 可选外观主题
class Theme < ActiveRecord::Base
  def self.default
    where(name: 'Prettify').first
  end
end
