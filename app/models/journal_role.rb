class JournalRole < ActiveRecord::Base
  belongs_to :journal
  belongs_to :role
end
