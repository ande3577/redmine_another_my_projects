require_dependency 'my_projects_controller_patch'
require_dependency 'my_projects_helper_patch'
require_dependency 'my_projects_hooks'
require_dependency 'my_projects_user_patch'
require_dependency 'my_projects_project_patch'

Redmine::Plugin.register :redmine_another_my_projects do
  permission :manage_favorites, { :favorite_projects => [:create, :destroy] }, :require => :loggedin
  
  name 'Redmine Another My Projects plugin'
  author 'David S Anderson'
  description 'A plugin to provide a view for only projects the user belongs to'
  version '0.0.1'
  url 'https://github.com/ande3577/redmine_another_my_projects'
  author_url 'https://github.com/ande3577'
end
