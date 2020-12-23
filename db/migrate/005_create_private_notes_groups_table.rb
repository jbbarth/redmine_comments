class CreatePrivateNotesGroupsTable < ActiveRecord::Migration[5.2]
  def change

    if Redmine::Plugin.installed?(:redmine_limited_visibility)

        create_table :private_notes_groups do |t|
          t.integer :group_id
          t.integer :function_id
        end

    end

  end
end
