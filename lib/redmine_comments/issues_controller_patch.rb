require_dependency 'issues_controller'

class IssuesController < ApplicationController

  helper :issue_comments
  include IssueCommentsHelper

end
