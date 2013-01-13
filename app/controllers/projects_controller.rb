class ProjectsController < ApplicationController
  def index
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    p params
    if @project.save
      redirect_to @project,
        :notice => "Project has been created."
    else
      #nyet
    end
  end

  def show
    @project = Project.find(params[:id])
  end
end
