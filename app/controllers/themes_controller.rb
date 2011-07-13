#encoding: utf-8
class ThemesController < ApplicationController
  prepend_before_filter :authenticate_user!, except: :index
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:theme) { shop.theme }
  expose(:settings_html) { theme.settings.transform }
  expose(:settings_json) { theme.settings.as_json.to_json }

  def index
    render 'index', layout: nil
  end

  begin 'admin' # 后台管理

    def settings # 主题配置
    end

    def update # 更新主题配置
      preset = params[:theme][:save_preset][:existing]
      preset = params[:theme][:save_preset][:new] if preset.blank?
      preset = params[:theme][:load_preset] if preset.blank?
      theme.settings.save preset, params[:theme][:settings]
      render json: params[:theme][:settings]
    end

    def delete_preset # 删除预设
      theme.settings.destroy_preset params[:name]
      render nothing: true
    end

  end
end
