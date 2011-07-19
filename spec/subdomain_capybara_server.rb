# encoding: utf-8
# hack:支持subdomain #see: http://blog.jamesalmond.com/testing-subdomains-using-capybara
class Capybara::Server
  def self.manual_host=(value)
    @manual_host = value
  end

  def self.manual_host
    @manual_host ||= '127.0.0.1'
  end

  def url(path)
    if path =~ /^http/
      path
    else
      (Capybara.app_host || "http://#{Capybara::Server.manual_host}:#{port}") + path.to_s
    end
  end
end

