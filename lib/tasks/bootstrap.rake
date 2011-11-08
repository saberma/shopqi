# encoding: utf-8
# 初始化开发环境(注意:原有数据和文件会被清空)
# bundle exec rake shopqi:bootstrap
namespace :shopqi do

  desc "Run all bootstrapping tasks"
  task :bootstrap do
    unless Rails.env == 'production' # 防止生产环境下执行
      secret_files = %w(
        config/initializers/secret_token.rb
      )
      secret_files.each do |file|
        path = Rails.root.join(file)
        unless File.exists?(path)
          source_path = Rails.root.join("#{file}.example")
          "复制配置文件:#{source_path} => #{path}"
          FileUtils.cp source_path, path
        end
      end

      FileUtils.rm_rf Rails.root.join('data')
      FileUtils.rm_rf Rails.root.join('public', 's', 'files')
      FileUtils.rm_rf Rails.root.join('public', 's', 'theme')

      asset_files = Rails.root.join('data', 'public_s', 'files') # 用于保存主题附件(此目录的文件链接至data/shops中的主题)
      screenshot_files = Rails.root.join('data', 'public_s', 'theme') # 用于保存主题截图(存于screenshots子目录)
      public_asset_files = Rails.root.join('public', 's', 'files')
      public_screenshot_files = Rails.root.join('public', 's', 'theme')

      FileUtils.mkdir_p asset_files
      FileUtils.mkdir_p screenshot_files
      FileUtils.ln_s asset_files, public_asset_files
      FileUtils.ln_s screenshot_files, public_screenshot_files
      Rake::Task['db:setup'].invoke # 会调用db:schema:load，而非db:migrate
    end
  end

end
