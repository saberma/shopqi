# encoding: utf-8
# 外观主题设置
class ShopThemeSetting < ActiveRecord::Base
  belongs_to :theme, class_name: 'ShopTheme'

  module Extension # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html #Association extensions
    def html_path  # public/s/files/1/theme/config/settings.html
      File.join theme.public_path, 'config', 'settings.html'
    end

    def data_path # public/s/files/1/theme/config/settings_data.json
      File.join theme.public_path, 'config', 'settings_data.json'
    end

    def as_json
      data = File.read(data_path)
      JSON data unless data.blank?
    end

    def save(preset, data)
      settings = self.as_json
      doc = Nokogiri::HTML(File.read(html_path))
      doc.css("input[type='checkbox']").each do |element| # 转化为boolean值
        name = element['name']
        data[name] = (data[name] == '1')
      end
      if preset.blank? # 定制的直接保存在current根节点
        settings['current'] = data.as_json
      else
        settings['current'] = preset
        #settings['presets'][preset] = data #NoMethodError (undefined method `merge' for #<JSON::Ext::Generator::State:)
        settings['presets'][preset] = data.as_json
      end
      Asset.update theme, 'config/settings_data.json', JSON.pretty_generate(settings)
    end

    def destroy_preset(preset)
      settings = self.as_json
      data = settings['presets'].delete preset
      settings['current'] = data
      Asset.update theme, 'config/settings_data.json', JSON.pretty_generate(settings)
    end

    def transform # settings.html的内容要先经过处理: 上传、字体、改名
      doc = Nokogiri::HTML(File.open(html_path)) #http://nokogiri.org/tutorials/modifying_an_html_xml_document.html
      doc.css("input[type='file']").each do |file| # 上传文件
        name = file['name']
        url = "/#{theme.files_relative_path}/assets/#{name}"
        td = file.parent
        builder = Nokogiri::HTML::Builder.new do
          table.widget(cellspacing: 0) {
            tr {
              td {
                div(name: name, class: :file) } } # 使用ajax后台上传
            tr {
              td {
                div.asset {
                  div(class: 'asset-image') {
                    a(class: 'closure-lightbox', href: url) {
                      img(src: '/images/admin/icons/mimes/png.gif') } }
                  span.note {
                    a(class: 'closure-lightbox', href: url) { text name } } } } } }
        end
        td.inner_html = builder.doc.inner_html
      end
      doc.css("input[type='checkbox']").each do |element| # 复选框加false值隐藏域
        hidden = Nokogiri::XML::Node.new 'input', doc
        hidden['name'] = element['name']
        hidden['type'] = 'hidden'
        hidden['value'] = '0'
        element.before hidden
      end
      doc.css("select.font").each do |element| # 字体
        builder = Nokogiri::HTML::Builder.new do
          div {
            optgroup(label: "Sans-serif") {
              option(value: "Helvetica, Arial, sans-serif") { text 'Helvetica/Arial' }
              option(value: "Impact, Charcoal, Helvetica, Arial, sans-serif") { text 'Impact' }
              option(value: "'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', Lucida, Helvetica, Arial, sans-serif") { text 'Lucida Grande' }
              option(value: "Trebuchet MS, sans-serif") { text 'Trebuchet MS'}
              option(value: "Verdana, Helvetica, Arial, sans-serif") { text 'Verdana' } }
            optgroup(label: "Serif") {
              option(value: "Garamond, Baskerville, Caslon, serif") { text 'Garamond' }
              option(value: "Georgia, Utopia, 'Times New Roman', Times, serif") { text 'Georgia' }
              option(value: "Palatino, 'Palatino Linotype', 'Book Antiqua', serif") { text 'GPalatino' }
              option(value: "'Times New Roman', Times, serif") { text 'Times New Roman' } }
            optgroup(label: "Monospace") {
              option(value: "'Courier New', Courier, monospace") { text 'Courier New' }
              option(value: "Monaco, 'Lucida Console', 'DejaVu Sans Mono', monospace") { text 'Monaco/Lucida Console' } } }
        end
        element.inner_html = builder.doc.at_css('div').inner_html
      end
      doc.css("input, select, textarea").each do |element| # 改名
        element['name'] = "theme[settings][#{element['name']}]"
      end
      doc.inner_html
    end

    def theme
      proxy_owner
    end
  end
end

#商店外观主题
class ShopTheme < ActiveRecord::Base
  belongs_to :shop
  belongs_to :theme
  has_many :settings, class_name: 'ShopThemeSetting', dependent: :destroy, extend: ShopThemeSetting::Extension

  validates_presence_of :load_preset

  before_validation do
    # 初始化主题设置
    self.load_preset = config_settings['current']
  end

  after_save do
    repo = Grit::Repo.init public_path # 初始化为git repo
    FileUtils.cp_r "#{app_path}/.", public_path
    commit repo, '1'
    config_settings['presets'].each_pair do |preset, values|
      values.each_pair do |name, value|
        self.settings.create name: name, value: value
      end
    end
  end

  def switch(new_theme) # 切换主题
    self.update_attribute :theme, new_theme
  end

  begin #相对路径
    def files_relative_path # s/files/1/theme
      test = %w(test travis).include?(Rails.env) ? Rails.env : '' #测试目录与其他环境分开,不干扰
      File.join 's', 'files', test, self.id.to_s, 'theme'
    end

    def asset_relative_path(asset) # s/files/1/theme/assets/theme.liquid
      File.join files_relative_path, 'assets', asset
    end
  end

  begin # 所属主题相关PATH(非当前theme)
    def app_path
      File.join Rails.root, 'app', 'themes', self.theme.name.downcase
    end

    def shopqi_theme_path # app/themes/shopqi # 用于保存顾客登录等模板
      File.join Rails.root, 'app', 'themes', 'shopqi'
    end

    def config_settings_path # app/themes/threadify/config/settings.html
      File.join app_path, 'config', 'settings.html'
    end

    def config_settings_data_path # app/themes/threadify/config/settings_data.json #script/theme.rb将保证此文件存在
      File.join app_path, 'config', 'settings_data.json'
    end

    def config_settings
      JSON(File.read(config_settings_data_path))
    end
  end

  begin # 当前theme所在PATH
    def public_path # public/s/files/1/theme
      File.join Rails.root, 'public', files_relative_path
    end

    def asset_path(asset) # public/s/files/1/theme/assets/checkout.css.liquid
      asset_liquid = "#{asset}.liquid"
      path = File.join public_path, 'assets', asset_liquid
      if File.exist?(path) #存在liquid文件，则解释liquid
        path
      else
        File.join public_path, 'assets', asset
      end
    end

    def layout_theme_path # public/s/files/1/theme/layout/theme.liquid
      File.join public_path, 'layout', 'theme.liquid'
    end

    def template_path(template) # public/s/files/1/theme/templates/products.liquid
      File.join public_path, 'templates', "#{template}.liquid"
    end
  end

  def commit(repo, message) # 提交
    Dir.chdir public_path do # 必须切换当前目录，否则报错: fatal: 'path' is outside repository
      repo.add '.'
      repo.commit_all message
    end
  end
end
