class Page < ActiveRecord::Base
  belongs_to :shop

  validates_presence_of :title

  searchable do
    integer :shop_id, references: Shop
    text :title, :body_html
  end

  before_save do
    self.handle = Pinyin.t(self.title, '-') if self.handle.blank?
  end
end
