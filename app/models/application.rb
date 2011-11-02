class Application < ActiveRecord::Base
  belongs_to :shop

  def client
    OAuth2::Model::Client.find_by_client_id(self.client_id)
  end
end
