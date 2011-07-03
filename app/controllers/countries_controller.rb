class CountriesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
end
