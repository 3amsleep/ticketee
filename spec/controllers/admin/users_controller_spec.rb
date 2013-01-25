require 'spec_helper'

describe Admin::UsersController do
  let(:user) {FactoryGirl.create(:confirmed_user)}

  context "Standard Users" do
    before do
      sign_in(:user, user)
    end

    it "are not able to access the index action" do
      get 'index'
      response.should redirect_to('/')
      flash[:alert].should eql("You must be an admin to do that")
    end
  end
end
