require_dependency 'issues_controller'

class IssuesController < ApplicationController

  before_action :get_roles_allowed_to_view, :only => [:show]

  helper :issue_comments
  include IssueCommentsHelper

  private

  def get_roles_allowed_to_view
    @selectable_roles, @checked_roles = get_selectable_checked_roles(@project, @journal, @issue)
  end

end