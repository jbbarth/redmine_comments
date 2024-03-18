module RedmineComments
  class Hooks < Redmine::Hook::ViewListener
    # adds our css on each page
    def view_layouts_base_html_head(context)
      stylesheet_link_tag("redmine_comments", :plugin => "redmine_comments") +
        stylesheet_link_tag("font-awesome.min.css", :plugin => "redmine_comments") +
        javascript_include_tag('redmine_comments.js', plugin: 'redmine_comments')
    end
  end

  class ModelHook < Redmine::Hook::Listener
    def after_plugins_loaded(_context = {})
      require_relative 'journals_controller_patch'
      require_relative 'issue_patch'
      require_relative 'attachment_patch'
      require_relative 'application_helper_patch'
      require_relative 'journals_helper_patch'
      require_relative 'issues_controller_patch'
      require_relative 'journal_patch'
    end
  end
end
