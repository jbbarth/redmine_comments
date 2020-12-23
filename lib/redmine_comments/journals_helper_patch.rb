require_dependency 'journals_helper'

module JournalsHelper
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
        visibility = journal.functions.map(&:name).join(', ')
      else
        visibility = journal.roles.map(&:name).join(', ')
      end
      if visibility.present?
        content_tag('span', "", title: visibility, :id => "journal-#{journal.id}-private_note_visibility", :class => "icon icon-group")
      else
        ""
      end
    else
      ""
    end
  end
end
