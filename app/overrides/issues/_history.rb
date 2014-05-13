Deface::Override.new :virtual_path  => 'issues/_history',
                     :name          => 'display-comments-with-journals',
                     :insert_after  => 'erb[silent]:contains("journal in journals")',
                     :text          => '<% if journal.is_a?(Comment) %><%= render :partial => "issue_comments/comment", :locals => { :comment => journal } %><% next; end %>'
