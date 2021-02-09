module IssueCommentsHelper

  def roles_allowed_to_view_private_notes_from_role_or_function(project)
    Role.joins(:members)
        .where("members.project_id = ?", project.id)
        .uniq
        .select { |role| role.has_permission?(:view_private_notes_from_role_or_function) }
  end

  def user_functions(project, authorized_roles, user)
    user_roles_or_function(Function, project, authorized_roles, user)
  end

  def user_roles(project, authorized_roles, user)
    user_roles_or_function(Role, project, authorized_roles, user)
  end

  def user_roles_or_function(klass, project, authorized_roles, user)
    klass.joins(:members => [:member_roles, :user])
         .where("members.project_id = ?", project.id)
         .where("members.user_id = ?", user.id)
         .where("member_roles.role_id IN (?)", authorized_roles.map(&:id))
         .where("users.status = ? ", Principal::STATUS_ACTIVE).distinct
  end

  def selectable_functions(project, authorized_roles)
    selectable_roles_or_function(Function, project, authorized_roles)
  end

  def selectable_roles(project, authorized_roles)
    selectable_roles_or_function(Role, project, authorized_roles)
  end

  def selectable_roles_or_function(klass, project, authorized_roles)
    klass.joins(:members => [:member_roles, :user])
         .where("members.project_id = ?", project.id)
         .where("member_roles.role_id IN (?)", authorized_roles.map(&:id))
         .where("users.status = ? ", Principal::STATUS_ACTIVE)
         .distinct.sorted
  end

  def default_checked_functions(project, authorized_roles, user, issue)
    last_visible_journal = issue.last_visible_journal_with_roles_or_functions(user) if issue.present?
    last_visible_journal.present? ? last_visible_journal.functions : user_functions(project, authorized_roles, user)
  end

  def default_checked_roles(project, authorized_roles, user)
    last_visible_journal = issue.last_visible_journal_with_roles_or_functions(user) if issue.present?
    last_visible_journal.present? ? last_visible_journal.roles : user_roles(project, authorized_roles, user)
  end

end
