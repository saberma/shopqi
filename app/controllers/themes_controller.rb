#encoding: utf-8
class ThemesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
end
