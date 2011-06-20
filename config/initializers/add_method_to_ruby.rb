module LiquidDropHelper

  #由于liquid的hash只能是'key' => value形式
  #所以,key写成string的形式
  def as_json(options={})
    result = {}
    keys = self.public_methods(false)
    keys = keys - [:as_json, :options]
    keys.inject(result) do |result, method|
      result[method.to_s] = self.send(method)
      result
    end
    result
  end

end

Liquid::Drop.send :include , LiquidDropHelper
