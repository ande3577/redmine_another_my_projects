require File.expand_path('../../test_helper', __FILE__)

class FavoriteProjectsControllerTest < ActionController::TestCase
  fixtures :projects
  fixtures :users
  fixtures :roles
  fixtures :members
  fixtures :member_roles
  
  def setup
    @user = User.find(3)
    @project = @user.projects.first
    @public_project = Project.find(6)
    @invisible_project = Project.find(5)
    @role = @user.roles_for_project(@project).first
  end
  
  def test_create_as_anon
    post :create, :controller => :favorite_projects, :project_id => @project.id 
    assert_response 302
    assert_redirected_to :controller => :account, :action => :login, :back_url => "http://test.host/favorites/create/#{@project.id}"
  end
  
  def test_create_without_permission
    @request.session[:user_id] = @user.id
    post :create, :controller => :favorite_projects, :project_id => @project.id 
    assert_response 403
  end
  
  def test_create_with_invalid_poject
    @request.session[:user_id] = @user.id
    @role.add_permission!(:manage_favorites)
    post :create, :controller => :favorite_projects, :project_id => 99
    assert_response 404
  end
  
  def test_create_with_invisible_project
    @request.session[:user_id] = @user.id
    @role.add_permission!(:manage_favorites)
    post :create, :controller => :favorite_projects, :project_id => @invisible_project.id
    assert_response 403
  end
  
  def test_create_with_permission
    @request.session[:user_id] = @user.id
    @role.add_permission!(:manage_favorites)
    post :create, :controller => :favorite_projects, :project_id => @project.id
    assert_response 302
    assert_redirected_to :controller => :projects, :action => :show, :id=>@project.id
    assert assigns[:favorite]
    assert_equal assigns[:favorite].user_id, @user.id
    assert_equal assigns[:favorite].project_id, @project.id
  end
  
  def test_create_with_public_permission
    @request.session[:user_id] = @user.id
    @role.add_permission!(:manage_favorites)
    post :create, :controller => :favorite_projects, :project_id => @public_project.id
    assert_response 302
    assert_redirected_to :controller => :projects, :action => :show, :id=>@public_project.id
    assert assigns[:favorite]
    assert_equal assigns[:favorite].user_id, @user.id
    assert_equal assigns[:favorite].project_id, @public_project.id
  end
  
  def test_create_existing
    @favorite = FavoriteProject.create(:user => @user, :project => @project)
    assert_equal 1, FavoriteProject.count
    @request.session[:user_id] = @user.id
    @role.add_permission!(:manage_favorites)
    post :create, :controller => :favorite_projects, :project_id => @project.id
    assert_response 302
    assert_redirected_to :controller => :projects, :action => :show, :id=>@project.id
    assert_equal 1, FavoriteProject.count
  end
  
  def test_delete_as_anon
    @favorite = FavoriteProject.create(:user => @user, :project => @project)
    delete :destroy, :controller => :favorite_projects, :id => @favorite.id 
    assert_response 302
    assert_redirected_to :controller => :account, :action => :login, :back_url => "http://test.host/favorites/delete/#{@favorite.id}"
  end
  
  def test_delete_without_permission
    @favorite = FavoriteProject.create(:user => @user, :project => @project)
    @request.session[:user_id] = @user.id
    delete :destroy, :controller => :favorite_projects, :id => @favorite.id 
    assert_response 403
  end
  
  def test_delete_with_permission
    @favorite = FavoriteProject.create(:user => @user, :project => @project)
    @request.session[:user_id] = @user.id
    @role.add_permission!(:manage_favorites)
    
    assert_equal 1, FavoriteProject.count
    delete :destroy, :controller => :favorite_projects, :id => @favorite.id
    assert_redirected_to :controller => :projects, :action => :show, :id=>@project.id
    assert_equal 0, FavoriteProject.count
  end
  
  def test_delete_non_existing
     @request.session[:user_id] = @user.id
     @role.add_permission!(:manage_favorites)
     
     delete :destroy, :controller => :favorite_projects, :id => 99
     assert_response 404
  end
  
  def test_delete_as_wrong_user
    @favorite = FavoriteProject.create(:user => @user, :project => @project)
    @request.session[:user_id] = User.find(2)
    @role.add_permission!(:manage_favorites)
    
    assert_equal 1, FavoriteProject.count
    delete :destroy, :controller => :favorite_projects, :id => @favorite.id
    assert_response 403
  end
end
