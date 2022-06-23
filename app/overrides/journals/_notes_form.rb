Deface::Override.new :virtual_path => 'journals/_notes_form',
                      :name => 'add-visibility-fields-to-private-note-form',
                      :replace => "erb[loud]:contains(\"form_tag\")",
                      :text => <<'EOS'
  <%= form_tag(journal_path(@journal),
             :remote => request.format.symbol == :js,
             :method => 'put',
             :id => "journal-#{@journal.id}-form") do %>
  <%= render "issue_comments/visibility_form_fields" if @journal.private_notes %>
EOS

Deface::Override.new :virtual_path => 'journals/_notes_form',
                     :name => 'replace-notes-label-with-comment',
                     :replace => "erb[loud]:contains(\"l(:field_private_notes)\")",
                     :text => "<%= l(:field_private_comment) %>"
