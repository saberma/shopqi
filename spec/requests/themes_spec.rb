# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Themes", js: true do

  include_context 'login admin'

  let(:shop) { user_admin.shop }

  describe "GET /assets" do

    before(:each) { visit assets_path }

    describe 'save' do
    end

    describe 'show' do

      before(:each) do
        within '#theme-layout' do # 布局
          find(:xpath, './/li[1]').find('a').click # theme.liquid
        end
      end

      describe 'rename' do

        it "should be forbid" do # 关键文件不能重命名
          within '#current-asset' do 
            has_css?('#asset-link-rename').should be_false
          end
        end

        it "should be permit" do
          within '#theme-assets' do # 附件
            find('.asset-gif').click
          end
          within '#current-asset' do
            click_on '重命名'
            click_on '关闭' # 可以取消
            click_on '重命名'
            fill_in 'asset-basename-field', with: 'new_name.gif'
            click_on '提交'
            find('#asset-title').text.should eql 'new_name.gif'
          end
          within '#theme-assets' do # 附件
            find('.asset-gif').text.should eql 'new_name.gif'
          end
        end

      end

      describe "destroy" do

        it "should be forbid" do # 关键文件不能删除
          within '#current-asset' do 
            has_css?('#asset-link-destroy').should be_false
          end
        end

        it "should be permit" do
          name = ''
          within '#theme-assets' do # 附件
            name = find('.asset-gif').text
            find('.asset-gif').click
          end
          within '#current-asset' do
            page.execute_script("window.confirm = function(msg) { return true; }")
            find('#asset-link-destroy a').click # 删除按钮图标
            find('#asset-title').text.should eql '没有选择文件'
          end
          within '#theme-assets' do # 附件
            has_content?(name).should be_false
          end
        end

      end

      it "should show image" do
        within '#theme-assets' do # 附件
          find('.asset-gif').click
        end
        within '#current-asset' do
          find('#preview-image').visible?.should be_true
          find('#template-editor').visible?.should be_false
        end
      end

=begin
      it "should be update" do
        text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
        content = 'to be or not to be'
        text.should_not include content
        page.execute_script("TemplateEditor.editor.getSession().setValue('#{content}')");
        click_on '保存'
        find('#asset-info').has_content?('您的文件已经保存.').should be_true
        visit assets_path
        within '#theme-layout' do # 布局
          find(:xpath, './/li[1]').find('a').click
        end
        text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
        text.should include content
        click_on '查看之前版本'
        select '1', from: 'rollback-selectbox'
        text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
        text.should_not include content
      end

      it "should list versions" do
        within '#current-asset' do
          click_on '查看之前版本'
          has_css?('#asset-link-rollback').should be_false
          find('#rollback-selectbox option').text.should eql '1'
          click_on '取消'
          has_css?('#asset-link-rollback').should be_true
          has_css?('#rollback-selectbox option').should eql be_false
        end
      end

      it "should show file" do
        within '#current-asset' do
          find('#asset-title').text.should eql 'theme.liquid'
          find('#asset-link-rollback').visible?.should be_true
          text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
          text.should include 'html'
        end
      end
=end

    end

=begin
    it "should be index" do
      within '#theme-layout' do # 布局
        find(:xpath, './/li[1]').find('a').text.should eql 'theme.liquid'
      end
      within '#theme-templates' do # 模板
        find(:xpath, './/li[1]').find('a').text.should eql '404.liquid'
      end
      within '#theme-snippets' do # 片段
        find(:xpath, './/li[1]').find('a').text.should eql 'featured-products.liquid'
      end
      within '#theme-assets' do # 附件
        find(:xpath, './/li[1]').find('a').text.should eql 'checkout.css.liquid'
      end
      within '#theme-config' do # 配置
        find(:xpath, './/li[1]').find('a').text.should eql 'settings.html'
      end
    end
=end

  end

end
