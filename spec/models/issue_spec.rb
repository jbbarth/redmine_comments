require "spec_helper"
require "active_support/testing/assertions"

describe "Issue" do
  include ActiveSupport::Testing::Assertions
  fixtures :users, :issues, :issue_statuses, :projects, :projects_trackers, :trackers, :enumerations

  it "should Issue#comments basic behaviour" do
    issue = Issue.first
    issue.comments.should == []
    issue.comments_count.should == 0
    assert_difference 'issue.comments.count', +1 do
      Comment.create!(:commented => issue, :comments => "Blah", :author => User.find(1))
    end
    issue.reload
    issue.comments_count.should == 1
    issue.comments.first.comments.should == "Blah"
  end
end
