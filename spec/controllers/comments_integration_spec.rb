require "spec_helper"
require "active_support/testing/assertions"

describe IssueCommentsController, type: :controller do
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
    @request.session[:user_id] = user_jsmith.id
    # Ensure the Manager role has the required permission
    Role.find_by_name('Manager').add_permission!(:set_notes_private)
  end

  describe "GET new" do
    it "renders the comment form successfully" do
      get :new, params: { issue_id: issue.id }

      expect(response).to be_successful
      expect(assigns(:issue)).to eq(issue)
      expect(assigns(:project)).to eq(project)
    end
  end

  describe "POST create" do
    it "creates a comment without advanced options" do
      expect {
        post :create, params: {
          issue_id: issue.id,
          journal: {
            notes: 'Here is a quick note'
          }
        }
      }.to change { issue.journals.reload.size }.by(1)

      expect(response).to redirect_to(issue_path(issue))

      journal = issue.journals.reload.last
      expect(journal.private_notes).to be_truthy
      expect(journal.notes).to eq 'Here is a quick note'
      expect(journal.user).to eq user_jsmith
      expect(journal.roles).to be_empty if Redmine::Plugin.installed?(:redmine_limited_visibility)

      issue.reload
      expect(issue.updated_on).to be > journal.created_on
    end

    if Redmine::Plugin.installed?(:redmine_limited_visibility)
      it "creates a comment with limited visibility by function" do
        Role.find_by_name('Manager').add_permission! :view_private_notes_from_role_or_function
        membership.functions = [function_1, function_2, function_3]

        expect {
          post :create, params: {
            issue_id: issue.id,
            journal: {
              notes: 'Here is a quick note with function visibility',
              visibility: '3' # function_3.id
            }
          }
        }.to change { issue.journals.reload.size }.by(1)

        expect(response).to redirect_to(issue_path(issue))

        journal = issue.journals.last
        expect(journal.private_notes).to be_truthy
        expect(journal.notes).to eq 'Here is a quick note with function visibility'
        expect(journal.roles).to be_empty
        expect(journal.functions).to eq [function_3]
      end
    end
  end

  describe "direct form access" do
    it "allows to add a new comment from the form in a new tab" do
      expect {
        get :new, params: { issue_id: 1 }
        expect(response).to be_successful

        post :create, params: {
          issue_id: issue.id,
          journal: {
            notes: 'test comment in a new tab'
          }
        }

        expect(response).to redirect_to('/issues/1')
      }.to change { issue.journals.reload.size }.by(1)
    end
  end

end
