Deface::Override.new :virtual_path  => 'issues/show',
                     :name          => 'add-comments-to-journals',
                     :insert_before => 'h2',
                     :text          => '<% if User.current.allowed_to?(:view_private_comments, @project); @journals = (@journals + @issue.comments).sort_by(&:created_on); @journals.reverse! if User.current.wants_comments_in_reverse_order?; end %>'
