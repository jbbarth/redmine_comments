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

  before do
    log_user('jsmith', 'jsmith')
  end

  let!(:issue_1) { Issue.find(1) }

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
    }.to change(issue_1.journals, :size).by(1)

    journal = issue_1.journals.last
    expect(journal.private_notes).to be_truthy
    expect(journal.notes).to eq 'Here is a quick note'
    expect(journal.roles).to be_empty
  end

end

