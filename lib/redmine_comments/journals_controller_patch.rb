require_dependency 'journals_controller'

class JournalsController

  append_before_action :update_visibility, :only => [:update]

  helper :attachments
  include AttachmentsHelper

  helper :issue_comments
  include IssueCommentsHelper

  def edit
    (render_403; return false) unless @journal.editable_by?(User.current)
    respond_to do |format|
      format.html { render :template => "journals/edit_journal" }
      format.js
    end
  end

  private

  def update_visibility
    visibility_params = params[:journal][:visibility]
    if visibility_params.present?
      visibility_ids = visibility_params.split('|').map(&:to_i)
      if Redmine::Plugin.installed?(:redmine_limited_visibility)
        @journal.function_ids = visibility_ids
      else
        @journal.role_ids = visibility_ids
      end
    end
  end

end
