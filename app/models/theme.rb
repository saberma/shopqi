# encoding: utf-8
# 可选外观主题(使用ActiveHash，以后增加记录直接加item，无须增加migration)
class Theme < ActiveHash::Base
  # 名称 风格 价格 颜色(Red Yellow Green Blue Magenta White Black Grey) 描述 
  self.data = [
    {id: 1, name: 'Prettify'    , style: 'default'       , price: 0 , color: ''}, #26
    {id: 2, name: 'Threadify'   , style: 'original'      , price: 0 , color: ''}, #65
    {id: 3, name: 'Woodland'    , style: 'Slate'         , price: 0 , color: ''}, #96
    {id: 4, name: 'Woodland'    , style: 'Birchwood'     , price: 0 , color: ''}, #90
    {id: 5, name: 'Woodland'    , style: 'Dark Alder'    , price: 0 , color: ''}, #89
    {id: 6, name: 'Structure'   , style: 'Electronics'   , price: 0 , color: ''}, #35
    {id: 7, name: 'Structure'   , style: 'Apparel'       , price: 0 , color: ''}, #36
    {id: 8, name: 'Structure'   , style: 'Crafts'        , price: 0 , color: ''}, #37
    {id: 9, name: 'Structure'   , style: 'Jewelry'       , price: 0 , color: ''}, #34
  ]

  def self.default
    find_by_name('Threadify')
  end
end
