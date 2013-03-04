module MyProjectsHelperPatch
  def self.included(base)
    unloadable
    
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :render_project_hierarchy, :view_links
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    def render_project_hierarchy_with_view_links(projects)
      html = ""
      if(User.current.logged?())
        title = '<h3>' + l(:label_project_view) + '</h3>'
        content_for :sidebar do
          if @show.nil? or !@show.eql?('my_projects')
            label = l(:label_view_my_projects)
            show = 'my_projects'
          else
            label = l(:label_view_all_projects)
            show = 'all'
          end
          if params[:closed].nil?
            link = link_to(label, :controller => :projects, :action => :index, :show => show)         
          else
            link = link_to(label, :controller => :projects, :action => :index, :show => show, :closed => '1')
          end
          (title + link).html_safe()
        end
      end
      render_project_hierarchy_without_view_links(projects)
    end
  end
  
end

ProjectsHelper.send(:include, MyProjectsHelperPatch)