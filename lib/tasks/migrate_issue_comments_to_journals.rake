namespace :redmine do
  namespace :comments do

    desc "Migrate Issue comments to Journals"
    task :migrate_issue_comments => [:environment] do

      # Migrating issue comments to private notes in journals table
      comments = Comment.where(commented_type: Issue.name)
      comments_count = comments.count
      i = 0

      puts "Migrate"
      Journal.skip_callback(:create, :after, :send_notification)
      comments.each do |comment|
        i += 1
        puts "#{i}/#{comments_count}" if i % 100 == 0
        Journal.create!(journalized_id: comment.commented_id,
                        journalized_type: comment.commented_type,
                        user_id: comment.author_id,
                        notes: comment.comments,
                        created_on: comment.created_on,
                        private_notes: true)
      end
      Journal.set_callback(:create, :after, :send_notification)

      puts "Destroy"
      Comment.where(commented_type: Issue.name).destroy_all

    end

  end
end
