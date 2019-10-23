class PokemonBattlesController < ApplicationController
    include PokemonBattleCalculator

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
    @pokemon_battle = PokemonBattle.find(params[:id])
  end

  def update
    # require 'pry'
    # binding.pry
  
    pokemon_battle = PokemonBattle.find(params[:id])
    action = params[:commit]
    p1 = params[:battle][:player_one]
    p2 = params[:battle][:player_two]
    
    if action == "Surrender"
      if params[:battle][:player_one_surrender]
        pokemon_battle.update_attributes(state: PokemonBattle::FINISHED, pokemon_winner_id: p2, pokemon_loser_id: p1)
      elsif params[:battle][:player_two_surrender]
        pokemon_battle.update_attributes(state: PokemonBattle::FINISHED, pokemon_winner_id: p1, pokemon_loser_id: p2)
      end
        redirect_to pokemon_battles_path
    else
      attack
    end
    
  end

  def surrender

  end

  def attack

    pokemon_battle = PokemonBattle.find(params[:id])
    turn = pokemon_battle.current_turn
    p1 = Pokemon.find(pokemon_battle.pokemon1_id)
    p2 = Pokemon.find(pokemon_battle.pokemon2_id)

    skill = Skill.find(params[:battle][:skill_id])

    weakness = 1

    if pokemon_battle.current_turn%2==1
      damage = calculate_damage(p1.level, skill.power, p1.attack, p2.defence, weakness)
      turn+=1
      
    else
      damage = calculate_damage(p2.level, skill.power, p2.attack, p1.defence, weakness)
      turn+=1

    end

    pokemon_battle.update_attributes(current_turn: turn)

    require 'pry'
      binding.pry
    redirect_to pokemon_battle_path(pokemon_battle.id)
      
    
  end

  private
  def battle_params
    params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
  end
end
