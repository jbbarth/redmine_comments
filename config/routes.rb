RedmineApp::Application.routes.draw do
  resources :issue_comments, :only => [:new]
end
