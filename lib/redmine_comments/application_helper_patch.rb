require_dependency 'application_helper'

module ApplicationHelper

  def parse_inline_attachments(text, project, obj, attr, only_path, options)
    return if options[:inline_attachments] == false

    # when using an image link, try to use an attachment, if possible
    attachments = options[:attachments] || []
    attachments += obj.attachments if obj.respond_to?(:attachments)

    ## START PATCH
    attachments += obj.standard_attachments_method if obj.respond_to?(:standard_attachments_method)
    ## END PATCH

    if attachments.present?
      text.gsub!(/src="([^\/"]+\.(bmp|gif|jpg|jpe|jpeg|png))"(\s+alt="([^"]*)")?/i) do |m|
        filename, ext, alt, alttext = $1, $2, $3, $4
        # search for the picture in attachments
        if found = Attachment.latest_attach(attachments, CGI.unescape(filename))
          image_url = download_named_attachment_url(found, found.filename, :only_path => only_path)
          desc = found.description.to_s.gsub('"', '')
          if !desc.blank? && alttext.blank?
            alt = " title=\"#{desc}\" alt=\"#{desc}\""
          end
          "src=\"#{image_url}\"#{alt}"
        else
          m
        end
      end
    end
  end

end
