# encoding: utf-8
#!/usr/bin/env ruby
# 检查外观主题设置 config/settings.html，生成config/settings_data.json
# script/rails runner script/theme.rb
def settings(path)
  doc = Nokogiri::HTML(File.read(path))
  inputs = doc.css('input').map do |input|
    type = input[:type]
    value = case type
      when 'checkbox'
        input[:checked].blank? ? 'false' : 'true'
      when 'file'
        '' #暂时为空
      else
        input[:value]
      end
    [input[:name], value]
  end
  selects = doc.css('select').map do |select|
    value = select.at_css("option[selected]")[:value]
    [select[:name], value]
  end
  elements = (inputs + selects).flatten
  Hash[*elements]
end

Dir["#{Rails.root}/app/themes/*"].each do |theme_path|
  p theme_path
  config_data_path = File.join theme_path, 'config', 'settings_data.json'
  config_path = File.join theme_path, 'config', 'settings.html'
  unless File.exists?(config_data_path) #json文件则生成
    p "create #{config_data_path}"
    data = {
      'presets' => {'default' => settings(config_path)},
      'current' => 'default'
    }
    File.open(config_data_path, 'w') { |f| f.write(JSON.pretty_generate(data)) }
  end
end
