class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    req.headers['Accept'].include?("application/vnd.shopqi.v#{@version}") || @default
  end
end
