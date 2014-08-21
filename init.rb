require 'redmine'
require 'redmine_comments/hooks'

# Little hack for deface in redmine:
# - redmine plugins are not railties nor engines, so deface overrides are not detected automatically
# - deface doesn't support direct loading anymore ; it unloads everything at boot so that reload in dev works
# - hack consists in adding "app/overrides" path of the plugin in Redmine's main #paths
Rails.application.paths["app/overrides"] ||= []
Rails.application.paths["app/overrides"] << File.expand_path("../app/overrides", __FILE__)

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
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.3' if Rails.env.test?
  project_module :issue_tracking do
    permission :view_private_comments, { }
    permission :manage_private_comments, { :issue_comments => [:new, :create, :edit, :update] }
  end
end
