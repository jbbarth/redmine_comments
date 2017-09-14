RedmineApp::Application.routes.draw do
  resources :issue_comments, :only => [:new, :create]
  delete 'issue_comments/destroy_attachment/:id(:.:format)', :to => 'issue_comments#destroy_attachment'
end
