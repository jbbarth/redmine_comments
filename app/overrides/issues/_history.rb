Deface::Override.new :virtual_path  => 'issues/tabs/_history',
                     :name          => 'add-container-to-private-notes',
                     :surround      => "div:contains(id, 'change-')",
                     :text          => <<-EOS
<% if journal.private_notes? %>
  <div class='issue-private-note-container'>
  <%= render_original %>
  </div>
<% else %>
  <%= render_original %>
<% end %>
EOS

Deface::Override.new :virtual_path => 'issues/tabs/_history',
                     :name         => 'list-attachments-in-notes',
                     :insert_after => "erb[loud]:contains(\"render_notes\")",
                     :partial      => 'issues/list_attachments_in_notes'
