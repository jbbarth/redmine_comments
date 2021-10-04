module IssueCommentsHelper

  def roles_allowed_to_view_private_notes_from_role_or_function(project)
    Role.joins(:members)
        .where("members.project_id = ?", project.id)
        .uniq
        .select { |role| role.has_permission?(:view_private_notes_from_role_or_function) || role.has_permission?(:view_private_notes) }
  end

  def get_selectable_checked_roles(project, journal, issue)
    authorized_roles = roles_allowed_to_view_private_notes_from_role_or_function(project)

    if Redmine::Plugin.installed?(:redmine_limited_visibility)
      user_roles = user_functions(project, authorized_roles, User.current)
      checked_roles = journal.present? ? journal.functions : default_checked_functions(project, authorized_roles, User.current, issue)
      selectable_roles = selectable_functions(project, authorized_roles)
      functions_allowed_by_private_notes_groups = PrivateNotesGroup.where(group_id: user_roles.map(&:id)).map(&:function)
      selectable_roles = selectable_roles & (functions_allowed_by_private_notes_groups | checked_roles) if functions_allowed_by_private_notes_groups.present?
    else
      user_roles = user_roles(project, authorized_roles, User.current)
      checked_roles = journal.present? ? journal.roles : default_checked_roles(project, authorized_roles, User.current, issue)
      selectable_roles = selectable_roles(project, authorized_roles)
     end

    selectable_roles = selectable_roles | checked_roles | user_roles
    return selectable_roles, checked_roles
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

  def default_checked_roles(project, authorized_roles, user, issue)
    last_visible_journal = issue.last_visible_journal_with_roles_or_functions(user) if issue.present?
    last_visible_journal.present? ? last_visible_journal.roles : user_roles(project, authorized_roles, user)
  end

end
