require "spec_helper"

describe IssueCommentsController, :type => :controller do
  include ActiveSupport::Testing::Assertions

  fixtures :journals, :journal_details, :users, :projects, :issues, :members, :member_roles, :roles, :enabled_modules, :trackers

  before do
    @request.session[:user_id] = 2
    @issue = Issue.find(1)
    Setting.default_language = 'en'
  end

  context "when new comment is added to issue" do
    it "should forbid an user with incorrect permission" do
      @request.session[:user_id] = 3
      post :create, params: { issue_id: @issue.id, journal: { notes: "my private comment" } }

      expect(response).to have_http_status(403)
    end

    it "should permit an user with correct permission" do
      @request.session[:user_id] = 2
      post :create, params: { issue_id: @issue.id, :journal => { notes: "my private comment" } }

      expect(response).not_to have_http_status(403)
    end

    it "should create a new private comment belonging to the the issue" do
      @request.session[:user_id] = 2
      
      expect {
        post :create, params: { issue_id: @issue.id, :journal => { notes: "my private comment" } }
      }.to change { @issue.journals.count }.by(1)
      
      expect(response).to have_http_status(302)
      expect(@issue.journals.last).to have_attributes(private_notes: true, user_id: 2, notes: "my private comment") 
    end

    it "should attach saved attachments to journal object" do
      set_tmp_attachments_directory
      attachment = Attachment.create!(:file => fixture_file_upload("files/testfile.txt", "text/plain", true), :author_id => 2)

      assert_difference 'Journal.count' do
        assert_no_difference 'JournalDetail.count' do
          assert_no_difference 'Attachment.count' do
            post :create, params: {:issue_id => 1,
                                  :journal => { :notes => "Attachment added", "private_notes"=>"true" },
                                  :attachments => {
                                      'p0' => {
                                          'token' => attachment.token}
                                  }
                                  }, xhr: true
            assert_redirected_to '/issues/1'
          end
        end
      end

      attachment.reload
      assert_equal Journal.last, attachment.container

      journal = Journal.order('id DESC').first
      assert_equal 0, journal.details.size

      original_issue = Issue.find(1)
      expect(original_issue.attachments.size).to eq 0
    end

    # Use a temporary directory for attachment related tests
    def set_tmp_attachments_directory
      Dir.mkdir "#{Rails.root}/tmp/test" unless File.directory?("#{Rails.root}/tmp/test")
      unless File.directory?("#{Rails.root}/tmp/test/attachments")
        Dir.mkdir "#{Rails.root}/tmp/test/attachments"
      end
      Attachment.storage_path = "#{Rails.root}/tmp/test/attachments"
    end
  end
end
