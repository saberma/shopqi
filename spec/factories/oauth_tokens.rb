#encoding: utf-8
Factory.define :token do |f|
end

Factory.define :token_one, parent: :token do |f|
  f.user_id 1
  f.client_application_id 1
  f.token 'one'
  f.secret 'MyString'
end

Factory.define :token_two, parent: :token do |f|
  f.user_id 1
  f.client_application_id 1
  f.token 'two'
  f.secret 'MyString'
end
