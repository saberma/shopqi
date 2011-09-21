
# Methods in this file need to be loaded first.
# This is because other initializers may depend on them.
# The funky filename?  Rails loads the initializers in alphabetical order.

def development?
  env_is('development')
end

def staging?
  env_is('staging')
end

def production?
  env_is('production')
end

def test?
  env_is('test')
end

def env_is(env)
  Rails.env == env
end

def test_dir #测试目录与其他环境分开,不干扰，用于保存主题文件
  %w(test travis).include?(Rails.env) ? Rails.env : ''
end
