require 'spec_helper'

feature "Viewing tickets" do
  before do
    user = FactoryGirl.create :user
    textmate_2 = FactoryGirl.build(:project, :name => "TextMate 2")
    FactoryGirl.create(:ticket,
                      :project => textmate_2,
                      :title => "Make it shiny",
                      :description => "Gradients! Starbursts! Oh my!",
                      :user => user)

    internet_explorer = FactoryGirl.build(:project)
    FactoryGirl.create(:ticket,
                      :project => internet_explorer,
                      :title => "Standards compliance",
                      :description => "Isn't a joke.",
                      :user => user)

    visit '/'
  end

  scenario "Viewing Tickets for a given project" do
    click_link "TextMate 2"
    page.should have_content("Make it shiny")
    page.should_not have_content("Standards compliance")

    click_link "Make it shiny"
    within("#ticket h2") do
      page.should have_content("Make it shiny")
    end
    page.should have_content("Gradients! Starbursts! Oh my!")
  end
end