require 'spec_helper'

include TagFilter
describe TagFilter do

  it 'should get stylesheet_tag' do
    stylesheet_tag('textile.css').should eql "<link href='textile.css' rel='stylesheet' type='text/css' media='all' />"
  end

end
