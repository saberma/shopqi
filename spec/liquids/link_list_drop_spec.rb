#encoding: utf-8
require 'spec_helper'

describe LinkListDrop do

  describe LinkDrop do

    it 'should get the title' do
      link = Link.new title: '首页', subject: '/'
      link_drop = LinkDrop.new link
      link_drop.title.should eql '首页'
      link_drop.url.should eql '/'
    end

  end

end
