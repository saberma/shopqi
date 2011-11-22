require 'spec_helper'

describe Theme::ThemesController do

  describe 'robots' do

    it "should be show", focus: true do
      get :robots
      response.should be_success
      response.body.should include 'Disallow'
    end

  end

end
