require 'spec_helper'

describe ShopTheme do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  let(:settings) { theme.config_settings['presets']['default'] }

  before :each do
    theme.switch Theme.find_by_name('Prettify')
  end

  describe ShopThemeSetting do

    describe 'settings.html' do

      it 'should be transform' do
        #http://nokogiri.org/tutorials/modifying_an_html_xml_document.html
        doc = Nokogiri::HTML(File.open(theme.config_settings_path))

        doc.css("input[type='file']").each do |file|
          name = file['name']
          url = "/#{theme.files_relative_path}/assets/#{name}"
          tr = file.parent.parent
          builder = Nokogiri::HTML::Builder.new do
            td {
              div.asset {
                div(class: 'asset-image') {
                  a(class: 'closure-lightbox', href: url) {
                    img(src: '/images/admin/icons/mimes/png.gif')
                  }
                }
                span.note {
                  a(class: 'closure-lightbox', href: url) {
                    text name
                  }
                }
              }
            }
          end
          tr_node = Nokogiri::XML::Node.new 'tr', doc
          tr_node.inner_html = builder.doc.inner_html
          tr.add_next_sibling tr_node
        end
        doc.to_html.should include 'asset-image'
      end

    end

    it 'should parse select element' do
      settings['bg_image_y_position'].should eql 'top'
    end

    it 'should parse checkbox element' do
      settings['use_bg_image'].should eql 'false'
    end

  end

end
