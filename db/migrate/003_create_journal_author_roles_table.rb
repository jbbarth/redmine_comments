class CreateJournalAuthorRolesTable < ActiveRecord::Migration[5.2]
  def change
    unless ActiveRecord::Base.connection.table_exists? :journal_author_roles
      create_table :journal_author_roles do |t|
        t.belongs_to :journal
        t.belongs_to :role
      end
      add_index :journal_author_roles, ["journal_id", "role_id"], :name => :unique_journal_author_role, :unique => true
    end
  end
end
