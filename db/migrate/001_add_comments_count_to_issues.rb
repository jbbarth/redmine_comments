class AddCommentsCountToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :comments_count, :integer, :default => 0, :null => false
  end
end
