require "spec_helper"
require "active_support/testing/assertions"

def log_user(login, password)
  visit '/my/page'
  expect(current_path).to eq '/login'

  if Redmine::Plugin.installed?(:redmine_scn)
    click_on("ou s'authentifier par login / mot de passe")
  end

  within('#login-form form') do
    fill_in 'username', with: login
    fill_in 'password', with: password
    find('input[name=login]').click
  end
  expect(current_path).to eq '/my/page'
end

describe "creating new comments", type: :system do
  include ActiveSupport::Testing::Assertions

  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions,
           :workflows

  let!(:project) { Project.find(1) }
  let!(:issue) { Issue.find(1) }
  let!(:user_jsmith) { User.find(2) }
  let!(:membership) { Member.find(1) }

  if Redmine::Plugin.installed?(:redmine_limited_visibility)
    fixtures :functions, :project_functions, :project_function_trackers
    let!(:function_1) { Function.find(1) }
    let!(:function_2) { Function.find(2) }
    let!(:function_3) { Function.find(3) }
    let!(:function_4) { Function.find(4) }
    let!(:function_5) { Function.find(5) }
  end

  before do
    log_user('jsmith', 'jsmith')
  end

  it "creates a comment without advanced options" do
    expect {
      visit '/issues/1'
      click_on "Comment", match: :first
      within 'form#add_comment_form' do
        expect(page).to have_selector(".info", text: "Private comments are only visible with specific roles.")
        expect(page).to_not have_selector(".comment_role")
        fill_in 'journal[notes]', with: 'Here is a quick note'
        click_on 'Add'
      end
    }.to change(issue.journals, :size).by(1)

    journal = issue.journals.last
    expect(journal.private_notes).to be_truthy
    expect(journal.notes).to eq 'Here is a quick note'
    expect(journal.roles).to be_empty if Redmine::Plugin.installed?(:redmine_limited_visibility)

    issue.reload
    expect(issue.updated_on).to be > journal.created_on
  end

  if Redmine::Plugin.installed?(:redmine_limited_visibility)

    it "creates a comment with limited visibility by function" do
      Role.find_by_name('Manager').add_permission! :view_private_notes_from_role_or_function
      membership.functions = [function_1, function_2, function_3]

      expect {
        visit '/issues/1'
        click_on "Comment", match: :first
        within 'form#add_comment_form' do
          expect(page).to have_selector(".info", text: "Private comments are only visible with specific roles.")
          expect(page).to have_selector(".comment_role", text: "function1")
          fill_in 'journal[notes]', with: 'Here is a quick note'
          page.find('.comment_role', text: 'function1').click
          page.find('.comment_role', text: 'function2').click
          click_on 'Add'
        end
      }.to change(issue.journals, :size).by(1)

      journal = issue.journals.last
      expect(journal.private_notes).to be_truthy
      expect(journal.notes).to eq 'Here is a quick note'
      expect(journal.roles).to be_empty
      expect(journal.functions).to eq [function_3]
    end

  end

end
