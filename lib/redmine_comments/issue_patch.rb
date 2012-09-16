require_dependency 'issue'

class Issue
  # Adds comments to Issues
  has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"
end
