require_dependency 'issue'

module RedmineComments::IssuePatch
  # Returns the journals that are visible to user with their index
  # Used to display the issue history
  def visible_journals_with_index(user = User.current)
    result = journals.
      preload(:details).
      preload(:user => :email_address).
      reorder(:created_on, :id).to_a

    result.each_with_index { |j, i| j.indice = i + 1 }

    unless user.allowed_to?(:view_private_notes, project)
      ####
      ## START PATCH
      if user.allowed_to?(:view_private_notes_from_role_or_function, project)
        result.select! do |journal|
          if Redmine::Plugin.installed?(:redmine_limited_visibility)
            visible = (journal.functions & user.functions_for_project(project)).any?
          else
            visible = (journal.roles & user.roles_for_project(project)).any?
          end
          !journal.private_notes? || journal.user == user || visible
        end
      else
        result.select! do |journal|
          !journal.private_notes? || journal.user == user
        end
      end
      ## END PATCH
      ####
    end

    Journal.preload_journals_details_custom_fields(result)
    result.select! { |journal| journal.notes? || journal.visible_details.any? }
    result
  end

  def last_visible_journal_with_roles_or_functions(user = User.current)
    journals = visible_journals_with_index(user)
    journals.select! do |journal|
      if Redmine::Plugin.installed?(:redmine_limited_visibility)
        journal.functions.any?
      else
        journal.roles.any?
      end
    end
    journals.last
  end
end

Issue.prepend RedmineComments::IssuePatch
