Deface::Override.new :virtual_path => 'journals/_notes_form',
                     :name => 'add-visibility-fields-to-private-note-form',
                     :insert_after => "erb[loud]:contains(\"form_tag\")",
                     :text => <<-EOS
<%= render "issue_comments/visibility_form_fields" %>
EOS
