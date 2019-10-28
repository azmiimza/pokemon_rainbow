class PokemonBattlesController < ApplicationController
  include PokemonBattleCalculator
  require 'BattleEngine'

  def new
    @pokemon_battle = PokemonBattle.new
  end

  def index
    @battles = PokemonBattle.reorder("state DESC, id ASC").paginate(page: params[:page], per_page: 5)
  end

  def create
    @pokemon_battle = PokemonBattle.new(battle_params)
    @poke_1 = Pokemon.find(@pokemon_battle.pokemon1_id)
    @poke_2 = Pokemon.find(@pokemon_battle.pokemon2_id)

    @pokemon_battle.pokemon1_max_health_point = @poke_1.max_health_point
    @pokemon_battle.pokemon2_max_health_point = @poke_2.max_health_point
    

    # require 'pry'
    # binding.pry

    # if @poke_1.skills.none? 
    #   flash[:danger] = "Player 1 don't have any skill"
    #   redirect_to pokemon_battles_new_path
    # elsif @poke_2.skills.none? 
    #   flash[:danger] = "Player 2 don't have any skill"
    #   redirect_to pokemon_battles_new_path
    # else
      if @pokemon_battle.save
          flash[:success] = "Battle created"
          redirect_to pokemon_battle_path(@pokemon_battle.id)
      else
          render 'new'
      end
    # end
  end

  def show
    @pokemon_battle = PokemonBattle.find(params[:id])
  end

  def update
    battle_id = params[:id]
    skill_id = params[:battle][:skill_id]
    action = params[:commit]
    
    battle = BattleEngine.new(battle_id: battle_id, skill_id: skill_id, action: action)

    if battle.valid_next_turn?
      battle.next_turn!
    else
      flash[:danger] = "Skill PP already zero"
    end
    redirect_to pokemon_battle_path(params[:id])
  end

  private
  def battle_params
    params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
  end
end
