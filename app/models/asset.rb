# encoding: utf-8
#商店外观主题文件
class Asset

  # 返回文件列表
  def self.all(theme)
    repo = Grit::Repo.new theme.public_path
    master = repo.tree
    master.trees.inject({}) do |result, tree|
      result[tree.name] = []
      tree.blobs.each do |blob|
        asset = {name: blob.name, id: blob.id, key: "#{tree.name}/#{blob.name}", tree_id: master.id}
        extensions = blob.name.split('.')[1]
        if !extensions.blank? and %w(jpg gif png jpeg).include? extensions
          asset['url'] = "/#{theme.asset_relative_path(blob.name)}"
        end
        result[tree.name].push(asset: asset)
      end
      result
    end
  end

  def self.update(theme, key, content) # 保存文件内容
    File.open(File.join(theme.public_path, key), 'w') {|f| f.write content }
    repo = Grit::Repo.new theme.public_path
    message = repo.log('master', key).size + 1
    theme.commit repo, message
  end

  def self.value(theme, tree_id, key) # 返回文件内容
    repo = Grit::Repo.new theme.public_path
    tree = repo.tree(tree_id)
    blob = tree./ key
    blob.data
  end

  def self.destroy(theme, key) # 删除文件
    Grit.debug = true
    File.delete File.join(theme.public_path, key)
    repo = Grit::Repo.new theme.public_path
    theme.commit repo, "delete #{key}"
  end

  def self.commits(theme, key) # 返回文件版本
    repo = Grit::Repo.new theme.public_path
    repo.log 'master', key
  end
end
