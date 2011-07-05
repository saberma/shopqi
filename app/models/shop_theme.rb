# encoding: utf-8
#商店外观主题
class ShopTheme < ActiveRecord::Base
  belongs_to :shop
  belongs_to :theme
  has_many :settings, class_name: 'ShopThemeSetting', dependent: :destroy

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

  # 返回文件列表
  def list
    repo = Grit::Repo.new public_path
    master = repo.tree
    master.trees.inject({}) do |result, tree|
      result[tree.name] = []
      tree.blobs.each do |blob|
        asset = {name: blob.name, id: blob.id, key: "#{tree.name}/#{blob.name}", tree_id: master.id}
        extensions = blob.name.split('.')[1]
        if !extensions.blank? and %w(jpg gif png jpeg).include? extensions
          asset['url'] = "/#{asset_relative_path(blob.name)}"
        end
        result[tree.name].push(asset: asset)
      end
      result
    end
  end

  def value(tree_id, key) # 返回文件内容
    repo = Grit::Repo.new public_path
    tree = repo.tree(tree_id)
    blob = tree./ key
    blob.data
    #repo.blob(id).data
  end

  def save_file(key, content) # 保存文件内容
    File.open(File.join(public_path, key), 'w') {|f| f.write content }
    repo = Grit::Repo.new public_path
    message = repo.log('master', key).size + 1
    commit repo, message
  end

  def commits(key) # 返回文件版本
    repo = Grit::Repo.new public_path
    repo.log 'master', key
  end

  def switch(new_theme) # 切换主题
    self.update_attribute :theme, new_theme
  end

  ##### 相对路径 #####
  def files_relative_path
    test = %w(test travis).include?(Rails.env) ? Rails.env : '' #测试目录与其他环境分开,不干扰
    File.join 's', 'files', test, self.id.to_s, 'theme'
  end

  def asset_relative_path(asset)
    File.join files_relative_path, 'assets', asset
  end

  ##### 本地PATH #####
  def app_path
    File.join Rails.root, 'app', 'themes', self.theme.name.downcase
  end

  def public_path
    File.join Rails.root, 'public', files_relative_path
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
    File.join app_path, 'config', 'settings.html'
  end

  def config_settings_data_path #script/theme.rb将保证此文件存在
    File.join app_path, 'config', 'settings_data.json'
  end

  def config_settings
    JSON(File.read(config_settings_data_path))
  end

  private
  def commit(repo, message) # 提交
    Grit.debug = true
    Dir.chdir public_path do # 必须切换当前目录，否则报错: fatal: 'path' is outside repository
      repo.add '.'
      repo.commit_all message
    end
  end
end

# 外观主题设置
class ShopThemeSetting < ActiveRecord::Base
  belongs_to :theme, class_name: 'ShopTheme'
end
