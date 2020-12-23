class PrivateNotesGroup < ActiveRecord::Base
  belongs_to :group, class_name: "Function"
  belongs_to :function
end
