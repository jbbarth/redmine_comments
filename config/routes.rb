RedmineApp::Application.routes.draw do
  resources :issue_comments, :only => [:new, :create, :edit, :update]
end
