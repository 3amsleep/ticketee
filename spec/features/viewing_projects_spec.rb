require 'spec_helper'

feature "Viewing Projects" do
  let!(:user) {FactoryGirl.create(:confirmed_user)}
  let!(:project) {FactoryGirl.create(:project)}
  let!(:project_2) {FactoryGirl.create(:project, :name => "Internet Explorer")}

  before do
    define_permission!(user, :view, project)
    sign_in_as!(user)
  end

  scenario "Listing all Projects" do
    visit '/'
    page.should_not have_content project_2.name
    click_link project.name
    page.current_url.should == project_url(project)
  end
end