require_dependency 'issue'

class Issue

  # Returns the journals that are visible to user with their index
  # Used to display the issue history
  def visible_journals_with_index(user=User.current)
    result = journals.
        preload(:details).
        preload(:user => :email_address).
        reorder(:created_on, :id).to_a

    result.each_with_index {|j,i| j.indice = i+1}

    unless user.allowed_to?(:view_private_notes, project)
      ####
      ## START PATCH
      if user.allowed_to?(:view_private_notes_from_members_with_same_role, project)
        result.select! do |journal|
          !journal.private_notes? || journal.user == user || journal.has_one_of_those_roles?(user.roles_for_project(project))
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
    result.select! {|journal| journal.notes? || journal.visible_details.any?}
    result
  end

end
