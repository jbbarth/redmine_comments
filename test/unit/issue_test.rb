require File.dirname(__FILE__) + '/../test_helper'

class IssueTest < ActiveSupport::TestCase
  fixtures :users, :issues, :issue_statuses, :projects, :projects_trackers, :trackers, :enumerations

  test "Issue#comments"
end
