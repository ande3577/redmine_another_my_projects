class MyProjectsHooks < Redmine::Hook::ViewListener
  render_on :view_my_account, :partial => 'account_settings/my_projects_account_settings', :layout => false
  render_on :view_users_form, :partial => 'account_settings/my_projects_account_settings', :layout => false
  render_on :view_projects_show_sidebar_bottom, :partial => 'projects/my_projects_show_sidebar_bottom', :layout => false
end