Deface::Override.new :virtual_path  => 'issues/show',
                     :name          => 'reorder-journals-in-show-issue',
                     :insert_before => 'h2',
                     :text          => <<EOS
<%
  @journals.sort_by!(&:created_on)
  @journals.reverse! if User.current.wants_comments_in_reverse_order?
%>
EOS
Deface::Override.new :virtual_path  => 'issues/show',
                     :name          => 'reorder-journals-in-show-issue_comments_new_form',
                     :insert_after => 'div#history',
                     :text          => <<EOS
<% if @issue.editable? && User.current.allowed_to?(:set_notes_private, @project) %>
  <%=  render "issue_comments/new_form" %>
<% end %>
EOS

