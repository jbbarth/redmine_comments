require 'redmine'
require 'redmine_comments/hooks'

ActiveSupport::Reloader.to_prepare do
  require_dependency 'redmine_comments/journals_controller_patch'
  require_dependency 'redmine_comments/journal_patch'
  require_dependency 'redmine_comments/issue_patch'
  require_dependency 'redmine_comments/attachment_patch'
  require_dependency 'redmine_comments/application_helper_patch'
end

Redmine::Plugin.register :redmine_comments do
  name 'Redmine Comments plugin'
  description 'Better private notes in issues for staff users'
  author 'Jean-Baptiste BARTH'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
  version '0.0.2'
  url 'https://github.com/jbbarth/redmine_comments'
  requires_redmine :version_or_higher => '2.5.0'
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?

  project_module :issue_tracking do
    permission :view_private_notes_from_members_with_same_role, {}, :read => true, :require => :member
  end
end
