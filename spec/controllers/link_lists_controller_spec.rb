# encoding: utf-8
require 'spec_helper'

describe LinkListsController do

  let(:link_list) { Factory(:link_list) }
  
  let(:link_list_with_links) { Factory(:link_list_with_links) }

  context '#update' do

    it "without links" do
      xhr :put, :update, :id => link_list.id, :link_list => link_list.attributes
      response.should be_success
    end

    it "with links" do
      attrs = link_list_with_links.attributes
      attrs[:links] = []
      link_list_with_links.links.each do |link|
        attrs[:links] << link.attributes
      end

      ap attrs
      xhr :put, :update, :id => link_list_with_links.id, :link_list => attrs
      response.should be_success
    end

  end

end
