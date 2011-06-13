class Page < ActiveRecord::Base
  belongs_to :shop

  validates_presence_of :title

  define_index do
    has :shop_id
    indexes :title
    indexes :body_html
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
  end

  before_save do
    self.handle = Pinyin.t(self.title, '-') if self.handle.blank?
  end
end
