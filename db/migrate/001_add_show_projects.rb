class AddShowProjects < ActiveRecord::Migration
  def up 
    add_column :user_preferences, :show_projects, :string
  end
  def down
    remove_column :user_preferences, :show_projects
  end
end