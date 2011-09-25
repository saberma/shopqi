# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Themes", js: true do

  include_context 'login admin'

  let(:shop) do
    model = user_admin.shop
    model.update_attributes password_enabled: false
    model
  end

  describe "GET /themes", focus: true do # 主题管理

    describe "published-themes" do

      before(:each) do
        visit themes_path
      end

      it "should be index" do
        within '#published-themes' do
          page.should have_content(shop.theme.name)
          page.should have_content('已经发布为普通主题')
          find('.heading .main').should have_content('普通')
          page.should have_no_css('.main-actions .preview') # 无预览、删除按钮
          page.should have_no_css('.main-actions .delete-theme')
          page.should have_no_css('.publish-main') # 无发布主题按钮
        end
      end

      it "should go to config and template" do
        within '#published-themes' do
          click_on '外观设置'
        end
        sleep 3 # 延时处理
        page.should have_content('主题外观配置')
        visit themes_path
        within '#published-themes' do
          click_on '模板编辑器'
        end
        sleep 3 # 延时处理
        page.should have_content('没有选择文件')
      end

      it "should be duplicate" do # 复制主题
        within '#unpublished-themes > ul' do
          page.should have_no_xpath('./li[1]')
        end
        within '#published-themes' do
          click_on '复制主题'
        end
        within '#unpublished-themes > ul' do
          page.should have_xpath('./li[1]')
          within :xpath, './li[1]' do
            page.should have_content("副本 #{shop.theme.name}")
            page.should have_no_content('已经发布为普通主题')
          end
        end
      end

      #it "should be export" do # 导出主题(需要结合邮件附件，暂不测试)
      #end

    end

    describe "unpublished-themes" do

      before(:each) do
        @theme = shop.theme
        @new_theme = @theme.switch(Theme.find_by_handle('woodland')) # 加一个未发布的主题
        visit themes_path
      end

      it "should be index" do
        within '#unpublished-themes' do
          page.should have_content(@theme.name)
          page.should have_no_css('.heading .main') # 无role提示
          page.should have_css('.main-actions .preview') # 有预览、删除按钮
          page.should have_css('.main-actions .delete-theme')
        end
      end

      it "should be preview" do # 预览
        within '#unpublished-themes' do
          find('.preview a').click
        end
        sleep 3 # 延时处理
        page.should have_content("主题预览: #{@theme.name}")
      end

      it "should be destroy" do # 删除
        within '#unpublished-themes' do
          page.execute_script("window.confirm = function(msg) { return true; }")
          find('.delete-theme a').click
        end
        page.should have_content('删除成功!')
        within '#unpublished-themes > ul' do
          page.should have_no_xpath('./li[1]')
        end
      end

    end

    describe "upload" do # 上传

      before(:each) do
        visit themes_path
      end

      it "should be upload" do # 删除
        with_resque do
          click_on '上传一个主题'
          attach_file 'file', Rails.root.join('spec', 'factories', 'data', 'themes', 'woodland.zip')
          page.should have_content('正在处理您的主题文件')
          sleep 5 # 延时处理
          page.should have_content('您的主题文件已经上传完成')
          within '#unpublished-themes > ul' do
            page.should have_xpath('./li[1]')
            within :xpath, './li[1]' do
              page.should have_content('woodland')
            end
          end
        end
      end

    end

  end

  describe "GET /settings" do # theme = Threadify

    before(:each) do
      visit settings_theme_path(shop.theme)
    end

    it "should be index" do
      find('#use_logo_image').visible?.should be_true # 只显示第一个fieldset
      find('#use_feature_image').visible?.should be_false # 只显示第一个fieldset
    end

    it "should show image" do
      find('.closure-lightbox').click
      find('.shopqi-dialog').visible?.should be_true
      has_content?('logo.png').should be_true
    end

    describe 'presets' do

      describe 'show' do

        it "should show current preset" do
          find('#theme_load_preset').value.should eql 'original'
        end

        it "should set current settings" do # 配置项初始化为当前预设值
          find('#use_logo_image')['checked'].should be_true
        end

        it "should switch preset" do # 配置项初始化为当前预设值
          uncheck 'use_logo_image'
          check '将当前配置保存为预设'
          fill_in 'theme_save_preset_new', with: 'new_preset'
          click_on '保存配置'
          has_content?('保存成功!').should be_true
          find('#save-preset').visible?.should be_false
          select 'original', from: 'theme_load_preset'
          find('#use_logo_image')['checked'].should be_true
        end

      end

      describe 'save' do

        it "should update exists preset" do # 更新预设
          uncheck 'use_logo_image'
          check '将当前配置保存为预设'
          select 'original', from: 'theme_save_preset_existing'
          find('#theme_save_preset_new_container').visible?.should be_false # 隐藏名称输入项
          click_on '保存配置'
          has_content?('保存成功!').should be_true
          find('#theme_load_preset').value.should eql 'original'
          visit settings_theme_path(shop.theme) # 回显
          find('#theme_load_preset').value.should eql 'original'
          find('#use_logo_image')['checked'].should be_false
        end

        it "should add new preset" do # 保存新的预设
          uncheck 'use_logo_image'
          check '将当前配置保存为预设'
          fill_in 'theme_save_preset_new', with: 'new_preset'
          click_on '保存配置'
          has_content?('保存成功!').should be_true
          find('#save-preset').visible?.should be_false
          find('#theme_load_preset').value.should eql 'new_preset'
          visit settings_theme_path(shop.theme) # 回显
          find('#theme_load_preset').value.should eql 'new_preset'
          find('#use_logo_image')['checked'].should be_false
        end

        it "should switch to customize" do # 切换至定制预设
          find('#theme_load_preset').value.should eql 'original'
          uncheck 'use_logo_image'
          find('#theme_load_preset').value.should be_blank
        end

      end

    end

    describe 'tranform' do

      it "should change name" do
        find('#use_logo_image')['name'].should eql 'settings[use_logo_image]'
      end

      it "should add image widget" do
        has_css?(".asset-image").should be_true
      end

      it "should add hidden checkbox" do
        has_css?("input[name='settings[use_logo_image]']", visible: false).should be_true
      end

      it "should add fonts" do
        find('.section-header', text: 'Fonts').click
        find('#header_font').all('optgroup').size.should eql 3
      end

    end

  end

  describe "GET /assets" do

    before(:each) do
      visit theme_assets_path(shop.theme)
    end

    after(:each) do
      shop.destroy # DatabaseCleaner会将所有数据删除，但不会触发实体的callback，这里需要同时删除相关目录
    end

    describe 'save' do

      describe 'assets' do

        it "should be save" do
          within '#theme-assets' do # 附件
            has_content?('robots.txt').should be_false
          end
          click_on '新增附件'
          click_on '取消'
          click_on '新增附件'
          attach_file 'file', File.join(Rails.root, 'public', 'robots.txt')
          within '#theme-assets' do # 附件
            has_content?('robots.txt').should be_true
          end
        end

        it "should be show" do
          click_on '新增附件'
          attach_file 'file', File.join(Rails.root, 'app', 'assets', 'images', 'spinner.gif')
          within '#current-asset' do
            find('#asset-title').has_content?('spinner.gif').should be_true
            find('#asset-link-rollback').visible?.should be_true # 版本
            find('#asset-link-rename').visible?.should be_true # 重命名
            find('#asset-link-destroy').visible?.should be_true # 删除
            find('#template-editor').visible?.should be_false
            find('#preview-image').visible?.should be_true
          end
        end

      end

      describe 'snippets' do

        it "should be save" do
          within '#theme-snippets' do # 片段
            has_content?('hot-products.liquid').should be_false
          end
          click_on '新增片段'
          click_on '取消'
          click_on '新增片段'
          fill_in 'new_snippet_basename_without_ext', with: 'hot-products'
          click_on '新增片段'
          within '#theme-snippets' do # 片段
            has_content?('hot-products.liquid').should be_true
          end
        end

        it "should be show" do
          click_on '新增片段'
          fill_in 'new_snippet_basename_without_ext', with: 'hot-products'
          click_on '新增片段'
          within '#current-asset' do
            find('#asset-title').has_content?('hot-products.liquid').should be_true
            find('#asset-link-rollback').visible?.should be_true # 版本
            find('#asset-link-rename').visible?.should be_true # 重命名
            find('#asset-link-destroy').visible?.should be_true # 删除
            text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
            text.should be_blank
          end
        end

      end

      describe 'templates' do

        it "should be save" do
          within '#theme-templates' do # 模板
            has_content?('customers/login.liquid').should be_false
          end
          click_on '新增模板'
          click_on '取消'
          click_on '新增模板'
          select 'customers/login', from: 'new-template-selectbox'
          click_on '新增模板'
          within '#theme-templates' do # 模板
            has_content?('customers/login.liquid').should be_true
          end
        end

        it "should be show" do
          click_on '新增模板'
          select 'customers/password', from: 'new-template-selectbox'
          click_on '新增模板'
          within '#current-asset' do
            find('#asset-title').has_content?('customers/password.liquid').should be_true
            find('#asset-link-rollback').visible?.should be_true # 版本
            find('#asset-link-rename').visible?.should be_true # 重命名
            find('#asset-link-destroy').visible?.should be_true # 删除
            text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
            text.should_not be_blank
          end
        end

      end

      describe 'layout' do

        it "should be save" do
          within '#theme-layout' do # 布局
            has_content?('new_theme.liquid').should be_false
          end
          click_on '新增布局'
          click_on '取消'
          click_on '新增布局'
          select 'theme.liquid', from: 'new-layout-selectbox'
          fill_in 'new_layout_basename_without_ext', with: 'new_theme'
          click_on '新增布局'
          within '#theme-layout' do # 布局
            has_content?('new_theme.liquid').should be_true
          end
        end

        it "should be show" do
          click_on 'theme.liquid'
          within '#current-asset' do # 避免下一语句theme_text被赋值为空字符串
            find('#asset-title').has_content?('theme.liquid').should be_true
          end
          theme_text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()')
          click_on '新增布局'
          fill_in 'new_layout_basename_without_ext', with: 'foo_theme'
          click_on '新增布局'
          within '#current-asset' do
            find('#asset-title').has_content?('foo_theme.liquid').should be_true
            find('#asset-link-rollback').visible?.should be_true # 版本
            find('#asset-link-rename').visible?.should be_true # 重命名
            find('#asset-link-destroy').visible?.should be_true # 删除
            text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()')
            puts text.size
            text.should eql theme_text
          end
        end

      end

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
          name = ''
          within '#theme-assets' do # 附件
            name = find('.asset-gif').text
            find('.asset-gif').click
          end
          within '#current-asset' do
            click_on '重命名'
            click_on '关闭' # 可以取消
            click_on '重命名'
            fill_in 'asset-basename-field', with: 'new_name.gif'
            click_on '提交'
            has_css?('#asset-link-rename').should be_true # 延时处理
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
            sleep 3 # 延时处理
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

      it "should be update" do
        within '#current-asset' do # 避免下一语句被赋值为空字符串
          find('#asset-title').has_content?('theme.liquid').should be_true
        end
        text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
        content = 'to be or not to be'
        text.should_not include content
        page.execute_script("TemplateEditor.editor.getSession().setValue('#{content}')");
        click_on '保存'
        find('#asset-info').has_content?('您的文件已经保存.').should be_true
        visit theme_assets_path(shop.theme)
        within '#theme-layout' do # 布局
          find(:xpath, './/li[1]').find('a').click
        end
        within '#current-asset' do # 避免下一语句被赋值为空字符串
          find('#asset-title').has_content?('theme.liquid').should be_true
        end
        text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
        text.should include content
        click_on '查看之前版本'
        select '1', from: 'rollback-selectbox'
        click_on '取消'
        text = page.evaluate_script('TemplateEditor.editor.getSession().getValue()');
        text.should_not include content
      end

      it "should list versions" do
        within '#current-asset' do
          click_on '查看之前版本'
          find('#rollback-selectbox option').text.should eql '1'
          has_css?('#asset-link-rollback').should be_false
          click_on '取消'
          has_css?('#asset-link-rollback').should be_true
          has_css?('#rollback-selectbox').should be_false
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

    end

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

  end

end
