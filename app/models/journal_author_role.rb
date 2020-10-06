class JournalAuthorRole < ActiveRecord::Base
  belongs_to :journal
  belongs_to :role
end
