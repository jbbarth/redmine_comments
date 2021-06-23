Deface::Override.new :virtual_path => 'issues/_action_menu',
                     :name => 'add-comment-button-to-issues-show',
                     :insert_after => '.contextual erb[loud]:contains("button_edit")',
                     :text => <<~LINK
                       <% if @issue.editable? && User.current.allowed_to?(:set_notes_private, @project) %>
                         <%= link_to l("label_comment"), new_issue_comment_path(:issue_id => @issue), :remote => true, :class => "icon icon-private-comment" %>
                       <% end %>
LINK
