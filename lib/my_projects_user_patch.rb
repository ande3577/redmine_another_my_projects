if Redmine::VERSION::MAJOR <= 2 && Redmine::VERSION::MINOR <= 2
  require 'project' 
end

module MyProjectsUserPatch
  def self.included(base)
    unloadable
    
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      has_many :favorite_projects
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    def favorite_projects
      Project.visible.where(:id => FavoriteProject.where(:user_id => id).pluck(:project_id))
    end
    
    def is_favorite?(project)
     !Project.visible.where(:id => FavoriteProject.where(:user_id => id, :project_id => project.id).pluck(:project_id)).empty? 
    end
  end
  
  private
  
end

User.send(:include, MyProjectsUserPatch)