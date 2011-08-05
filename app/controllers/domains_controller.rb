#encoding: utf-8
class DomainsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:domains) { shop.domains }
end
