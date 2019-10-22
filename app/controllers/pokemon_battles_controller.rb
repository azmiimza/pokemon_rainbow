class PokemonBattlesController < ApplicationController
  def new
    @battle = PokemonBattle.new
  end

  def index
    @battles = PokemonBattle.paginate(page: params[:page], per_page: 5)
  end

  def create
    @battle = PokemonBattle.new(battle_params)
    @poke_1 = Pokemon.find(@battle.pokemon1_id)
    @poke_2 = Pokemon.find(@battle.pokemon2_id)
    @battle.current_turn = 1
    @battle.state = "Ongoing"
    @battle.experience_gain = 0
    @battle.pokemon_winner_id = @battle.pokemon1_id
    @battle.pokemon_loser_id = @battle.pokemon2_id
    @battle.pokemon1_max_health_point = @poke_1.max_health_point
    @battle.pokemon2_max_health_point = @poke_2.max_health_point
  

    if @battle.save
      flash[:success] = "Battle created"
      redirect_to pokemon_battle_path(@battle.id)
    else
    #   require 'pry'
    # binding.pry
      render 'new'
    end
  end

  def show
  end

  private
  def battle_params
    params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
  end
end
