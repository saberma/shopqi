# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :cart do |f|
  f.session_id { UUID.generate(:compact) }
end
