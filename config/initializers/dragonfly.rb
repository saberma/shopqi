require 'dragonfly'

app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)
app.server.url_format  = '/media/:job.:format'
app.define_macro(ActiveRecord::Base, :image_accessor)

app.datastore = Dragonfly::DataStorage::FileDataStore.new
app.datastore.configure do |d|
  d.root_path = File.join Rails.root, 'data', 'shops', test_dir   # defaults to public/system/dragonfly
  d.server_root = nil      # filesystem root for serving from - default to nil
  d.store_meta = false     # default to true - can be switched off to avoid
                           # saving an extra .meta file if meta not needed
end
