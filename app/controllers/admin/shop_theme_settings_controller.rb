# 主题配置
class ShopThemeSettingsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:themes) { shop.themes }
  expose(:theme)
  expose(:settings_html) { theme.settings.transform }
  expose(:settings_json) { theme.settings.as_json.to_json }

  def show
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
