# encoding: utf-8
class District
  CHINA = '000000' # 全国
  PATTERN = /(\d{2})(\d{2})(\d{2})/

  def self.list(parent_id = '000000')
    result = []
    return result if parent_id.blank?
    province_id = self.province(parent_id)
    city_id = self.city(parent_id)
    children = self.data
    children = children[province_id][:children] if children.has_key?(province_id)
    children = children[city_id][:children] if children.has_key?(city_id)
    children.each_key do |id|
      result.push [ children[id][:text], id]
    end

    #sort
    result.sort! {|a, b| a[1] <=> b[1]}
    result
  end

  # @options[:prepend_parent] 是否显示上级区域
  def self.get(id, options = {})
    return '' if id.blank?
    prepend_parent = options[:prepend_parent] || false
    children = self.data
    return children[id][:text] if children.has_key?(id)
    province_id = self.province(id)
    province_text = children[province_id][:text]
    children = children[province_id][:children]
    return "#{prepend_parent ? province_text : ''}#{children[id][:text]}" if children.has_key?(id)
    city_id = self.city(id)
    city_text = children[city_id][:text]
    children = children[city_id][:children]
    return "#{prepend_parent ? (province_text + city_text) : ''}#{children[id][:text]}"
  end

  begin 'parse' # 解析出省市区编码

    def self.match(code)
      code.match(PATTERN)
    end

    def self.province(code)
      self.match(code)[1].ljust(6, '0')
    end

    def self.city(code)
      id_match = self.match(code)
      "#{id_match[1]}#{id_match[2]}".ljust(6, '0')
    end

  end

  private
  def self.data
    unless @list
      #{ '440000' => 
      #  { 
      #    :text => '广东', 
      #    :children => 
      #      { 
      #        '440300' => 
      #          { 
      #            :text => '深圳', 
      #            :children => 
      #              { 
      #                '440305' => { :text => '南山' }
      #              } 
      #           }
      #       }
      #   }
      # }
      @list = {}
      #@see: http://github.com/RobinQu/LocationSelect-Plugin/raw/master/areas_1.0.json
      json = JSON.parse(File.read("#{Rails.root}/db/areas.json"))
      districts = json.values.flatten
      districts.each do |district|
        id = district['id']
        text = district['text']
        if id.end_with?('0000')
          @list[id] =  {:text => text, :children => {}}
        elsif id.end_with?('00')
          province_id = self.province(id)
          @list[province_id] = {:text => nil, :children => {}} unless @list.has_key?(province_id)
          @list[province_id][:children][id] = {:text => text, :children => {}}
        else
          province_id = self.province(id)
          city_id = self.city(id)
          @list[province_id] = {:text => text, :children => {}} unless @list.has_key?(province_id)
          @list[province_id][:children][city_id] = {:text => text, :children => {}} unless @list[province_id][:children].has_key?(city_id)
          @list[province_id][:children][city_id][:children][id] = {:text => text}
        end
      end
    end
    @list
  end

end
