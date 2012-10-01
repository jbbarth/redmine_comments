require 'mailer'

class Mailer
  def issue_comment_added(comment)
    issue = comment.commented.reload
    redmine_headers 'Project' => issue.project.identifier,
                    'Issue-Id' => issue.id,
                    'Issue-Author' => issue.author.login
    redmine_headers 'Issue-Assignee' => issue.assigned_to.login if issue.assigned_to
    message_id comment
    references issue
    @author = comment.author
    recipients = issue.comment_recipients
    #subject
    s = "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}][#{l(:label_comment).upcase}] "
    s << issue.subject
    @issue = issue
    @comment = comment
    @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue, :anchor => "comment-#{comment.id}")
    mail :to => recipients, :subject => s
  end
end
