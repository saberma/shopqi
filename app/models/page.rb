class Page < ActiveRecord::Base
  belongs_to :shop

  validates_presence_of :title

  before_save do
    self.handle = Pinyin.t(self.title, '-') if self.handle.blank?
  end
end
