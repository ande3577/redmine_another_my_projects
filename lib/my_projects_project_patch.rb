module MyProjectsProjectPatch
  def self.included(base)
    unloadable
    
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      has_many :favorite_projects, :dependent => :destroy
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
  end
  
end

Project.send(:include, MyProjectsProjectPatch)