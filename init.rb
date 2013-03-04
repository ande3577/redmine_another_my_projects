require_dependency 'my_projects_controller_patch'
require_dependency 'my_projects_helper_patch'
require_dependency 'my_projects_hooks'

Redmine::Plugin.register :redmine_another_my_projects do
  name 'Redmine Another My Projects plugin'
  author 'David S Anderson'
  description 'A plugin to provide a view for only projects the user belongs to'
  version '0.0.1'
  url 'https://github.com/ande3577/redmine_another_my_projects'
  author_url 'https://github.com/ande3577'
end
