# encoding: utf-8
#商店外观主题文件
class Asset

  attr_accessor :key, :name, :url

  def initialize(theme, key, name, url = nil)
    @key = key
    @name = name
    @url = if url
      url
    else
      extensions = name.split('.')[1]
      if !extensions.blank? and %w(jpg gif png jpeg).include? extensions
        theme.asset_url(name)
      end
    end
  end

  # 返回文件列表
  def self.all(theme)
    repo = Grit::Repo.new theme.path
    master = repo.tree
    master.trees.inject({}) do |result, tree|
      result[tree.name] = []
      tree.blobs.sort do |x, y|
        x_basename, x_extension = x.name.split('.')
        y_basename, y_extension = y.name.split('.')
        x_extension = '0' if x_extension == 'css' # 保证css,js文件排在最前
        y_extension = '0' if y_extension == 'css'
        x_extension = '1' if x_extension == 'js'
        y_extension = '1' if y_extension == 'js'
        "#{x_extension}#{x_basename}" <=> "#{y_extension}#{y_basename}"
      end.each do |blob|
        asset = self.new theme, "#{tree.name}/#{blob.name}", blob.name
        result[tree.name].push asset
      end
      tree.trees.each do |nested_tree| # 嵌套目录(customers)
        nested_tree.blobs.each do |blob|
          asset = self.new theme, "#{tree.name}/#{nested_tree.name}/#{blob.name}", "#{nested_tree.name}/#{blob.name}"
          result[tree.name].push asset
        end
      end
      result
    end
  end

  # 新增文件
  # @key, 如:layout/theme.liquid
  # @source_key, 只在复制layout时使用
  def self.create(theme, key, source_key = nil, file = nil)
    key = safe(key)
    source_key = safe(source_key) if source_key
    kind, name = key.split('/', 2) # 最多分成2个数组元素
    source_path = case kind.to_sym
    when :layout
      File.join theme.path, source_key
    when :templates
      FileUtils.mkdir_p File.join(theme.path, 'templates', 'customers')
      File.join Rails.root, 'app', 'views', 'shop', key
    end
    path = File.join theme.path, key
    if source_path
      FileUtils.cp source_path, path
    elsif file
      if file.is_a?(MiniMagick::Image) # 在外观设置中上传的图片可能要限制大小
        file.write path
      else
        File.open(path, 'wb') {|f| f.write(file) }
      end
    else # snippets没有蓝本
      FileUtils.touch path
    end
    repo = Grit::Repo.new theme.path
    theme.commit repo, '1'
    self.new theme, key, name
  end

  def self.update(theme, key, content) # 保存文件内容
    key = safe(key)
    File.open(File.join(theme.path, key), 'w') {|f| f.write content }
    repo = Grit::Repo.new theme.path
    message = commits(theme, key).size + 1
    theme.commit repo, message
  end

  def self.rename(theme, key, new_key) # 重命名
    key = safe(key)
    new_key = safe(new_key)
    Dir.chdir theme.path do
      FileUtils.mv key, new_key
      repo = Grit::Repo.new theme.path
      theme.commit repo, '1'
    end
  end

  def self.value(theme, tree_id, key) # 返回文件内容
    key = safe(key)
    repo = Grit::Repo.new theme.path
    tree = repo.tree(tree_id)
    blob = tree./ key
    blob.data
  end

  def self.destroy(theme, key) # 删除文件
    key = safe(key)
    File.delete File.join(theme.path, key)
    repo = Grit::Repo.new theme.path
    theme.commit repo, "delete #{key}"
  end

  def self.commits(theme, key) # 返回文件版本
    key = safe(key)
    repo = Grit::Repo.new theme.path
    repo.log('master', key)
  end

  def self.safe(key) # 安全性考虑，过滤上传文件名称
    key = key.gsub /\.\./, '' # 避免相对路径
    key = key.gsub '\\', '/' # work-around for IE
    key = key.gsub /[^a-zA-Z0-9\/\.\-\+_]/, '_'
    key = "unnamed" if key.size == 0
    key.mb_chars.to_s
  end

end
