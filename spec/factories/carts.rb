# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :cart do |f|
  f.uuid { UUID.generate(:compact) }
  f.session_id { UUID.generate(:compact) }
end
