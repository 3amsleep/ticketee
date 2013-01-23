require "spec_helper"

feature "Signing in" do
  # check if Sign in / Sign up links aren't there
  def no_signign
    page.should_not have_content "Sign in"
    page.should_not have_content "Sign up"
  end

  before do
    FactoryGirl.create(:user, :email => "ticketee@example.com")
  end

  scenario "Signing in via confirmation" do
    open_email "ticketee@example.com", :with_subject => /Confirmation/
    click_first_link_in_email
    page.should have_content "Your account was successfully confirmed"
    page.should have_content "Signed in as ticketee@example.com"
    no_signign
  end

  scenario "Signing in via form" do
    User.find_by_email("ticketee@example.com").confirm!
    visit '/'
    click_link "Sign in"
    fill_in "Email", :with => "ticketee@example.com"
    fill_in "Password", :with => "password"
    click_button "Sign in"
    page.should have_content "Signed in successfully"
    no_signign
  end
end