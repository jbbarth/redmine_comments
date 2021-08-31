require_dependency 'journals_controller'

class JournalsController

  append_before_action :update_visibility, :only => [:update]
  before_action :get_roles_allowed_to_view, :only => [:edit]

  helper :attachments
  include AttachmentsHelper

  helper :issue_comments
  include IssueCommentsHelper

  private

  def get_roles_allowed_to_view
   @selectable_roles, @checked_roles = get_selectable_checked_roles(@project, @journal, @issue)
  end

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
