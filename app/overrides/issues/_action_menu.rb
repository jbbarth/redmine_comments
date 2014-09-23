Deface::Override.new :virtual_path  => 'issues/_action_menu',
                     :name          => 'add-comment-button-to-issues-show',
                     :insert_after  => '.contextual erb[loud]:contains("button_edit")',
                     :text          => <<-EOS
<% if User.current.allowed_to?(:set_notes_private, @project) %>
<%= link_to "Commenter", edit_issue_path(@issue), :onclick => 'showAndScrollTo("update", "issue_notes");document.getElementById("issue_private_notes").checked = true;return false;', :class => 'icon icon-private-comment', :accesskey => accesskey(:edit) if @issue.editable? %>
<% end %>
EOS
