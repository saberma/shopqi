require 'spec_helper'

describe Admin::ShopsHelper do

  describe 'it should return result' do

    before do
      model = mock('request')
      model.stub!(:port_string).and_return(":4000")
      helper.stub!(:request).and_return(model)
    end

    it "should get the expect result" do
      helper.url_with_protocol("myshopqi.lvh.me:4000").should eql "http://myshopqi.lvh.me:4000"
      helper.url_with_protocol("myshopqi").should eql "http://myshopqi.lvh.me:4000"
      helper.url_with_protocol("").should eql ""
      helper.url_with_protocol("http://myshopqi.lvh.me:4000").should eql "http://myshopqi.lvh.me:4000"
      helper.url_with_protocol("https://myshopqi.lvh.me:4000").should eql "https://myshopqi.lvh.me:4000"
    end

  end

end
