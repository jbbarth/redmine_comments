#adapted from CommentsController for commenting News
class IssueCommentsController < ApplicationController
  before_filter :find_issue
  before_filter :authorize

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new
    @comment.safe_attributes = params[:comment]
    @comment.author = User.current
    if @issue.comments << @comment
      flash[:notice] = l(:label_comment_added)
      Mailer.issue_comment_added(@comment).deliver
    end
    redirect_to @issue
  end

  private
  # Adapted from IssuesController
  # Also finds the project issues is attached to
  def find_issue
    # Issue.visible.find(...) can not be used to redirect user to the login form
    # if the issue actually exists but requires authentication
    @issue = Issue.includes(:project, :tracker, :status, :author, :priority, :category)
                  .find(params[:issue_id])
    unless @issue.visible?
      deny_access
      return
    end
    @project = @issue.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
