require File.expand_path('../../test_helper', __FILE__)

class IssueCommentsControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :members, :member_roles, :issues, :issue_statuses, :versions, :trackers,
           :projects_trackers, :issue_categories, :enabled_modules, :enumerations, :attachments, :workflows,
           :custom_fields, :custom_values, :custom_fields_projects, :custom_fields_trackers, :time_entries,
           :journals, :journal_details

  setup do
    @request.session[:user_id] = 1 #=> admin ; permissions are hard...
    Comment.create!(author_id: 1, comments: "First comment", commented: Issue.first)
  end

  context "GET new" do
    should "fail if format != js" do
      get :new, :issue_id => 1
      assert_response 404
    end

    should "fail without an issue_id" do
      get :new, :format => :js
      assert_response 404
    end

    should "succeed if format = js" do
      get :new, :issue_id => 1, :format => :js
      assert_response :success
    end
  end

  context "GET edit" do
    should "fail if format != js" do
      get :edit, :id => 1
      assert_response 404
    end

    should "fail without an issue_id" do
      get :edit, :id => 1, :format => :js
      assert_response 404
    end

    should "succeed if format = js" do
      get :edit, :id => 1, :issue_id => 1, :comment_id => Issue.find(1).comments.last, :format => :js
      assert_response :success
    end
  end

  context "POST create" do
    should "succeed and assign comment" do
      post :create, :issue_id => 1, :comment => { :comments => "Awesome ticket!" }, :format => :js
      assert_redirected_to issue_path(1)
      assert_equal "Comment added", flash[:notice]
      assert_equal "Awesome ticket!", Issue.find(1).comments.last.try(:comments)
    end
  end

  context "PUT update" do
    should "succeed and update comment" do
      comment = Issue.find(1).comments.last
      put :update, :issue_id => 1, :id => 1, :comment_id => comment ,:comment => { :comments => "Awesome updated ticket!" }, :format => :js
      assert_redirected_to issue_path(1)
      assert_equal "Comment updated", flash[:notice]
      assert_equal "Awesome updated ticket!", comment.reload.comments
    end
  end
end
