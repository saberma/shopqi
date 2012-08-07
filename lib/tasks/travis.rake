namespace :travis do

  desc "Run travis in parallel"
  task :parallel do
    unit_parallel_size = 1
    integrate_parallel_size = 4
    unit_test = ENV['UNIT_TEST']
    integrate_test = ENV['INTEGRATE_TEST']
    all_files = Dir.chdir(Rails.root) { Dir["spec/**/*_spec.rb"]}.sort
    integrate_files = Dir.chdir(Rails.root) { Dir["spec/requests/**/*_spec.rb"]}.sort
    unit_files = all_files - integrate_files
    %w(shop/shops_searches_spec.rb lookup_spec.rb).each do |searchable_spec|
      integrate_files.delete "spec/requests/#{searchable_spec}" # 需要solr才能运行
    end
    files = if unit_test # 1个并发
            unit_files.in_groups(unit_parallel_size)[unit_test.to_i-1].join(' ')
          elsif integrate_test # 4个并发
            integrate_files.in_groups(integrate_parallel_size)[integrate_test.to_i-1].join(' ')
          end

    cmd = "rspec #{files}"
    #cmd = "rspec spec/requests/shop/shop_orders_spec.rb spec/requests/shop/shop_customers_spec.rb" # selenium-webdriver 2.14未清空session，按此顺序运行，第二个用例失败
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end

end
