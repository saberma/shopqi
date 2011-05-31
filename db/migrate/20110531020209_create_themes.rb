#encoding: utf-8
#可选外观主题
class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
      t.string :name       , comment: '名称', null: false
      t.string :style      , comment: '风格', null: false
      t.integer :price     , comment: '价格', null: false                                                    , default: 0
      t.string :color      , comment: '颜色', null: false #%w(Red Yellow Green Blue Magenta White Black Grey)
      t.string :description, comment: '描述'

      t.timestamps
    end

    Theme.create [
      {name: 'Prettify'    , style: 'default'       , color: ''},
      {name: 'Couture'     , style: 'Arioso'        , color: ''},
      {name: 'Couture'     , style: 'Faust'         , color: ''},
      {name: 'Monochrome'  , style: 'Blue/Orange'   , color: ''},
      {name: 'Monochrome'  , style: 'Grey/Red'      , color: ''},
      {name: 'Woodland'    , style: 'Slate'         , color: ''},
      {name: 'Woodland'    , style: 'Birchwood'     , color: ''},
      {name: 'Woodland'    , style: 'Dark Alder'    , color: ''},
      {name: 'Threadify'   , style: 'original'      , color: ''},
      {name: 'Spotless'    , style: 'default'       , color: ''},
      {name: 'Structure'   , style: 'Electronics'   , color: ''},
      {name: 'Structure'   , style: 'Apparel'       , color: ''},
      {name: 'Structure'   , style: 'Crafts'        , color: ''},
      {name: 'Structure'   , style: 'Jewelry'       , color: ''},
      {name: 'Sortable'    , style: 'default'       , color: ''},
      {name: 'Solo'        , style: 'solo'          , color: ''},
      {name: 'Tribble'     , style: 'default'       , color: ''},
      {name: 'Moderno'     , style: 'default'       , color: ''},
      {name: 'Onyx'        , style: 'Royal/blue'    , color: ''},
      {name: 'Onyx'        , style: 'Ivory/bright'  , color: ''},
      {name: 'Onyx'        , style: 'Onyx/dark'     , color: ''},
      {name: 'Onyx'        , style: 'Summer/playful', color: ''},
      {name: 'Ripen'       , style: 'original'      , color: ''},
      {name: 'Reconfigured', style: 'original'      , color: ''},
      {name: 'Vogue'       , style: 'default'       , color: ''},
    ]
  end

  def self.down
    drop_table :themes
  end
end
