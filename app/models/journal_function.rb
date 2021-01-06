class JournalFunction < ActiveRecord::Base
  belongs_to :journal
  belongs_to :function
end
