require_dependency 'attachment'

class Attachment
  def project
    if container.is_a?(Journal)
      container.try(:journalized).try(:project)
    else
      container.try(:project)
    end
  end

  def visible?(user=User.current)
    if container_id
      if container.is_a?(Journal)
        container.issue && container.issue.attachments_visible?(user)
      else
        container && container.attachments_visible?(user)
      end
    else
      author == user
    end
  end

  def editable?(user=User.current)
    if container_id
      if container.is_a?(Journal)
        container.issue && container.issue.attachments_editable?(user)
      else
        container && container.attachments_editable?(user)
      end
    else
      author == user
    end
  end

  def deletable?(user=User.current)
    if container_id
      if container.is_a?(Journal)
        container.issue && container.issue.attachments_editable?(user)
      else
        container && container.attachments_deletable?(user)
      end
    else
      author == user
    end
  end
end
