Deface::Override.new :virtual_path  => 'issues/show',
                     :name          => 'reorder-journals-in-show-issue',
                     :insert_before => 'h2',
                     :text          => <<EOS
<%
  @journals.order('created_on');
  @journals.reverse! if User.current.wants_comments_in_reverse_order?;
%>
EOS
