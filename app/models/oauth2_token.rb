class Oauth2Token < AccessToken
  attr_accessor :user

  before_validation do # 特殊处理:oauth-plugin关联了用户
    self.shop = self.user.shop
  end

  def as_json(options={})
    {:access_token=>token}
  end
end
