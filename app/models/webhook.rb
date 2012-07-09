# encoding: utf-8
class Webhook < ActiveRecord::Base
  belongs_to :shop
  belongs_to :application, class_name: 'Doorkeeper::Application', foreign_key: 'application_id'
  attr_accessible :event, :callback_url
  validates_presence_of :event, :callback_url
  KeyValues::Webhook::Event.all.map(&:code).each do |code|
    scope code.sub('/', '_'), where(event: code) # shop.webhooks.orders_fulfilled
  end

  def event_name
    KeyValues::Webhook::Event.find_by_code(self.event).name
  end

  def as_json(options = nil)
    super(methods: [ :event_name ], only: [:id, :event, :callback_url])
  end
end
