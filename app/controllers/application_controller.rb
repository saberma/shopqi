# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_host_for_mailer

  protected
  def set_host_for_mailer #用于设置发送邮件时的host,放置这里，主要是devise的控制器继承这个控制器
    ActionMailer::Base.default_url_options[:host] = "#{request.host}#{request.port_string}"
  end
end
