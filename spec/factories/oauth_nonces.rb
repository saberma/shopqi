#encoding utf-8
Factory.define :nonce do |f|
end

Factory.define :nonce_one, parent: :nonce do |f|
  f.nonce 'a_nonce'
  f.timestamp 1
end

Factory.define :nonce_two, parent: :nonce do |f|
  f.nonce 'b_nonce'
  f.timestamp 2
end
