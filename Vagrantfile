Vagrant::Config.run do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "lucid32-shopqi-new"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port "web-shopqi", 3000, 3000
  config.vm.forward_port "postgre", 5432, 5432
  config.vm.forward_port "redis-shopqi", 6379, 6379
  config.vm.forward_port "resque-web", 8282, 8282
  config.vm.forward_port "livereload", 35729, 35729
  config.vm.forward_port "sphinx", 9313, 9313
  config.vm.forward_port "sphinx-test", 9314, 9314

  #fixed: share folder performance. http://vagrantup.com/docs/nfs.html
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)
  config.vm.network("33.33.33.20")

  # Enable provisioning with chef solo, specifying a cookbooks path (relative
  # to this Vagrantfile), and adding some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    chef.recipe_url = "https://dl.dropbox.com/u/19519145/shopqi/chef-solo.tar.gz"
    #chef.cookbooks_path = "/home/saberma/Documents/chef-repo/cookbooks"
    chef.add_recipe "develop"
  
    # You may also specify custom JSON attributes:
    #chef.json = { :mysql_password => "foo" }

    chef.log_level = :debug
  end

  #config.vm.customize do |vm|
  #  vm.memory_size = 1024
  #end

end
