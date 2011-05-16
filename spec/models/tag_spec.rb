# encoding: utf-8
require 'spec_helper'

describe Tag do
  it 'should be split' do
    Tag.split('国产， 手机,智能, TCL').should eql %w(国产 手机 智能 TCL)
  end
end
