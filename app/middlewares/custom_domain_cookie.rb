# encoding: utf-8
# Custom Domain Cookie
# #
# # Set the cookie domain to the custom domain if it's present
class CustomDomainCookie
  def initialize(app)
    @app = app
  end

  def call(env)
    host = env["HTTP_HOST"].split(':').first
    env["rack.session.options"][:domain] = ".#{host}"
    @app.call(env)
  end
end
