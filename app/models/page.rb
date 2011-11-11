class Page < ActiveRecord::Base
  belongs_to :shop

  validates_presence_of :title

  searchable do
    integer :shop_id, references: Shop
    text :title, :body_html
  end

  before_save do
    Handle.make_valid(shop.pages, self)
  end

  def self.show(handle)
    self.where(handle: handle, published: true).first
  end

end
