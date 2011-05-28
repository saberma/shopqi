#encoding: utf-8
class LinkListDrop < Liquid::Drop

  def initialize(shop, link_list = nil)
    @shop = shop
    @link_list = link_list
  end
  
  # 菜单
  define_method('main-menu') do #横杠不能定义为方法
    self.class.new @shop, @shop.link_lists.where(handle: 'main-menu').first
  end
  
  # 页脚
  def footer
    self.class.new @shop, @shop.link_lists.where(handle: :footer).first
  end

  def links
    @link_list.links.map do |link|
      LinkDrop.new link
    end
  end

end

class LinkDrop < Liquid::Drop

  def initialize(link)
    @link = link
  end

  def title
    @link.title
  end

  def url
    @link.subject
  end

end
