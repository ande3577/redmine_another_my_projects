class FavoriteProject < ActiveRecord::Base
  unloadable
  
  belongs_to :user
  belongs_to :project
  
  validates_presence_of :user
  validates_presence_of :project
  validates_uniqueness_of :project_id, :scope => [ :user_id ] 
  
end
