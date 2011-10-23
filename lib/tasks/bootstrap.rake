namespace :shopqi do

  desc "Run all bootstrapping tasks"
  task :bootstrap do
    FileUtils.mkdir_p Rails.root.join('data')
    Rake::Task['db:setup'].invoke
  end

end
