require_dependency 'journal'

class Journal
  acts_as_attachable
  remove_method :attachments

  has_many :journal_roles, dependent: :destroy
  has_many :roles, through: :journal_roles

  if Redmine::Plugin.installed?(:redmine_limited_visibility)
    has_many :journal_functions, dependent: :destroy
    has_many :functions, through: :journal_functions
  end

  def journal_attachments
    Attachment.where(container_id: self.id, container_type: Journal.name)
  end

  def standard_attachments_method
    journalized.respond_to?(:attachments) ? journalized.attachments : []
  end

  # Returns a SQL condition to filter out journals with notes that are not visible to user
  # TODO Take into account new permission and roles
=begin
  def self.visible_notes_condition(user = User.current, options = {})
    global_private_notes_permission = Project.allowed_to_condition(user, :view_private_notes, options)
    by_roles_private_notes_permission = Project.allowed_to_condition(user, :view_private_notes_from_role_or_function, options)
    sql = <<SQL
(#{table_name}.private_notes = ?
OR #{table_name}.user_id = ?
OR (#{global_private_notes_permission})
OR (#{by_roles_private_notes_permission} AND 1=0 ))
SQL
    sanitize_sql_for_conditions([sql, false, user.id])
  end
=end

  def notified_users
    notified = journalized.notified_users
    if private_notes?
      notified_through_roles = notified_users_by_roles_and_functions(notified)
      notified = notified.select { |user| user.allowed_to?(:view_private_notes, journalized.project) }
      notified | notified_through_roles
    else
      notified
    end
  end

  def notified_watchers
    notified = journalized.notified_watchers
    if private_notes?
      notified_through_roles = notified_users_by_roles_and_functions(notified)
      notified = notified.select { |user| user.allowed_to?(:view_private_notes, journalized.project) }
      notified | notified_through_roles
    else
      notified
    end

  end

  def notified_users_by_roles_and_functions(users)
    if Redmine::Plugin.installed?(:redmine_limited_visibility)
      notified_users_by_functions(users)
    else
      notified_users_by_roles(users)
    end
  end

  def notified_users_by_functions(users)
    users.select { |user|
      membership = Member.find_by(project: journalized.project, user: user)
      user.allowed_to?(:view_private_notes_from_role_or_function, journalized.project) &&
        self.functions.any? { |function| membership.present? && membership.functions.include?(function) }
    }
  end

  def notified_users_by_roles(users)
    users.select { |user|
      membership = Member.find_by(project: journalized.project, user: user)
      user.allowed_to?(:view_private_notes_from_role_or_function, journalized.project) &&
        self.roles.any? { |role| membership.present? && membership.roles.include?(role) }
    }
  end

end
