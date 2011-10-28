#encoding: utf-8
class Express
  @@config = YAML::load_file(Rails.root.join('config/express.yml'))
  API_URL_BASE = @@config['API_URL_BASE']
  API_SITE_KEY = @@config['API_SITE_KEY']

  #compay: 快递公司的英文代号
  #number: 快递单号
  #show:   查询返回的数据格式 0 默认的是JSON ，1返回的是XML 2 返回的是HTML
  #multi:  返回结果的行数
  #order:  返回的查询信息的排列方式（按照时间的排序方式）
  #具体参见http://code.google.com/p/kuaidi-api/wiki/Open_API_API_URL
  def self.get_result(company,number,muti = 1,order = 'desc')
    query_url = "#{API_URL_BASE}id=#{API_SITE_KEY}&com=#{company}&nu=#{number}&show=0&muti=#{muti}&order=#{order}"
    begin
      result = JSON.parse(Net::HTTP.get(URI.parse(query_url)))
    rescue Exception => e
      logger.info { "快递接口错误" + e }
    end
  end
end
