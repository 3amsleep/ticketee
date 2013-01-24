require 'spec_helper'

describe ProjectsController do
  let(:user) {FactoryGirl.create(:confirmed_user)}
  let(:project) {mock_model(Project, :id => 1)}

  context "standard users" do
    before do
      sign_in(:user,user)
    end

    { :new => :get,
      :create => :post,
      :edit => :get,
      :update => :put,
      :destroy => :delete }.each do |action, method|
        it "cannot access the #{action} action" do
          send(method, action, :id => project.id)
          response.should redirect_to('/')
          flash[:alert].should == "You must be an admin to do that"
        end
    end
  end

  it "displays an error for a missing project" do
    get :show, :id => "not-here"
    response.should redirect_to(projects_path)
    flash[:alert].should == "The project you were looking for could not be found"
  end

end
