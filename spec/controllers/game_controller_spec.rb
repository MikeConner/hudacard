require 'spec_helper'

describe GameController do

  describe "GET 'play'" do
    it "returns http success" do
      get 'play'
      response.should be_success
    end
  end

end
