class PagesDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def before_method(handle) #相当于method_missing
    PageDrop.new @shop.pages.where(handle: handle).first
  end

end

class PageDrop < Liquid::Drop

  def initialize(page)
    @page = page
  end

  def title
    @page.title
  end

  def content
    @page.body_html
  end

  def url
    "/pages/#{@page.handle}"
  end

end
