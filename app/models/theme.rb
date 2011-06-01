# encoding: utf-8
# 可选外观主题(使用ActiveHash，以后增加记录直接加item，无须增加migration)
class Theme < ActiveHash::Base
  # 名称 风格 价格 颜色(Red Yellow Green Blue Magenta White Black Grey) 描述 
  self.data = [
    {id: 1 , name: 'Prettify'    , style: 'default'       , price: 0 , color: ''},
    {id: 2 , name: 'Couture'     , style: 'Arioso'        , price: 0 , color: ''},
    {id: 3 , name: 'Couture'     , style: 'Faust'         , price: 0 , color: ''},
    {id: 4 , name: 'Monochrome'  , style: 'Blue/Orange'   , price: 0 , color: ''},
    {id: 5 , name: 'Monochrome'  , style: 'Grey/Red'      , price: 0 , color: ''},
    {id: 6 , name: 'Woodland'    , style: 'Slate'         , price: 0 , color: ''},
    {id: 7 , name: 'Woodland'    , style: 'Birchwood'     , price: 0 , color: ''},
    {id: 8 , name: 'Woodland'    , style: 'Dark Alder'    , price: 0 , color: ''},
    {id: 9 , name: 'Threadify'   , style: 'original'      , price: 0 , color: ''},
    {id: 10, name: 'Spotless'    , style: 'default'       , price: 0 , color: ''},
    {id: 11, name: 'Structure'   , style: 'Electronics'   , price: 0 , color: ''},
    {id: 12, name: 'Structure'   , style: 'Apparel'       , price: 0 , color: ''},
    {id: 13, name: 'Structure'   , style: 'Crafts'        , price: 0 , color: ''},
    {id: 14, name: 'Structure'   , style: 'Jewelry'       , price: 0 , color: ''},
    {id: 15, name: 'Sortable'    , style: 'default'       , price: 0 , color: ''},
    {id: 16, name: 'Solo'        , style: 'solo'          , price: 0 , color: ''},
    {id: 17, name: 'Tribble'     , style: 'default'       , price: 0 , color: ''},
    {id: 18, name: 'Moderno'     , style: 'default'       , price: 0 , color: ''},
    {id: 19, name: 'Onyx'        , style: 'Royal/blue'    , price: 0 , color: ''},
    {id: 20, name: 'Onyx'        , style: 'Ivory/bright'  , price: 0 , color: ''},
    {id: 21, name: 'Onyx'        , style: 'Onyx/dark'     , price: 0 , color: ''},
    {id: 22, name: 'Onyx'        , style: 'Summer/playful', price: 0 , color: ''},
    {id: 23, name: 'Ripen'       , style: 'original'      , price: 0 , color: ''},
    {id: 24, name: 'Reconfigured', style: 'original'      , price: 0 , color: ''},
    {id: 25, name: 'Vogue'       , style: 'default'       , price: 0 , color: ''},
  ]

  def self.default
    find_by_name('Prettify')
  end
end
