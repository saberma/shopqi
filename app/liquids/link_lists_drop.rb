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

  def active # 是否为当前url地址
    current_url = @context['current_url']
    return false unless current_url
    anchor_index = current_url.index('#')
    query_index = current_url.index('?')
    current_url = current_url[0, query_index] if query_index
    current_url = current_url[0, anchor_index] if anchor_index
    current_url == @link.url
  end

end
