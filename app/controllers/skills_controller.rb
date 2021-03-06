class SkillsController < ApplicationController
  before_action :breadcrumb

  def new
    @skill = Skill.new
    add_breadcrumb "New Skill"
  end

  def index
    @skills = Skill.reorder("element_type ASC").paginate(page: params[:page], per_page: 5)
  end

  def show
    @skill = Skill.find(params[:id])
    add_breadcrumb "#{@skill.name}"
  end

  def edit
    @skill = Skill.find(params[:id])
    add_breadcrumb "#{@skill.name}", skill_path(params[:id])
    add_breadcrumb "Edit #{@skill.name}"
  end

  def update
    @skill = Skill.find(params[:id])
    if @skill.update_attributes(skill_params)
      flash[:success] = "Skill updated"
      redirect_to skill_path
    else
      render 'edit'
    end
  end

  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      flash[:success] = "#{@skill.name} created"
      redirect_to skill_path(@skill.id)
    else
      render 'new'
    end
  end

  def destroy
    Skill.find(params[:id]).destroy
    flash[:success] = "Skill deleted"
    redirect_to skills_path
  end

  private 

  def breadcrumb
    add_breadcrumb "Skills", skills_path
  end

  def skill_params
    params.require(:skill).permit(:name, :power, :max_pp, :element_type)
  end
end
