require File.expand_path('../../test_helper', __FILE__)

class UserTest < ActiveSupport::TestCase
  fixtures :projects
  fixtures :users
  fixtures :roles
  fixtures :members
  fixtures :member_roles
  
  def setup
    @user = User.find(3)
    @project = @user.projects.first
    @invisible_project = Project.find(5)
    @public_project = Project.find(6)
    @role = @user.roles_for_project(@project).first
  end
  
  def test_favorites
    FavoriteProject.create(:user => @user, :project => @project)
    FavoriteProject.create(:user => @user, :project => @public_project)
    FavoriteProject.create(:user => @user, :project => @invisible_project)
    
    assert_equal 2, @user.favorite_projects.size
    assert_equal @project, @user.favorite_projects.first
  end
  
  def test_destroy_user
    FavoriteProject.create(:user => @user, :project => @project)
    
    id = @user.id
    @user.destroy
    assert FavoriteProject.where(:user_id => id).empty?
  end
  
  def test_destroy_project # tested here since test setup is complete, and I'm too lazy to create a whole new test module
    FavoriteProject.create(:user => @user, :project => @project)
    
    id = @project.id
    @project.destroy
    assert FavoriteProject.where(:project_id => id).empty?  
  end
  
  def test_is_not_favorite
    assert !@user.is_favorite?(@project)
  end
  
  def test_is_not_favorite_invisible
    FavoriteProject.create(:user => @user, :project => @invisible_project)
    assert !@user.is_favorite?(@invisible_project)
  end
  
  def test_is_favorite
    @favorite = FavoriteProject.create(:user => @user, :project => @project)
    assert @user.is_favorite?(@project)
  end
  
  def test_is_favorite_public
    @favorite = FavoriteProject.create(:user => @user, :project => @public_project)
    assert @user.is_favorite?(@public_project)
  end
  
end