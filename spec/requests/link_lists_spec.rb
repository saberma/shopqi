# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "LinkLists", js: true do
  #do use  in integration tests(http://rdoc.info/github/plataformatec/devise/master/Devise/TestHelpers)
  #include Devise::TestHelpers

  include_context 'login admin'

  before :each do
    visit link_lists_path
  end

  describe "GET /admin/link_lists" do

    describe "LinkList" do

      it "should be index" do # 默认链接列表
        within '#menus' do
          within :xpath, './li[1]' do
            within '.default_container_link_list > div:first' do
              find('h4').text.should eql '主菜单'
              find('span.note').text.should eql '这是默认链接列表，不能删除.'
              has_css?('.destroy').should be_false
            end
            within '.links' do # 链接记录
              within :xpath, './li[1]' do
                find('.link-title').text.should eql '首页'
                find('.link-url').text.should eql '/'
              end
              within :xpath, './li[2]' do
                find('.link-title').text.should eql '商品列表'
                find('.link-url').text.should eql '/collections/all'
              end
              within :xpath, './li[3]' do
                find('.link-title').text.should eql '关于我们'
                find('.link-url').text.should eql '/pages/about-us'
              end
            end
          end
          within :xpath, './li[2]' do
            within '.default_container_link_list > div:first' do
              find('h4').text.should eql '页脚'
              find('span.note').text.should eql '这是默认链接列表，不能删除.'
              has_css?('.destroy').should be_false
            end
            within '.links' do # 链接记录
              within :xpath, './li[1]' do
                find('.link-title').text.should eql '查询'
                find('.link-url').text.should eql '/search'
              end
              within :xpath, './li[2]' do
                find('.link-title').text.should eql '关于我们'
                find('.link-url').text.should eql '/pages/about-us'
              end
            end
          end
        end
      end

      it "should be add" do # 新增
        click_on '新增链接列表'
        within '#add-menu' do
          fill_in '标题', with: '热门产品'
          click_on '保存'
        end
        has_content?('新增成功!').should be_true
        within '#menus' do
          within :xpath, './li[3]' do
            within '.default_container_link_list > div:first' do
              find('h4').text.should eql '热门产品'
              has_content?('这是默认链接列表，不能删除.').should be_false
              has_css?('.destroy').should be_true
            end
            has_content?('此链接列表还没有加入任何链接').should be_true
          end
        end
      end

      it "should be edit" do # 修改
        within '#menus' do
          within :xpath, './li[1]' do
            click_on '修改链接列表'
            fill_in 'link_list[title]', with: '商店菜单'
            within '.editing-link-list' do # 链接记录
              within :xpath, './li[1]' do
                fill_in 'title', with: '商店首页'
                select '其他网址'
                fill_in 'url', with: '/home'
              end
            end
            click_on '保存'
            within '.default_container_link_list > div:first' do
              find('h4').text.should eql '商店菜单'
            end
            within '.links' do # 链接记录
              within :xpath, './li[1]' do
                find('.link-title').text.should eql '商店首页'
                find('.link-url').text.should eql '/home'
              end
            end
          end
        end
      end

      it "should update handle" do # 可以修改非默认链接记录的固定链接(handle) issues#217
        shop.link_lists.create title: '子菜单'
        visit link_lists_path
        within '#menus' do
          within :xpath, './li[3]' do
            click_on '修改链接列表'
            fill_in 'link_list[handle]', with: 'sub-navigation'
            click_on '保存'
          end
        end
        page.should have_content('修改成功!')
        within '#menus' do
          within :xpath, './li[3]' do
            within '.default_container_link_list > div:first' do
              find('h4')['title'].should have_content('固定链接: sub-navigation')
            end
          end
        end
      end

      it "should be destroy" do # 删除
        click_on '新增链接列表'
        within '#add-menu' do
          fill_in '标题', with: '热门产品'
          click_on '保存'
        end
        within '#menus' do
          within :xpath, './li[3]' do
            page.execute_script("window.confirm = function(msg) { return true; }")
            find('.destroy').click
          end
          page.should have_no_xpath('./li[3]')
        end
      end

    end

    describe "Link" do

      context 'add' do

        it "should be success" do # 新增
          within '#menus' do
            within :xpath, './li[1]' do
              click_on '新增链接'
              fill_in 'title', with: '查询'
              select '查询页面'
              find_field('subject_handle').visible?.should be_false
              find_field('subject_params').visible?.should be_false
              find_field('url').visible?.should be_false
              click_on '新增链接'
              within '.links' do # 链接记录
                within :xpath, './li[4]' do
                  find('.link-title').text.should eql '查询'
                  find('.link-url').text.should eql '/search'
                end
              end
            end
          end
        end

        it "should not add multi-links after edit" do # 修改后新增不能显示多条重复的链接 issues#243
          links_size = 0
          within '#menus' do
            within :xpath, './li[1]' do
              links_size = all('.links li').size
              click_on '修改链接列表'
              click_on '保存'
            end
          end
          page.should have_content('修改成功!')
          within '#menus' do
            within :xpath, './li[1]' do
              click_on '新增链接'
              fill_in 'title', with: '购物指南'
              click_on '新增链接'
              within '.links' do # 链接记录
                page.should have_xpath("./li[#{links_size+1}]")
                page.should have_no_xpath("./li[#{links_size+2}]")
                page.should have_no_xpath("./li[#{links_size+3}]")
              end
            end
          end
        end

      end

      it "should be destroy" do # 删除
        within '#menus' do
          within :xpath, './li[1]' do
            click_on '修改链接列表'
            within '.editing-link-list' do # 链接记录
              within :xpath, './li[1]' do
                page.execute_script("window.confirm = function(msg) { return true; }")
                find('.delete').click
              end
            end
            click_on '保存'
            within '.links' do # 链接记录
              within :xpath, './li[1]' do
                find('.link-title').text.should eql '商品列表'
              end
            end
          end
        end
      end

    end

  end

end
