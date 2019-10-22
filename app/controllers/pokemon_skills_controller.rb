class PokemonSkillsController < ApplicationController
  def create
    @selected_poke =  Pokemon.find(params[:id])
    @selected_skill = Skill.where(skill_id: params[:skill_id])

    @skill = @selected_poke.skills << @selected_skill
    @skill.current_pp = @selected_skill.max_pp

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
