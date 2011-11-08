#encoding: utf-8
class LinkListsDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def before_method(handle) #相当于method_missing
    link = @shop.link_lists.where(handle: handle).first || @shop.link_lists.new
    LinkListDrop.new link
  end

end

class LinkListDrop < Liquid::Drop

  def initialize(link_list)
    @link_list = link_list
  end

  delegate :title, to: :@link_list

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

  delegate :title, :url, to: :@link

end
