require 'redmine'
require 'redmine_comments/hooks'

# Patches to existing classes/modules
ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_comments/issue_patch'
  require_dependency 'redmine_comments/mailer_patch'
end

Redmine::Plugin.register :redmine_comments do
  name 'Redmine Comments plugin'
  description 'Private comments in issues for staff users'
  author 'Jean-Baptiste BARTH'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
  version '0.0.1'
  url 'https://github.com/jbbarth/redmine_comments'
  requires_redmine :version_or_higher => '2.5.0'
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.3' if Rails.env.test?
  project_module :issue_tracking do
    permission :view_private_comments, { }
    permission :manage_private_comments, { :issue_comments => [:new, :create, :edit, :update] }
  end
end
