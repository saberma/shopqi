#encoding: utf-8
require 'spec_helper'

describe Page do

  let(:shop) { Factory(:user).shop }

  context '#create' do

    context '(without handle)' do

      it 'should save handle' do
        page = shop.pages.create title: '联系我们'
        page.handle.should eql 'lian-xi-wo-men'
      end
    end

    context '(with handle)' do

      it 'should save handle' do
        page = shop.pages.create title: '联系我们', handle: 'concact-us'
        page.handle.should eql 'concact-us'
      end

    end

  end

  describe 'handle not found' do

    it 'should be raise error' do
      expect do
        shop.pages.handle!('no-exists-handle')
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

end
