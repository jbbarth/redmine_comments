require File.dirname(__FILE__) + '/../test_helper'

class IssueTest < ActiveSupport::TestCase
  fixtures :users, :issues, :issue_statuses, :projects, :projects_trackers, :trackers, :enumerations

  test "Issue#comments basic behaviour" do
    issue = Issue.first
    assert_equal [], issue.comments
    assert_equal 0, issue.comments_count
    assert_difference 'issue.comments.count', +1 do
      Comment.create!(:commented => issue, :comments => "Blah", :author => User.find(1))
    end
    issue.reload
    assert_equal 1, issue.comments_count
    assert_equal "Blah", issue.comments.first.comments
  end
end
