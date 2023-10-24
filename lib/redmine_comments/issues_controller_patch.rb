require_dependency 'issues_controller'

module RedmineComments::IssuesControllerPatch

end

class IssuesController < ApplicationController

  helper :issue_comments
  include IssueCommentsHelper

end
