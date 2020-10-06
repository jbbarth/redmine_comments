require_dependency 'journal'

class Journal
  acts_as_attachable
  remove_method :attachments

  has_many :journal_author_roles, dependent: :destroy
  has_many :roles, through: :journal_author_roles

  before_save :save_author_roles

  def journal_attachments
    Attachment.where(container_id: self.id, container_type: Journal.name)
  end

  def standard_attachments_method
    journalized.respond_to?(:attachments) ? journalized.attachments : []
  end

  def has_one_of_those_roles?(array_of_roles)
    self.roles.any? {|role| array_of_roles.include?(role) }
  end

  private

  def save_author_roles
    if User.current.present?
      self.roles = User.current.roles_for_project(project)
    end
  end

end
