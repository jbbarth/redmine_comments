class AddMissingIndexes < ActiveRecord::Migration[6.1]
  def change
    if Redmine::Plugin.installed?(:redmine_limited_visibility)
      add_index :private_notes_groups, :function_id, if_not_exists: true
      add_index :private_notes_groups, :group_id, if_not_exists: true
    end
  end
end
