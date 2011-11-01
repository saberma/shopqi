class PagesDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def before_method(handle) #相当于method_missing
    page = @shop.pages.where(handle: handle).first || @shop.pages.new
    PageDrop.new page
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
