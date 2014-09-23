Deface::Override.new :virtual_path  => 'issues/_history',
                     :name          => 'add-container-to-private-notes',
                     :surround  => "div:contains(@id, 'change-')",
                     :text          => <<-EOS
<% if journal.private_notes? %>
  <div class='issue-private-note-container'>
  <%= render_original %>
  </div>
<% else %>
  <%= render_original %>
<% end %>
EOS
