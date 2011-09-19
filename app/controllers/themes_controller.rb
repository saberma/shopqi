#encoding: utf-8
class ThemesController < ApplicationController
  prepend_before_filter :authenticate_user!, except: [:switch]
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:themes) { shop.themes }
  expose(:theme)

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

    def update # 发布主题
      shop.theme.unpublish!
      theme.save
      render nothing: true
    end

    def duplicate # 复制主题
      duplicate_theme = theme.duplicate
      render json: duplicate_theme.to_json(methods: :name, except: [:created_at, :updated_at])
    end

  end

end
