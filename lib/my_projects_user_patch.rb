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
      alias_method_chain :remove_references_before_destroy, :favorites
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
  
  # Favorite projects are destroyed here since dependent => destroy was not working for some reason
  def remove_references_before_destroy_with_favorites
    return remove_references_before_destroy_without_favorites if self.id.nil?
    
    remove_references_before_destroy_without_favorites
    
    FavoriteProject.destroy_all(:user_id => self.id)
  end
  
  private
  
end

User.send(:include, MyProjectsUserPatch)