# encoding: utf-8
# 外观主题设置
class ShopThemeSetting < ActiveRecord::Base
  belongs_to :theme, class_name: 'ShopTheme'

  # 修改此模块内方法要记得重启服务
  module Extension # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html #Association extensions
    def html_path  # data/shops/1/theme/1/config/settings.html
      File.join theme.path, 'config', 'settings.html'
    end

    def data_path # data/shops/1/theme/1/config/settings_data.json
      File.join theme.path, 'config', 'settings_data.json'
    end

    def as_json
      data = File.read(data_path)
      JSON data unless data.blank?
    end

    def save(preset, data)
      data = data.as_json.symbolize_keys
      settings = self.as_json
      doc = Nokogiri::HTML(File.read(html_path))
      doc.css("input[type='checkbox']").each do |element| # 转化为boolean值
        name = element['name'].to_sym
        data[name] = %w(1 on true).include?(data[name])
      end
      if preset.blank? # 定制的直接保存在current根节点
        settings['current'] = data
      else
        settings['current'] = preset
        settings['presets'][preset] = data
      end
      save_settings data
      Asset.update theme, 'config/settings_data.json', JSON.pretty_generate(settings)
    end

    def destroy_preset(preset)
      settings = self.as_json
      data = settings['presets'].delete preset
      settings['current'] = data
      save_settings data
      Asset.update theme, 'config/settings_data.json', JSON.pretty_generate(settings)
    end

    def transform # settings.html的内容要先经过处理: 上传、字体、改名
      doc = Nokogiri::HTML(File.open(html_path), nil, 'utf-8') #http://nokogiri.org/tutorials/modifying_an_html_xml_document.html
      doc.css("input[type='file']").each do |file| # 上传文件
        name = file['name']
        max_width = file['data-max-width'] # 限制图片宽高
        max_height = file['data-max-height']
        exists = File.exist? File.join(theme.path, 'assets', name) # 是否已经上传了图片
        td = file.parent
        builder = Nokogiri::HTML::Builder.new do
          table.widget(cellspacing: 0) {
            tr {
              td {
                div(name: name, class: :file, 'data-max-width' => max_width, 'data-max-height' => max_height) } } # 使用ajax后台上传
            if exists # 已经上传图片，显示图片预览
              url = theme.asset_url(name)
              tr {
                td {
                  div.asset {
                    div(class: 'asset-image') {
                      a(class: 'closure-lightbox', href: url) {
                        img(src: '/assets/admin/icons/mimes/png.gif') } }
                    span.note {
                      a(class: 'closure-lightbox', href: url) { text name } } } } }
            end
          }
        end
        td.inner_html = builder.doc.inner_html
      end
      doc.css("select.font").each do |element| # 字体
        builder = Nokogiri::HTML::Builder.new do
          div {
            optgroup(label: "无衬线字体(Sans-serif)") {
              option(value: "Helvetica, Arial, sans-serif") { text 'Helvetica/Arial' }
              option(value: "Impact, Charcoal, Helvetica, Arial, sans-serif") { text 'Impact' }
              option(value: "'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', Lucida, Helvetica, Arial, sans-serif") { text 'Lucida Grande' }
              option(value: "Trebuchet MS, sans-serif") { text 'Trebuchet MS'}
              option(value: "Verdana, Helvetica, Arial, sans-serif") { text 'Verdana' } }
            optgroup(label: "衬线字体(Serif)") {
              option(value: "Garamond, Baskerville, Caslon, serif") { text 'Garamond' }
              option(value: "Georgia, Utopia, 'Times New Roman', Times, serif") { text 'Georgia' }
              option(value: "Palatino, 'Palatino Linotype', 'Book Antiqua', serif") { text 'GPalatino' }
              option(value: "'Times New Roman', Times, serif") { text 'Times New Roman' } }
            optgroup(label: "等宽字体(Monospace)") {
              option(value: "'Courier New', Courier, monospace") { text 'Courier New' }
              option(value: "Monaco, 'Lucida Console', 'DejaVu Sans Mono', monospace") { text 'Monaco/Lucida Console' } } }
        end
        element.inner_html = builder.doc.at_css('div').inner_html
      end
      doc.css("select.collection").each do |element| # 集合
        builder = Nokogiri::HTML::Builder.new do
          div {
            option(value: nil) { text '无' }
            option(value: nil, disabled: true) { text '---' }
            self.theme.shop.collections.each do |collection|
              option(value: collection.handle) { text collection.title }
            end
          }
        end
        element.inner_html = builder.doc.at_css('div').inner_html
      end
      doc.css("select.blog").each do |element| # 博客
        builder = Nokogiri::HTML::Builder.new do
          div {
            option(value: nil) { text '无' }
            option(value: nil, disabled: true) { text '---' }
            self.theme.shop.blogs.each do |blog|
              option(value: blog.handle) { text blog.title }
            end
          }
        end
        element.inner_html = builder.doc.at_css('div').inner_html
      end
      doc.css("select.page").each do |element| # 页面
        builder = Nokogiri::HTML::Builder.new do
          div {
            option(value: nil) { text '无' }
            option(value: nil, disabled: true) { text '---' }
            self.theme.shop.pages.each do |page|
              option(value: page.handle) { text page.title }
            end
          }
        end
        element.inner_html = builder.doc.at_css('div').inner_html
      end
      doc.css("select.linklist").each do |element| # 链接列表
        builder = Nokogiri::HTML::Builder.new do
          div {
            option(value: nil) { text '无' }
            option(value: nil, disabled: true) { text '---' }
            self.theme.shop.link_lists.each do |link_list|
              option(value: link_list.handle) { text link_list.title }
            end
          }
        end
        element.inner_html = builder.doc.at_css('div').inner_html
      end
      snippets_path = File.join(self.theme.path, 'snippets')
      snippets_doc = doc.css("select.snippet")
      if File.exists?(snippets_path) and !snippets_doc.empty?
        snippets = Dir[File.join(snippets_path, '*')].map {|file| File.basename(file, ".liquid")}
        snippets_doc.each do |element| # 片段
          builder = Nokogiri::HTML::Builder.new do
            div {
              option(value: nil) { text '无' }
              option(value: nil, disabled: true) { text '---' }
              snippets.each do |snippet|
                option(value: snippet) { text snippet }
              end
            }
          end
          element.inner_html = builder.doc.at_css('div').inner_html
        end
      end
      doc.css("input, select, textarea").each do |element| # 改名
        element['id'] ||= element['name'] # 一定要有id，对应settings_data.json
        element['name'] = "settings[#{element['name']}]"
      end
      doc.inner_html
    end

    def save_settings(data) # 保存settings记录，方便liquid获取(比如settings.use_logo_image)
      theme.settings.clear
      data = data.map do |name, value|
        {name: name, value: value}
      end
      theme.settings.create data
    end

    def theme
      @association.owner
    end
  end
