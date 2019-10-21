class PokemonSkillsController < ApplicationController
  def create
    @skill = PokemonSkill.new(skill_params)
    @selected = Skill.find(@skill.id)
    @skill.pokemon_id = @pokemon.id
    @skill.skill_id = @selected.id
    @skill.current_pp = @selected.max_pp

    if @skill.save
      flash[:success] = "Skill added"
      redirect_to pokemon_path(@pokemon.id)
    else
      render 'new'
    end
  end

  def destroy
    PokemonSkill.find(params[:id]).destroy
    flash[:success] = "Pokemon Skill deleted"
    redirect_to pokemon_path
  end

  private

  def skill_params

    params.require(:pokemon_skill).permit(:pokemon_id, :skill_id, :current_pp)
  end
end
