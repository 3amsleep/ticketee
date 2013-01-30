require "spec_helper"

feature "Creating Tickets" do
  before do
    project = FactoryGirl.create(:project, :name => "Internet Explorer")
    user = FactoryGirl.create :confirmed_user, :email => "ticketee@example.com"
    define_permission!(user, :view, project)
    define_permission!(user, :create_tickets, project)
    sign_in_as!(user)

    visit '/'
    click_link "Internet Explorer"
    click_link "New Ticket"

    within("h2") {page.should have_content "New Ticket"}
  end

  scenario "Creating a Ticket" do
    fill_in "Title", :with => "Non-standards compliance"
    fill_in "Description", :with => "My pages are ugly!"
    click_button "Create Ticket"
    page.should have_content("Ticket has been created")
    within("#ticket #author") do
      page.should have_content("Created by ticketee@example.com")
    end
  end

  scenario "Creating a ticket with invalid attributes fails" do
    click_button "Create Ticket"
    page.should have_content("Ticket has not been created")
    page.should have_content("Title can't be blank")
    page.should have_content("Description can't be blank")
  end

  scenario "Description should be longer than 10 chars" do
    fill_in "Title", :with => "Non-standards compliance"
    fill_in "Description", :with => "sucks!"
    click_button "Create Ticket"
    page.should have_content("Ticket has not been created")
  end
end