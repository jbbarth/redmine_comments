ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_comments/issue_patch'
end

Redmine::Plugin.register :redmine_comments do
  name 'Redmine Comments plugin'
  description 'Private comments in issues for staff users'
  author 'Jean-Baptiste BARTH'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
  version '0.0.1'
  url 'https://github.com/jbbarth/redmine_base_jquery'
end
