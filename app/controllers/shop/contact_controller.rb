#encoding: utf-8
class Shop::ContactController < Shop::AppController
  expose(:contact)
  expose(:shop) { Shop.at(request.host) }

  def create
    url = request.referer
    url = url[0, url.index('?')] if url.index('?')
    if contact.valid?
      url += "?contact_posted=true"
    else # 无法保存时传递contact参数，用于form提示错误
      url += "?#{contact.to_query}"
    end
    redirect_to url
  end

end
