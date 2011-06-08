# encoding: utf-8
class Subdomain
  def self.matches?(request)
    excludes = %w(www checkout)
    request.subdomain.present? && !excludes.include?(request.subdomain)
  end
end
