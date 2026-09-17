module RedmineComments::InlineAttachmentsScrubberPatch
  # Images pasted in private notes are attached to the journal, not to the issue
  def initialize(options = {})
    obj = options[:object]
    if obj.is_a?(Journal)
      options = options.merge(attachments: Array(options[:attachments]) + obj.attachments.to_a)
    end
    super(options)
  end
end

# Redmine 7 moved inline attachments parsing from ApplicationHelper to this scrubber
if Redmine::VERSION::MAJOR >= 7
  Redmine::WikiFormatting::InlineAttachmentsScrubber.prepend RedmineComments::InlineAttachmentsScrubberPatch
end
