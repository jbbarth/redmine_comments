Deface::Override.new :virtual_path  => 'issues/_action_menu',
                     :name          => 'add-comment-button-to-issues-show',
                     :insert_after  => '.contextual erb[loud]:contains("button_update")',
                     :text          => '<% if User.current.allowed_to?(:manage_private_comments, @project) %><%= link_to "Commenter", new_issue_comment_path(:issue_id => @issue), :remote => true, :class => "icon icon-private-comment" %><% end %>'
