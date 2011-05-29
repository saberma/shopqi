class PagesDrop < Liquid::Drop

  def initialize(shop, page = nil)
    @shop = shop
    @page = page
  end
  
  # 关于我们
  define_method('about-us') do
    self.class.new @shop, @shop.pages.where(handle: 'about-us').first
  end

  def content
    @page.body_html
  end

end

