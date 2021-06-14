require "spec_helper"

describe IssueCommentsController, :type => :controller do
  include ActiveSupport::Testing::Assertions

  fixtures :journals, :journal_details, :users, :projects, :issues, :issue_statuses,
           :members, :member_roles, :roles, :enabled_modules, :trackers, :enumerations

  before do
    @request.session[:user_id] = 2
    Setting.default_language = 'en'
  end

  it "should attach saved attachments to journal object when creating new comment" do
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
