require 'dragonfly'

app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)
app.server.url_format  = '/media/:job.:format'
app.define_macro(ActiveRecord::Base, :image_accessor)
