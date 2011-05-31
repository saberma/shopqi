require 'spec_helper'

describe Theme do

  it 'should get default' do
    Theme.default.should_not be_nil
  end

end
