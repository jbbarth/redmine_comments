require "spec_helper"

describe "CommentsMailerPatch" do
  include Redmine::I18n
  include ActionDispatch::Assertions::SelectorAssertions
  fixtures :projects, :enabled_modules, :issues, :users, :members,
           :member_roles, :roles, :documents, :attachments, :news,
           :tokens, :journals, :journal_details, :changesets,
           :trackers, :projects_trackers,
           :issue_statuses, :enumerations, :messages, :boards, :repositories,
           :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions,
           :versions,
           :comments

  before do
    ActionMailer::Base.deliveries.clear
    Setting.host_name = 'mydomain.foo'
    Setting.protocol = 'http'
    Setting.plain_text_mail = '0'
    Role.find(2).add_permission!(:view_private_comments) #dlopper but not jsmith
  end

  it "should issue comment added" do
    issue = Issue.first
    comment = Comment.create!(:commented => issue, :comments => "Blah", :author => User.find(1))

    # Send the email, then test that it got queued
    email = Mailer.issue_comment_added(comment).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    # Test the body of the sent email contains what we expect it to
    user = User.find(3)
    email.bcc.should == [user.mail]
    assert email.subject.match(/COMMENT/)
  end
end
