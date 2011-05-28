class LinkListDrop < Liquid::Drop
  
  # 菜单
  define_method('main-menu') do
    shop.linklists.where(handler: 'main-menu').first
  end
  
  # 页脚
  def footer
    shop.linklists.where(handler: :footer).first
  end

end

class LinkDrop < Liquid::Drop
  
  def title
  end

end
