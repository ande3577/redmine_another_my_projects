class FavoriteProjectsController < ApplicationController
  unloadable
  
  append_before_filter :authorize_global
  append_before_filter :find_project_by_project_id, :only => :create


  def create
    if Project.visible.where(:id => params[:project_id]).first.nil?
      render_403
      return false;
    end
    
    @favorite = FavoriteProject.create(:user => User.current, :project => @project)
    respond_to do |format|
      format.html { redirect_to :controller => :projects, :action => :show, :id => @project.id }
    end
  end

  def destroy
    @favorite = FavoriteProject.where(:id => params[:id]).first unless params[:id].nil?
      
    if @favorite.nil?
      render_404
      return false
    end
    
    if @favorite.user != User.current
      render_403
      return false
    end
    
    @project = @favorite.project
    @favorite.destroy
    
    respond_to do |format|
      format.html { redirect_to :controller => :projects, :action => :show, :id => @project.id }
    end
  end
  
end
