require "spec_helper"

feature "Signing up" do
  scenario "Successful sign up" do
    visit '/'
    within("nav") do
      click_link "Sign up"
    end
    fill_in "Email", :with => "user@ticketee.com"
    fill_in "user_password", :with => "password"
    fill_in "user_password_confirmation", :with => "password"
    click_button "Sign up"
    page.should have_content "Please open the link to activate your account"
    page.should have_content "Please confirm your account before signing in"
  end
end
