class IssueCommentsController < ApplicationController
  before_filter :find_issue, except: [:destroy_attachment]
  # before_filter :authorize

  def new
  end

  def create
    @journal = Journal.new(:journalized => @issue, :user => User.current, :notes => params[:journal][:notes], :private_notes => true)
    if @journal.save

      @journal.save_attachments(params[:attachments])
      @journal.attach_saved_attachments

      respond_to do |format|
        format.html { redirect_to issue_path(@issue) }
        format.api  { render_api_ok }
      end
    else
      # render_validation_errors(@journal)
      respond_to do |format|
        format.html { redirect_to issue_path(@issue) }
        format.api  { render_validation_errors(@issue) }
      end
    end
  end

  def destroy_attachment
    @attachment = Attachment.find(params[:id])
    @issue = @attachment.container.issue
    if @attachment.container
      # Make sure association callbacks are called
      @attachment.container.attachments.delete(@attachment)
    else
      @attachment.destroy
    end
    respond_to do |format|
      format.html { redirect_to issue_path(@issue) }
      format.api  { render_api_ok }
    end
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
