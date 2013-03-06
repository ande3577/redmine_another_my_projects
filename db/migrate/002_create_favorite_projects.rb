class CreateFavoriteProjects < ActiveRecord::Migration
  def change
    create_table :favorite_projects do |t|
      t.integer :user_id
      t.integer :project_id
    end
  end
end
