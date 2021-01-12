class CreateJournalFunctionsTable < ActiveRecord::Migration[5.2]
  def change

    if Redmine::Plugin.installed?(:redmine_limited_visibility)
      unless ActiveRecord::Base.connection.table_exists? :journal_functions

        create_table :journal_functions do |t|
          t.belongs_to :journal
          t.belongs_to :function
        end
        add_index :journal_functions, ["journal_id", "function_id"], :name => :unique_journal_function, :unique => true

      end
    end

  end
end
