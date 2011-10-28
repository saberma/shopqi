# encoding: utf-8
# 初始化开发环境(注意:原有数据和文件会被清空)
# bundle exec rake shopqi:bootstrap
namespace :shopqi do

  desc "Run all bootstrapping tasks"
  task :bootstrap do
    unless Rails.env == 'production' # 防止生产环境下执行
      FileUtils.rm_rf Rails.root.join('data')
      data_files = Rails.root.join('data', 'public_s', 'files')
      public_files = Rails.root.join('public', 's', 'files')
      FileUtils.mkdir_p data_files
      FileUtils.ln_s data_files, public_files
      Rake::Task['db:setup'].invoke # 会调用db:schema:load，而非db:migrate
    end
  end

end
