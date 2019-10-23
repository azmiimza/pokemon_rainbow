class PokemonBattlesController < ApplicationController
  def new
    @pokemon_battle = PokemonBattle.new
  end

  def index
    @battles = PokemonBattle.paginate(page: params[:page], per_page: 5)
  end

  def create
    @pokemon_battle = PokemonBattle.new(battle_params)
    @poke_1 = Pokemon.find(@pokemon_battle.pokemon1_id)
    @poke_2 = Pokemon.find(@pokemon_battle.pokemon2_id)

    @pokemon_battle.pokemon1_max_health_point = @poke_1.max_health_point
    @pokemon_battle.pokemon2_max_health_point = @poke_2.max_health_point
  

    if @pokemon_battle.save
      flash[:success] = "Battle created"
      redirect_to pokemon_battle_path(@pokemon_battle.id)
    else
      render 'new'
    end
  end

  def show
    # require 'pry'
    # binding.pry
    @pokemon_battle = PokemonBattle.find(params[:id])
  end

  private
  def battle_params
    params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
  end
end
