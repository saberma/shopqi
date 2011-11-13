require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ShopsHelper. For example:
#
# describe ShopsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Admin::ShopsHelper do
  describe 'it should return result' do
    before(:each) do
      request.stub(:port_string).and_return(":4000")
    end
    it "should get the expect result" do
      url_with_protocol("myshopqi.lvh.me:4000").should eql "http://myshopqi.lvh.me:4000"
      url_with_protocol("myshopqi").should eql "http://myshopqi.lvh.me:4000"
      url_with_protocol("").should eql ""
      url_with_protocol("http://myshopqi.lvh.me:4000").should eql "http://myshopqi.lvh.me:4000"
      url_with_protocol("https://myshopqi.lvh.me:4000").should eql "https://myshopqi.lvh.me:4000"
    end
  end
end
