require_dependency 'application_helper'

module RedmineComments::ApplicationHelperPatch

  def parse_inline_attachments(text, project, obj, attr, only_path, options)
    return if options[:inline_attachments] == false

    # when using an image link, try to use an attachment, if possible
    attachments = options[:attachments] || []

    ## START PATCH
    ##
    if obj.is_a?(Journal)
      attachments += obj.journalized.attachments if obj.journalized.respond_to?(:attachments)
    end

    attachments += obj.attachments if obj.respond_to?(:attachments)
    attachments += obj.standard_attachments_method if obj.respond_to?(:standard_attachments_method)
    ##
    ## END PATCH

    if attachments.present?
      title_and_alt_re = /\s+(title|alt)="([^"]*)"/i

      text.gsub!(/src="([^\/"]+\.(bmp|gif|jpg|jpe|jpeg|png|webp))"([^>]*)/i) do |m|
        filename, ext, other_attrs = $1, $2, $3

        # search for the picture in attachments
        if found = Attachment.latest_attach(attachments, CGI.unescape(filename))
          image_url = download_named_attachment_url(found, found.filename, :only_path => only_path)
          desc = found.description.to_s.delete('"')

          # remove title and alt attributes after extracting them
          title_and_alt = other_attrs.scan(title_and_alt_re).to_h
          other_attrs.gsub!(title_and_alt_re, '')

          title_and_alt_attrs = if !desc.blank? && title_and_alt['alt'].blank?
                                  " title=\"#{desc}\" alt=\"#{desc}\""
                                else
                                  # restore original title and alt attributes
                                  " #{title_and_alt.map { |k, v| %[#{k}="#{v}"] }.join(' ')}"
                                end
          "src=\"#{image_url}\"#{title_and_alt_attrs} loading=\"lazy\"#{other_attrs}"
        else
          m
        end
      end
    end
  end

end

ApplicationHelper.prepend RedmineComments::ApplicationHelperPatch
ActionView::Base.prepend ApplicationHelper
