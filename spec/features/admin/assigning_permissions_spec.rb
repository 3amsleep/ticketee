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

  scenario "Creating tickets for a project" do
    check_permission_box :view, project
    check_permission_box :create_tickets, project
    click_button "Update"
    click_link "Sign out"

    sign_in_as!(user)
    click_link project.name
    click_link "New Ticket"
    fill_in "Title", :with => "Shiny!"
    fill_in "Description", :with => "Make it so!"
    click_button "Create"

    page.should have_content("Ticket has been created")
  end

  scenario "Updating a ticket for a project" do
    check_permission_box :view, project
    check_permission_box :edit_tickets, project
    click_button "Update"
    click_link "Sign out"

    sign_in_as!(user)
    click_link project.name
    click_link ticket.title
    click_link "Edit Ticket"
    fill_in "Title", :with => "Really shiny!"
    click_button "Update Ticket"

    page.should have_content("Ticket has been updated")
  end

  scenario "Deleting a ticket for a project" do
    check_permission_box :view, project
    check_permission_box :delete_tickets, project
    click_button "Update"
    click_link "Sign out"

    sign_in_as!(user)
    click_link project.name
    click_link ticket.title
    click_link "Delete Ticket"

    page.should have_content("Ticket has been deleted")
  end
end