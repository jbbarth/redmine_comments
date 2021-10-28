Deface::Override.new :virtual_path => 'journals/_notes_form',
                     :name => 'add-visibility-fields-to-private-note-form',
                     :insert_after => "erb[loud]:contains(\"form_tag\")",
                     :text => <<-EOS
<%= render "issue_comments/visibility_form_fields" if @journal.private_notes %>
EOS
# Deface::Override.new :virtual_path => 'journals/_notes_form',
#                      :name => 'add-visibility-fields-to-private-note-form',
#                      :replace => "erb[loud]:contains(\"form_tag\")",
#                      :text => <<'EOS'
# <%= form_tag(journal_path(@journal), :remote => false, :method => 'put', :id => "journal-#{@journal.id}-form") do %>
# EOS