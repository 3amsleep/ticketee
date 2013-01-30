require "spec_helper"

feature "hidden links" do
  let(:user) {FactoryGirl.create(:confirmed_user)}
  let(:admin) {FactoryGirl.create(:admin_user)}
  let(:project) {FactoryGirl.create(:project)}
  let!(:ticket) {FactoryGirl.create(:ticket, :project => project, :user => user)}

  def link_path(route)
    if route == "project_path"
      return project_path(project)
    else
      return route
    end
  end

  actions = { :New => "/",
              :Edit => "project_path",
              :Delete => "project_path" }


  # Tests!
  context "Anonymous User" do
    actions.each do |action, route|
        scenario "Cannot see the #{action} Project link" do
          visit link_path(route)
          page.should_not have_link("#{action} Project")
        end
    end
  end

  context "Regular Users" do
    before do
      sign_in_as!(user)
    end

    actions.each do |action, route|
      scenario "Cannot see the #{action} Project link" do
        visit link_path(route)
        page.should_not have_link("#{action} Project")
      end
    end

    # Links are shown with permissions
    scenario "New ticket link is shown to a user with permissions" do
      define_permission!(user, :view, project)
      define_permission!(user, :create_tickets, project)
      visit project_path(project)
      page.should have_link "New Ticket"
    end

    scenario "Edit ticket link is shown to a user with permissions" do
      define_permission!(user, :view, project)
      define_permission!(user, :edit_tickets, project)
      visit project_path(project)
      click_link ticket.title
      page.should have_link "Edit Ticket"
    end

    scenario "Delete ticket link is shown to a user with permissions" do
      define_permission!(user, :view, project)
      define_permission!(user, :delete_tickets, project)
      visit project_path(project)
      click_link ticket.title
      page.should have_link "Delete Ticket"
    end

    # Links are hidden without permissions
    scenario "New ticket link is hidden from a user without permissions" do
      define_permission!(user, :view, project)
      visit project_path(project)
      page.should_not have_link "New Ticket"
    end

    scenario "Edit ticket link is hidden from a user without permissions" do
      define_permission!(user, :view, project)
      visit project_path(project)
      click_link ticket.title
      page.should_not have_link "Edit Ticket"
    end

    scenario "Delete ticket link is shown to a user with permissions" do
      define_permission!(user, :view, project)
      visit project_path(project)
      click_link ticket.title
      page.should_not have_link "Delete Ticket"
    end

  end

  context "Admin Users" do
    before do
      sign_in_as!(admin)
    end

    actions.each do |action, route|
      scenario "Can see the #{action} Project link" do
        visit link_path(route)
        page.should have_link("#{action} Project")
      end
    end

    scenario "New ticket link is shown to admins" do
      visit project_path(project)
      page.should have_link "New Ticket"
    end

    scenario "Edit ticket link is shown to admins" do
      visit project_path(project)
      click_link ticket.title
      page.should have_link "Edit Ticket"
    end

    scenario "Delete ticket link is shown to admins" do
      visit project_path(project)
      click_link ticket.title
      page.should have_link "Delete Ticket"
    end
  end

end