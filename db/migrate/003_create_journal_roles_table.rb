class CreateJournalRolesTable < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists? :journal_roles
      create_table :journal_roles do |t|
        t.belongs_to :journal
        t.belongs_to :role
      end
      add_index :journal_roles, ["journal_id", "role_id"], :name => :unique_journal_role, :unique => true
    end
  end

  def down
    remove_index :journal_author_roles, name: :unique_journal_author_role
    drop_table :journal_author_roles
  end
end
