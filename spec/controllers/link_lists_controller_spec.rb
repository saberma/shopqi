# encoding: utf-8
require 'spec_helper'

describe LinkListsController do
  include Devise::TestHelpers

  let(:admin) { Factory(:user_admin) }

  let(:shop) { admin.shop }

  let(:link_list) { Factory(:link_list, shop: shop) }
  
  let(:link_list_with_links) { Factory(:link_list_with_links, shop: shop) }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(admin)
  end

  context '#update' do

    it "without links" do
      xhr :put, :update, :id => link_list.id, :link_list => link_list.attributes
      response.should be_success
    end

    it "with links" do
      attrs = link_list_with_links.attributes
      attrs[:links_attributes] = []
      link_list_with_links.links.each do |link|
        attrs[:links_attributes] << link.attributes
      end
      attrs[:links_attributes] << {:title => '联想'}

      xhr :put, :update, :id => link_list_with_links.id, :link_list => attrs
      response.should be_success
      link_list_with_links.reload.links.size.should eql attrs[:links_attributes].size
    end

  end

end
