#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "lookup" do
  include_context 'login admin'

  describe "search product,article,page,blog" do
    context '#query' do
      it "works!", js: true do
        visit products_path
        fill_in 'q', with: '示例'
        page.execute_script('document.forms[0].submit()')
        1.upto(6) do |i|
          has_content?("示例商品#{i}").should be_true
        end

        fill_in 'q', with: 'eeee'
        page.execute_script('document.forms[0].submit()')
        has_content?("非常抱歉").should be_true
      end
    end
  end

end
