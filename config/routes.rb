RedmineApp::Application.routes.draw do
  match '/issue_comments/preview', :to => 'issue_comments#preview', :as => 'preview_comment', :via => [:get, :post, :put]
  resources :issue_comments, :only => [:new, :create, :edit, :update]
end
