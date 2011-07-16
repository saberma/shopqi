#encoding utf-8
Factory.define :client, class: ClientApplication do |f|
  f.name 'MyString'
  f.url 'http://test.com'
  f.support_url 'http://test.com/support'
  f.callback_url 'http://test.com/callback'
  f.key 'one_key'
  f.secret 'MyString'
end

Factory.define :client_one, parent: :client do |f|
  f.user_id 1
end

Factory.define :client_two, parent: :client do |f|
  f.user_id 2
end
