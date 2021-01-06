require_dependency 'journal'

class Journal
  acts_as_attachable
  remove_method :attachments

  has_many :journal_roles, dependent: :destroy
  has_many :roles, through: :journal_roles

  has_many :journal_functions, dependent: :destroy
  has_many :functions, through: :journal_functions

  def journal_attachments
    Attachment.where(container_id: self.id, container_type: Journal.name)
  end

  def standard_attachments_method
    journalized.respond_to?(:attachments) ? journalized.attachments : []
  end

  def has_one_of_these_roles?(array_of_roles)
    self.roles.any? {|role| array_of_roles.include?(role) }
  end

  def has_one_of_these_functions?(array_of_functions)
    self.functions.any? {|f| array_of_functions.include?(f) }
  end

end
