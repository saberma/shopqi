#encoding: utf-8
class ThemesController < ApplicationController
  prepend_before_filter :authenticate_user!, except: [:switch]
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:themes) { shop.themes }
  expose(:theme)
  expose(:settings_html) { theme.settings.transform }
  expose(:settings_json) { theme.settings.as_json.to_json }

  begin 'api'
    def switch
      authorization = OAuth2::Provider.access_token(nil, [], request)
      if authorization.valid?
        shop = authorization.owner
        theme = Theme.find_by_handle params[:handle]
        shop.theme.switch theme, params[:style_handle]
      end
      render nothing: true
    end
  end

  begin 'admin' # 后台管理

    def index # 主题管理
      themes = shop.themes
      published_themes = themes.select {|theme| theme.published? }
      unpublished_themes = themes.select {|theme| !theme.published? }
      @published_themes_json = published_themes.to_json(methods: :name, except: [:created_at, :updated_at])
      @unpublished_themes_json = unpublished_themes.to_json(methods: :name, except: [:created_at, :updated_at])
    end

    def settings # 主题配置
    end

    def update # 更新主题配置
      preset = params[:save_preset][:existing]
      preset = params[:save_preset][:new] if preset.blank?
      preset = params[:load_preset] if preset.blank?
      theme.settings.save preset, params[:settings]
      render json: params[:settings]
    end

    def delete_preset # 删除预设
      theme.settings.destroy_preset params[:name]
      render nothing: true
    end

  end

end
