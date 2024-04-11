require_dependency 'journals_helper'

module RedmineComments::JournalsHelperPatch
  def render_private_notes_indicator(journal)
    content = journal.private_notes? ? l(:field_is_private) : ''
    css_classes = journal.private_notes? ? 'badge badge-private private' : ''
    content_tag 'span', :id => "journal-#{journal.id}-private_notes" do
      element = content_tag('span', content.html_safe, :class => css_classes)
      element += private_note_visibility_indicator(journal)
      element
    end
  end

  def private_note_visibility_indicator(journal)
    if journal.private_notes?
      if Redmine::Plugin.installed?(:redmine_limited_visibility)
        roles = journal.functions
      else
        roles = journal.roles
      end
      if roles.present?
        content_tag 'span', id: "journal-#{journal.id}-private_note_visibility", class: "visibility" do
          roles.each do |role|
            concat(content_tag('span', role.name, class: "comment_role light-bg disabled"))
          end
        end
      else
        ""
      end
    else
      ""
    end
  end
end

JournalsHelper.prepend RedmineComments::JournalsHelperPatch
ActionView::Base.send(:include, JournalsHelper)
