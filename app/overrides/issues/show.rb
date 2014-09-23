Deface::Override.new :virtual_path  => 'issues/show',
                     :name          => 'reorder-journals-in-show-issue',
                     :insert_before => 'h2',
                     :text          => '<% @journals.sort_by!(&:created_on); @journals.reverse! if User.current.wants_comments_in_reverse_order?; %>'
