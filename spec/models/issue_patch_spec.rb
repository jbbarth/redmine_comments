require "spec_helper"

describe Issue do

  fixtures :users, :roles, :projects, :members, :member_roles, :issues, :issue_statuses,
           :trackers, :enumerations, :custom_fields, :enabled_modules,
           :journals, :journal_details

  let!(:user_jsmith) { User.find(2) }
  let!(:issue) { Issue.find(1) }
  let!(:manager) { Role.find(1) }
  let!(:private_note) { Journal.create(notes: "Just a private note",
                                       journalized: issue,
                                       user_id: 1,
                                       private_notes: true) }

  if Redmine::Plugin.installed?(:redmine_limited_visibility)
    let!(:contractor_role) { Function.where(name: "Contractors").first_or_create }
    let!(:project_office_role) { Function.where(name: "Project Office").first_or_create }

    describe "journal visibility by functions" do

      it "does not change PUBLIC notes visibility" do
        manager.remove_permission!(:view_private_notes)

        expect(issue.visible_journals_with_index(user_jsmith).size).to eq 2
        expect(issue.visible_journals_with_index(user_jsmith).sort_by(&:id)).to eq issue.journals.where(private_notes: false).sort_by(&:id)
      end

      it "displays private notes if member has standard permission" do
        manager.add_permission!(:view_private_notes)

        expect(issue.visible_journals_with_index(user_jsmith).size).to be 3
        expect(issue.visible_journals_with_index(user_jsmith).sort_by(&:id)).to eq issue.journals.sort_by(&:id)
      end

    end

  end

end
