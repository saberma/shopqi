# encoding: utf-8
require 'spec_helper'

describe LinkList do

  let(:shop) { Factory(:user).shop }

  let(:link_list) { Factory :link_list, shop: shop }

  let(:welcome) { Factory :welcome, shop: shop }

  describe Link do

    it 'should be save' do
      welcome
      expect do
        link_list.links.create title: '博客', link_type: 'blog', subject_handle: welcome.handle, url: "/blogs/#{welcome.handle}"
      end.to change(Link, :count).by(1)
    end

  end

end
