# encoding: utf-8
class Shop < ActiveRecord::Base
  has_many :users             , dependent: :destroy
  has_many :products          , dependent: :destroy
  has_many :link_lists        , dependent: :destroy
  has_many :pages             , dependent: :destroy
  has_many :blogs             , dependent: :destroy
  has_many :smart_collections , dependent: :destroy
  has_many :custom_collections, dependent: :destroy
  has_many :tags              , dependent: :destroy
  has_one  :theme             , dependent: :destroy, class_name: 'ShopTheme'

  has_many :types             , dependent: :destroy, class_name: 'ShopProductType'
  has_many :vendors           , dependent: :destroy, class_name: 'ShopProductVendor'
  
  #二级域名须为3到20位数字和字母组成的，且唯一
  validates :permanent_domain, presence: true, uniqueness: true, format: {with:  /\A([a-z0-9])*\Z/ }, length: 3..20
  validates_presence_of :name
  
  before_create :init_valid_date

  # 域名
  def self.at(domain)
    Shop.where(permanent_domain: domain).first
  end
  
  protected
  def init_valid_date
    self.deadline = Date.today.next_day(10)
  end
  
  def available?
    !self.deadline.past?
  end
end

#商品类型
class ShopProductType < ActiveRecord::Base
  belongs_to :shop
end

#商品厂商
class ShopProductVendor < ActiveRecord::Base
  belongs_to :shop
end

#商店外观主题
class ShopTheme < ActiveRecord::Base
  belongs_to :shop
  belongs_to :theme
  has_many :settings, class_name: 'ShopThemeSetting', dependent: :destroy

  validates_presence_of :load_preset

  before_validation do
    self.load_preset = 'custom'
  end

  def app_path
    File.join Rails.root, 'app', 'themes', self.theme.name.downcase
  end

  def files_relative_path
    test = (Rails.env == 'test') ? 'test' : '' #测试目录与其他环境分开,不干扰
    File.join 's', 'files', test, self.id.to_s, 'theme'
  end

  def public_path
    File.join Rails.root, 'public', files_relative_path
  end

  def asset_relative_path(asset)
    File.join files_relative_path, 'assets', asset
  end

  def asset_path(asset)
    asset_liquid = "#{asset}.liquid"
    path = File.join public_path, 'assets', asset_liquid
    if File.exist?(path) #存在liquid文件，则解释liquid
      path
    else
      File.join public_path, 'assets', asset
    end
  end

  def layout_theme_path
    File.join public_path, 'layout', 'theme.liquid'
  end

  def template_path(template)
    File.join public_path, 'templates', "#{template}.liquid"
  end

  def config_settings_path
    File.join public_path, 'config', 'settings.html'
  end

  def config_settings
    doc = Nokogiri::HTML(File.read(config_settings_path))
    inputs = doc.css('input').map do |input|
      type = input[:type]
      value = case type
        when 'checkbox'
          input[:checked].blank? ? 'false' : 'true'
        when 'file'
          '' #暂时为空
        else
          input[:value]
        end
      [input[:name], value]
    end
    selects = doc.css('select').map do |select|
      value = select.at_css("option[selected]")[:value]
      [select[:name], value]
    end
    elements = (inputs + selects).flatten
    Hash[*elements]
  end
end

# 外观主题设置
class ShopThemeSetting < ActiveRecord::Base
  belongs_to :theme, class_name: 'ShopTheme'
end
