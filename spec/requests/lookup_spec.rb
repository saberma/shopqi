#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "lookup", js: true do # 后台管理全文检索
  include_context 'login admin'

  describe "search product,article,page,blog" do

    context '#query', searchable: true do

      it "works!" do
        visit products_path
        fill_in 'q', with: '关于'
        page.execute_script('document.forms[0].submit()')
        page.should have_content("关于我们")

        fill_in 'q', with: 'eeee'
        page.execute_script('document.forms[0].submit()')
        has_content?("非常抱歉").should be_true
      end

    end

  end

end
