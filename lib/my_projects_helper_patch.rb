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
          labels = Hash.new
          
          labels['all'] = l(:label_view_all_projects)
          labels['my_projects'] = l(:label_view_my_projects) if User.current.logged?
          labels['favorites'] = l(:label_view_favorites) if User.current.logged? and User.current.allowed_to?(:manage_favorites, nil, {:global => true})
          
          link = ""
          labels.each do |show, label|
            if @show.eql?(show) || ( @show.nil? && show.eql?('all'))
              link += label + "<br />".html_safe
            else
              if params[:closed].nil?
                  link += link_to_unless_current(label, :controller => :projects, :action => :index, :show => show) + "<br />".html_safe       
              else
                  link += link_to_unless_current(label, :controller => :projects, :action => :index, :show => show, :closed => '1') + "<br />".html_safe
              end
            end
          end
          
          (title + link).html_safe()
        end
      end
      render_project_hierarchy_without_view_links(projects)
    end
  end
  
end

ProjectsHelper.send(:include, MyProjectsHelperPatch)