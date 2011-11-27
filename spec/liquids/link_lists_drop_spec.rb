#encoding: utf-8
require 'spec_helper'

describe LinkListsDrop do

  let(:shop) { Factory(:user).shop }

  let(:linklists) { LinkListsDrop.new(shop) }

  describe LinkListDrop do # 链接列表

    it 'should get the title' do
      variant = "{{ linklists.main-menu.title }}"
      result = "主菜单"
      liquid(variant).should eql result
    end

    context 'exist' do

      it 'should get links title' do
        variant = "{% for link in linklists.main-menu.links %}<span>{{ link.title }}</span>{% endfor %}"
        result = "<span>首页</span><span>商品列表</span><span>关于我们</span>"
        liquid(variant).should eql result
      end

    end

    context 'missing' do # 链接列表的固定链接不存在

      it 'should get empty links' do
        variant = "{{ linklists.noexist.links.size }}"
        result = "0"
        liquid(variant).should eql result
      end
    end

  end

  describe LinkDrop, f: true do # 链接

    let(:variant) { "{% for link in linklists.main-menu.links %}{{ link.active }} {% endfor %}" } # 首页 商品列表 关于我们

    context '#active' do # 是否为当前链接(关于我们)

      context '#with current url' do # 有传入current url变量

        context '#same' do # 相同

          context '#exactly' do # 完全相同

            it 'should be true' do
              result = "false false true "
              liquid(variant, 'linklists' => linklists, 'current_url' => '/pages/about-us').should eql result
            end

          end

          context '#except' do # 除了

            context '#querystring' do # 除了?后面的部分，其余相同

              it 'should be true' do
                result = "false false true "
                liquid(variant, 'linklists' => linklists, 'current_url' => '/pages/about-us?query=string').should eql result
              end

            end

            context '#anchor' do # 除了#后面的部分，其余相同

              it 'should be true' do
                result = "false false true "
                liquid(variant, 'linklists' => linklists, 'current_url' => '/pages/about-us#anchor=true').should eql result
              end

            end

          end

        end

        context '#different' do # 不同

          it 'should be false' do
            result = "false false false "
            liquid(variant, 'linklists' => linklists, 'current_url' => '/collections').should eql result
          end

        end

      end

      context '#without current url' do # 没有传入current_url变量

        it 'should be false' do
          result = "false false false "
          liquid(variant).should eql result
        end

      end

    end

  end

  private
  def liquid(variant, assign = {'linklists' => linklists})
    Liquid::Template.parse(variant).render(assign)
  end

end
