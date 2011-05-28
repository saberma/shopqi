class Pages < Liquid::Drop
  
  # 关于我们
  define_method('about-us') do
    shop.pages.where(handler: 'about-us').first
  end

end

