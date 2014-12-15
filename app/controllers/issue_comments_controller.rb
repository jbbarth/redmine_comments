class IssueCommentsController < ApplicationController
  before_filter :find_issue
  # before_filter :authorize

  def new
  end

  private

    def find_issue
      # Issue.visible.find(...) can not be used to redirect user to the login form
      # if the issue actually exists but requires authentication
      @issue = Issue.includes(:project, :tracker, :status, :author, :priority, :category).find(params[:issue_id])
      unless @issue.visible?
        deny_access
        return
      end
      @project = @issue.project
    rescue ActiveRecord::RecordNotFound
      render_404
    end
end
