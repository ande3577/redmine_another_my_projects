module MyProjectsControllerPatch
  def self.included(base)
    unloadable
    
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      before_filter :my_projects, :only => [:index]
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
  end
  
  def my_projects

    @show = params[:show]
    
    if User.current().logged?
      if @show.nil?
        @show = session[:projects_show]
        @show = User.current.pref[:show_projects] if @show.nil?
      else
        session[:projects_show] = @show if show_valid(@show)
      end
    end
    
    if !@show.nil? && @show.eql?('my_projects')
      if User.current().logged?
        respond_to do |format|
          format.html {
            scope = User.current().projects
            unless params[:closed]
              scope = scope.active
            end
            @projects = scope.visible.order('lft').all
            render :index
            return false
          }
        end
      else
        deny_access
        return false
      end
    elsif @show.nil? || @show.eql?('all')
      return true;
    end
    render_404
    return false
  end
  
  private
  def show_valid(show)
    # nil considered valid since it will load the user setting
    return show.nil? || show.eql?('my_projects') || show.eql?('all')
  end
  
end

ProjectsController.send(:include, MyProjectsControllerPatch)