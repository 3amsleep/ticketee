require "spec_helper"

feature "Assigning Permissions" do
  let!(:admin) {FactoryGirl.create :admin_user}
  let!(:user) {FactoryGirl.create :confirmed_user}
  let!(:project) {FactoryGirl.create :project}
  let!(:ticket) {FactoryGirl.create :ticket, :user => user, :project => project}

  before do
    sign_in_as!(admin)

    click_link "Admin"
    click_link "Users"
    click_link user.email
    click_link "Permissions"
  end

  def check_permission_box(permission, object)
    check "permissions_#{object.id}_#{permission}"
  end

  scenario "Viewign a project" do
    check_permission_box "view", project

    click_button "Update"
    click_link "Sign out"

    sign_in_as!(user)
    page.should have_content(project.name)
  end
end