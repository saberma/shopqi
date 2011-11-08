#encoding: utf-8
require 'spec_helper'

describe LinkListsDrop do

  let(:shop) { Factory(:user).shop }

  describe LinkListDrop do

    it 'should get the title', focus: true do
      variant = "{{ linklists.main-menu.title }}"
      result = "主菜单"
      Liquid::Template.parse(variant).render('linklists' => LinkListsDrop.new(shop)).should eql result
    end

  end

  describe LinkDrop do

    context 'exist' do

      it 'should get the title' do
        variant = "{% for link in linklists.main-menu.links %}<span>{{ link.title }}</span>{% endfor %}"
        result = "<span>首页</span><span>商品列表</span><span>关于我们</span>"
        Liquid::Template.parse(variant).render('linklists' => LinkListsDrop.new(shop)).should eql result
      end

    end

    context 'missing' do

      it 'should get the links', focus: true do
        variant = "{{ linklists.noexist.links.size }}"
        result = "0"
        Liquid::Template.parse(variant).render('linklists' => LinkListsDrop.new(shop)).should eql result
      end
    end

  end

end
