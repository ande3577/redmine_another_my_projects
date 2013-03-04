require File.expand_path('../../test_helper', __FILE__)

class ProjectsControllerTest < ActionController::TestCase
  fixtures :projects
  fixtures :users
  fixtures :members
  fixtures :user_preferences
  
  def setup
    @user = User.find(2);
    @user_preference = UserPreference.first
  end
  
  # Replace this with your real tests.
  def test_my_projects_as_anon
    get :index, :controller => :projects, :show => 'my_projects' 
    assert_response 302
    assert_redirected_to :controller => :account, :action => :login, :back_url => "http://test.host/projects?show=my_projects"
  end
  
  def test_my_projects_as_user
    @request.session[:user_id] = @user.id
    get :index, :controller => :projects, :show => 'my_projects'
    assert_response 200
    assert_equal @user.projects.size, assigns[:projects].size, "get user's projects"
    assert_equal 'my_projects', assigns[:show]
  end
  
  def test_show_nil
    get :index, :controller => :projects 
    assert_response 200
    assert_equal Project.where(:is_public => true).size, assigns[:projects].size
    assert_equal nil, assigns[:show]
  end
  
  def test_show_nil_as_user
    @request.session[:user_id] = @user.id
    get :index, :controller => :projects 
    assert_response 200
    assert_equal (Project.where(:is_public => true) + @user.projects).uniq.size, assigns[:projects].size, "get all projects is not specified"
    assert_equal nil, assigns[:show]
  end
  
  def test_show_all
    get :index, :controller => :projects, :show => 'all'
    assert_response 200
    assert_equal 'all', assigns[:show]
  end
  
  def test_show_invalid
    get :index, :controller => :projects, :show => 'invalid'
    assert_response 404
  end
  
  def test_show_mine_via_user_setting
    user = @user_preference.user
    @request.session[:user_id] = user
    @user_preference.show_projects = 'my_projects'
    @user_preference.save
    get :index, :controller => :projects
    assert_response 200
    assert_equal 'my_projects', assigns[:show]
  end
  
  def test_show_all_via_user_setting
    user = @user_preference.user
    @request.session[:user_id] = user
    @user_preference.show_projects = 'all'
    @user_preference.save
    get :index, :controller => :projects 
    assert_response 200
    assert_equal 'all', assigns[:show]
  end
  
  def test_show_closed_my_project
    @request.session[:user_id] = @user.id
    @user.projects.first.close
      
    get :index, :controller => :projects, :show => 'my_projects', :closed => '1'
    assert_response 200
    assert_equal @user.projects.size, assigns[:projects].size, "get user's projects"
    assert_equal 'my_projects', assigns[:show]
  end
  
  def test_cache
    @request.session[:user_id] = @user.id
    get :index, :controller => :projects, :show => 'my_projects'
    assert_response 200
    assert_equal @user.projects.size, assigns[:projects].size, "get user's projects"
    assert_equal 'my_projects', assigns[:show]

    get :index, :controller => :projects
    assert_equal @user.projects.size, assigns[:projects].size, "get user's projects"
    assert_equal 'my_projects', assigns[:show]
  end
  
  def test_cache_invalid
    @request.session[:user_id] = @user.id
    get :index, :controller => :projects, :show => 'my_projects'
    assert_response 200
    assert_equal @user.projects.size, assigns[:projects].size, "get user's projects"
    assert_equal 'my_projects', assigns[:show]

    get :index, :controller => :projects, :show => 'invalid'
    assert_response 404
    
    get :index, :controller => :projects
    assert_response 200
    assert_equal @user.projects.size, assigns[:projects].size, "get user's projects"
    assert_equal 'my_projects', assigns[:show]
  end
  
end