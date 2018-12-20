class AddCommentsCountToIssues < ActiveRecord::Migration[4.2]
  def change
    add_column :issues, :comments_count, :integer, :default => 0, :null => false
  end
end
