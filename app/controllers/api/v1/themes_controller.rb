# encoding: utf-8
module Api::V1
  class ThemesController < AppController

    def install
      if shop.themes.exceed? # 超出主题数则不更新
        render json: {error: '商店的主题总数不能超过8个，请删除不再使用的主题!'} and return
      elsif !shop.storage_idle? # 超出商店容量
        render json: {error: I18n.t('activerecord.errors.models.shop.attributes.storage.full')} and return
      else
        theme = Theme.where(handle: params[:handle], style_handle: params[:style_handle]).first
        shop.themes.install theme
      end
      render json: {} # 安装成功
    end

  end
end