end

#商店外观主题
class ShopTheme < ActiveRecord::Base
  REQUIRED_FILES = ["layout/theme.liquid","templates/index.liquid","templates/collection.liquid","templates/product.liquid","templates/cart.liquid","templates/search.liquid","templates/page.liquid","templates/blog.liquid","templates/article.liquid"]
  ZIP_DIRECTORIES = /^.*(layout|templates|assets|snippets|config)/ # 上传压缩必须的目录

  belongs_to :shop
  belongs_to :theme
  has_many :settings, class_name: 'ShopThemeSetting', dependent: :destroy, extend: ShopThemeSetting::Extension

  default_value_for :role, :main # 默认为普通主题

  validates_presence_of :name

  before_validation do
    self.name ||= theme.name # 默认为主题名称(复制时直接指定)
  end

  after_create do
    if self.theme_id # 应用某个主题，而非手动上传主题
      self.create_repo do
        FileUtils.cp_r "#{self.theme.path}/.", path
      end
    end
  end

  def create_repo # 初始化git版本控制，链接asset目录至public
    repo = Grit::Repo.init path
    yield # 复制或解压主题文件
    commit repo, '1'
    self.load_preset ||= config_settings['current'] # 初始化主题设置
    presets = config_settings['presets']
    if presets and presets.has_key?(self.load_preset) # 用户上传的settings_data.json可能不存在预设
      self.transaction do
        presets[self.load_preset].each_pair do |name, value|
          self.settings.create name: name, value: value
        end
      end
    end
    FileUtils.mkdir_p public_path # 主题文件只有附件对外公开，其他文件不能被外部访问
    public_asset_path = File.join(public_path, 'assets')
    FileUtils.rm_rf public_asset_path # fixed: ln_s发现目录存在时，会在目录下新增目录，导致循环
    FileUtils.ln_s File.realpath(File.join(path, 'assets')), public_asset_path
  end

  # 修改此模块内方法要记得重启服务
  module Extension # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html #Association extensions
    def shop
      @association.owner
    end

    def install(theme)  # 安装主题
      shop.theme.unpublish! if shop.theme
      self.create theme_id: theme.id, role: theme.role
    end

    def exceed? # 超过8个主题
      self.size >= 8
    end
  end

  def unpublish! # 取消发布
    self.update_attributes! role: 'unpublished'
  end

  def published? # 是否已发布
    %w(main mobile).include? self.role
  end

  def unpublished? # 是否未发布
    self.role == 'unpublished'
  end

  def duplicate # 复制主题
    self.shop.themes.create theme_id: self.theme_id, name: "副本 #{self.name}", load_preset: self.load_preset, role: 'unpublished'
  end

  begin #相对路径
    def files_relative_path # s/files/1/theme/1
      File.join 's', 'files', test_dir, self.shop_id.to_s, 'theme', self.id.to_s
    end

    def asset_relative_path(asset) # s/files/1/theme/1/assets/checkout.css
      File.join files_relative_path, 'assets', asset
    end
  end

  begin # 当前theme所在URL
    def asset_url(name) # s/files/1/theme/1/assets/checkout.css
      "/#{self.asset_relative_path(name)}?#{File.mtime(self.asset_path(name)).to_i}"
    end
  end

  begin # 当前theme所在PATH
    def path # data/shops/1/themes/1
      File.join shop.path, 'themes', self.id.to_s
    end

    def public_path # public/s/files/1/theme/1
      File.join shop.public_path, 'theme', self.id.to_s
    end

    def config_settings_path # data/shops/1/themes/1/config/settings.html
      File.join path, 'config', 'settings.html'
    end

    def config_settings_data_path # data/shops/1/themes/1/config/settings_data.json
      File.join path, 'config', 'settings_data.json'
    end

    def config_settings
      JSON(File.read(config_settings_data_path))
    end

    def asset_path(asset) # data/shops/1/themes/1/assets/checkout.css.liquid
      asset_liquid = "#{asset}.liquid"
      liquid_path = File.join path, 'assets', asset_liquid
      if File.exist?(liquid_path) #存在liquid文件，则解释liquid
        liquid_path
      else
        File.join path, 'assets', asset
      end
    end

    def layout_theme_path # data/shops/1/theme/1/layout/theme.liquid
      File.join path, 'layout', 'theme.liquid'
    end

    def template_path(template) # data/shops/1/theme/1/templates/products.liquid
      File.join path, 'templates', "#{template}.liquid"
    end
  end

  def commit(repo, message) # 提交
    Dir.chdir path do # 必须切换当前目录，否则报错: fatal: 'path' is outside repository
      repo.add '.'
      repo.commit_all message
    end
  end

  after_destroy do #删除对应的目录
    FileUtils.rm_rf self.path
    FileUtils.rm_rf self.public_path
  end
end
