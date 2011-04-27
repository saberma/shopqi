class SmartCollection < ActiveRecord::Base
  belongs_to :shop

  before_create do
    self.handle = 'handle'
  end

end
