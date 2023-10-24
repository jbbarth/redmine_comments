require 'redmine'
require_relative 'lib/redmine_comments/hooks'

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
    permission :view_private_notes_from_role_or_function, {}, :read => true, :require => :member
  end
end
