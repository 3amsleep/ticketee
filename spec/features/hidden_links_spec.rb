require "spec_helper"

feature "hidden links" do
  let(:user) {FactoryGirl.create(:confirmed_user)}
  let(:admin) {FactoryGirl.create(:admin_user)}
  let(:project) {FactoryGirl.create(:project)}

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
  end

end