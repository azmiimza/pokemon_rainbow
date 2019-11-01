class PokemonSkillsController < ApplicationController

  def create
   
    @poke_skill = PokemonSkill.new(skill_params)
    
    @selected = Skill.find(params[:skill][:skill_id])
    @poke_skill.pokemon_id = Pokemon.find(params[:pokemon_id]).id
    @poke_skill.current_pp = @selected.max_pp

    if @poke_skill.save
      flash[:success] = "Skill added"
      redirect_to pokemon_path(@poke_skill.pokemon_id)
    else
      flash[:danger] = @poke_skill.errors.full_messages.join(" , ")
      redirect_to pokemon_path(@poke_skill.pokemon_id)
    end
  end

  def destroy
    PokemonSkill.find(params[:pokemon_id]).destroy
    flash[:success] = "Pokemon Skill deleted"
    redirect_to pokemon_path(params[:id])
  end

  private

  def skill_params

    params.require(:skill).permit(:skill_id)
  end
end
