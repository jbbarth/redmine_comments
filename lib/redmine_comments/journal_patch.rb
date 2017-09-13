require_dependency 'journal'

class Journal
  acts_as_attachable

  remove_method :attachments

  def journal_attachments
    Attachment.where(container_id: self.id, container_type: Journal)
  end
end
