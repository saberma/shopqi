# encoding: utf-8
class Webhook < ActiveRecord::Base
  belongs_to :shop
  attr_accessible :event, :callback_url
  validates_presence_of :event, :callback_url

  def event_name
    KeyValues::Webhook::Event.find_by_code(self.event).name
  end

  def as_json(options = nil)
    super(methods: [ :event_name ], only: [:id, :event, :callback_url])
  end
end
