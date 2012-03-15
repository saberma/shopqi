#encoding: utf-8
require 'spec_helper'

describe Form do

  let(:shop) { Factory(:user_liwh).shop }

  describe Article do

    let(:blog) { shop.blogs.where(handle: 'news').first }

    let(:article) { Article.create title: '文章', shop_id: shop.id, blog_id: blog.id , body_html: '新文章。。。'}

    let(:article_drop) { ArticleDrop.new(article) }

    it 'should get the right form tag' do
      variant = "{% form article %}{% endform %}"
      assign = { 'article' => article_drop }
      Liquid::Template.parse(variant).render(assign).should eql "<form id=\"article-#{article.id}-comment-form\" class=\"comment-form\" method=\"post\" action=\"/blogs/#{article.blog.handle}/#{article.id}/comments\">\n\n</form>"
    end

  end

  describe Customer do

    let(:customer) { Factory :customer_saberma, shop: shop }

    let(:customer_drop) { CustomerDrop.new customer }

    describe 'login form' do

      it 'should be show' do
        variant = "{% form 'customer_login' %} {{ form.errors | default_errors }} {% if form.password_needed %}password{% endif %} {% endform %}"
        assign = { 'customer' => customer_drop }
        result = "<form id=\"customer_login\" method=\"post\" action=\"/account/login\">\n  password \n</form>"
        Liquid::Template.parse(variant).render(assign).should eql result
      end

      context 'from checkout' do # 在结算页面中点击"现在登录"，成功登录后要跳转回结算页面

        it 'should add checkout url input' do
          variant = "{% form 'customer_login' %} {% endform %}"
          assign = { 'customer' => customer_drop, 'params' => { 'checkout_url' => '/cart/abc123' } }
          result = "<form id=\"customer_login\" method=\"post\" action=\"/account/login\">\n<input type='hidden' name='checkout_url' value='/cart/abc123'>\n \n</form>"
          Liquid::Template.parse(variant).render(assign).should eql result
        end

      end

    end

    it 'should show recover customer password form ' do
      variant = "{% form 'recover_customer_password' %} {{ form.errors | default_errors }} {% endform %}"
      assign = { 'customer' => customer_drop }
      result = "<form id=\"recover_customer_password\" method=\"post\" action=\"/account/customer/password\">\n  \n</form>"
      Liquid::Template.parse(variant).render(assign).should eql result
    end

    it 'should show reset customer password form ' do
      variant = "{% form 'reset_customer_password' %} {{ form.errors | default_errors }} {{ form.reset_password_token }}{% endform %}"
      assign = { 'customer' => customer_drop }
      result = "<form id=\"reset_customer_password\" method=\"post\" action=\"/account/customer/password\">\n  mWwSu97pAX6vLJtQbQ4y\n</form>"
      Liquid::Template.parse(variant).render(assign).should eql result
    end

    it 'should show reset customer password form ' do
      variant = "{% form 'regist_new_customer' %} {{ form.errors | default_errors }} {% endform %}"
      assign = { 'customer' => customer_drop }
      result = "<form id=\"regist_new_customer\" method=\"post\" action=\"/account/customer\">\n  \n</form>"
      Liquid::Template.parse(variant).render(assign).should eql result
    end

    it 'should show  customer address new form ' do
      variant = "{% form 'customer_address', customer.new_address %}{% endform %}"
      assign = { 'customer' => customer_drop }
      result = "<form id=\"add_address\" class=\"customer_address edit_address\" method=\"post\" action=\"/account/addresses\">\n\n</form>"
      Liquid::Template.parse(variant).render(assign).should eql result
    end

    it 'should show  customer address edit form ',focus: true do
      variant = "{% form 'customer_address', address %}{% endform %}"
      address = customer.addresses.first
      assign = { 'address' => CustomerAddressDrop.new(address) }
      result = %Q{<form id="address_form_#{address.id}" class="customer_address edit_address" method="post" action="/account/addresses/#{address.id}">\n<input name="_method" type="hidden" value="put" />\n\n</form>}
      Liquid::Template.parse(variant).render(assign).should eql result
    end
  end

  describe Contact do

    it 'should show contact form', f: true do
      variant = "{% form 'contact'%}{% endform %}"
      result = %Q{<form class="contact-form" method="post" action="/contact">\n\n</form>}
      Liquid::Template.parse(variant).render({}).should eql result
    end

  end

end
