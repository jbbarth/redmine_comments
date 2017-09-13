require 'redmine'
require 'redmine_comments/hooks'

ActionDispatch::Reloader.to_prepare do
  require_dependency 'redmine_comments/journals_controller_patch'
  require_dependency 'redmine_comments/journal_patch'
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
end
