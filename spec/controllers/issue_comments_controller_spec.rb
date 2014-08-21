require "spec_helper"

describe IssueCommentsController do
  render_views
  fixtures :projects, :users, :roles, :members, :member_roles, :issues, :issue_statuses, :versions, :trackers,
           :projects_trackers, :issue_categories, :enabled_modules, :enumerations, :attachments, :workflows,
           :custom_fields, :custom_values, :custom_fields_projects, :custom_fields_trackers, :time_entries,
           :journals, :journal_details

  before do
    @request.session[:user_id] = 1 #=> admin ; permissions are hard...
    Comment.create!(author_id: 1, comments: "First comment", commented: Issue.first)
  end

  context "GET new" do
    it "should fail if format != js" do
      get :new, :issue_id => 1
      assert_response 404
    end

    it "should fail without an issue_id" do
      get :new, :format => :js
      assert_response 404
    end

    it "should succeed if format = js" do
      get :new, :issue_id => 1, :format => :js
      response.should be_success
    end
  end

  context "GET edit" do
    it "should fail if format != js" do
      get :edit, :id => 1
      assert_response 404
    end

    it "should fail without an issue_id" do
      get :edit, :id => 1, :format => :js
      assert_response 404
    end

    it "should succeed if format = js" do
      get :edit, :id => 1, :issue_id => 1, :comment_id => Issue.find(1).comments.last, :format => :js
      response.should be_success
    end
  end

  context "POST create" do
    it "should succeed and assign comment" do
      post :create, :issue_id => 1, :comment => { :comments => "Awesome ticket!" }, :format => :js
      response.should redirect_to(issue_path(1))
      flash[:notice].should == "Comment added"
      Issue.find(1).comments.last.try(:comments).should == "Awesome ticket!"
    end
  end

  context "PUT update" do
    it "should succeed and update comment" do
      comment = Issue.find(1).comments.last
      put :update, :issue_id => 1, :id => 1, :comment_id => comment ,:comment => { :comments => "Awesome updated ticket!" }, :format => :js
      response.should redirect_to(issue_path(1))
      flash[:notice].should == "Comment updated"
      comment.reload.comments.should == "Awesome updated ticket!"
    end
  end

  it "should preview new" do
    string = "New comment description"
    post :preview,
         :comment => {:comments => string}
    response.should be_success
    assert_template 'issue_comments/preview'
    string.should == assigns(:description)
    assert_tag :p, :content => string
  end

  it "should preview edit" do
    string = "Updated comment description"
    put :preview,
         :comment => {:comments => string}
    response.should be_success
    assert_template 'issue_comments/preview'
    string.should == assigns(:description)
    assert_tag :p, :content => string
  end
end
