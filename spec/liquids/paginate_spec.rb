require 'spec_helper'

describe Paginate do

  let(:shop) { Factory(:user).shop }

  it 'should get current_page' do
    variant = "{% paginate collection.number by 2 %}{{collection.number | size}},{{paginate.current_page}}{% endpaginate %}"
    assign = { 'collection' => NumberDrop.new, 'current_page' => 2 }
    Liquid::Template.parse(variant).render(assign).should eql "2,2"
  end

  it 'should remain the methods' do
    variant = "{% paginate collection.number by 2 %}{{collection.text}}{% endpaginate %}"
    assign = { 'collection' => NumberDrop.new, 'current_page' => 2 }
    Liquid::Template.parse(variant).render(assign).should eql "1128"
  end

  class NumberDrop < Liquid::Drop
    def text
      1128
    end
    def number
      #(1..10).to_a #一定要缓存，否则无法分页
      @number ||= (1..10).to_a
    end
  end

end
