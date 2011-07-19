# encoding: utf-8

Factory.define :oauth2_client, class: OAuth2::Model::Client do |u|
  u.name 'themes'
  u.redirect_uri Theme.redirect_uri
end
