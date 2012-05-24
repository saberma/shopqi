class Page < ActiveRecord::Base
  include Models::Handle
  belongs_to :shop
  attr_accessible :title, :published, :handle, :body_html

  validates_presence_of :title

  searchable do
    integer :shop_id, references: Shop
    text :title, :body_html
  end

  before_save do
    self.make_valid(shop.pages)
  end

end
