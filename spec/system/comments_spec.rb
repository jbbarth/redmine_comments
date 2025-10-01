require "spec_helper"
require "active_support/testing/assertions"

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

      expect(page).to have_css('form#add_issue_comment_form') # Waiting for the form to disappear

      within 'form#add_issue_comment_form' do
        expect(page).to have_selector(".info", text: "Private comments are only visible with specific roles.")
        expect(page).to_not have_selector(".comment_role")
        fill_in 'journal[notes]', with: 'Here is a quick note'
        click_on 'Add'
      end
      expect(page).to have_no_css('form#add_issue_comment_form') # Waiting for the form to disappear
    }.to change { issue.journals.reload.size }.by(1)

    journal = issue.journals.reload.last
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
        within 'form#add_issue_comment_form' do
          expect(page).to have_selector(".info", text: "Private comments are only visible with specific roles.")
          expect(page).to have_selector(".comment_role", text: "function1")
          fill_in 'journal[notes]', with: 'Here is a quick note'
          page.find('.comment_role', text: 'function1').click
          page.find('.comment_role', text: 'function2').click
          click_on 'Add'
        end
      }.to change { issue.journals.reload.size }.by(1)

      journal = issue.journals.last
      expect(journal.private_notes).to be_truthy
      expect(journal.notes).to eq 'Here is a quick note'
      expect(journal.roles).to be_empty
      expect(journal.functions).to eq [function_3]
    end

    it "should not confuse the roles in the case of opening and edit multi comments" do
      Role.find_by_name('Manager').add_permission! :view_private_notes_from_role_or_function
      Role.find_by_name('Manager').add_permission! :edit_issue_notes
      membership.functions = [function_1, function_2, function_3, function_4]

      journal_ids = []
      3.times do |i|
        journal = Journal.create(:journalized => issue,
                                 :user => user_jsmith,
                                 :notes => "test#{i + 1}",
                                 :private_notes => true)

        # set for journal[0] (function1), journal[1] (function2), journal[2] (function3)
        journal.function_ids = [i + 1]
        journal_ids.push(journal.id)
      end

      visit '/issues/1?tab=notes'

      3.times do |i|
        click_link('Edit', :href => "/journals/#{journal_ids.reverse[i]}/edit")
      end

      # set for the  third journal (function1,function2), set for the second journal (function3), set for the first journal (function3, function4)
      3.times do |i|
        journal_id = journal_ids.reverse[i]
        2.times do |j|
          role_id = i + j +1
          page.find('span[data-role-id="' + role_id.to_s + '"][data-journal-id="' + journal_id.to_s + '"]').click
        end
      end

      # Make sure the journal[0] has (function1,function3, function4), the journal[1] has (function2,function3),the journal[2] has (function1,function2,function3)
      all('input[name="commit"]')[2].click
      find("#journal-#{journal_ids[2]}-notes", visible: true, wait: 10)

      all('input[name="commit"]')[1].click
      find("#journal-#{journal_ids[1]}-notes", visible: true, wait: 10)

      page.find('input[name="commit"]').click
      find("#journal-#{journal_ids[0]}-notes", visible: true, wait: 10)

      expect(Journal.find(journal_ids[2]).functions.sort).to eq [function_1, function_2, function_3]
      expect(Journal.find(journal_ids[1]).functions.sort).to eq [function_2, function_3]
      expect(Journal.find(journal_ids[0]).functions.sort).to eq [function_1, function_3, function_4]

    end
  end

  it "allows to add a new comment from the form in a new tab" do
    expect {
      visit 'issue_comments/new?issue_id=1'
      fill_in 'journal[notes]', with: 'test comment in a new tab'

      click_button 'commit'

      expect(page).to have_current_path('/issues/1', wait: true)
    }.to change { issue.journals.reload.size }.by(1)
  end

  it "allows to right click on the comment link to open the form in a new tab" do
    Role.find(1).add_permission!(:edit_issue_notes)
    editnote_text = 'test edit comment'

    visit 'journals/1/edit'
    within 'form#journal-1-form' do
      fill_in 'journal[notes]', with: editnote_text
    end
    click_button 'commit'

    expect(page).to have_current_path('/issues/1', wait: true)

    expect(Journal.find(1).notes).to eq editnote_text
  end

end
