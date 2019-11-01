class PokemonBattlesController < ApplicationController
  include PokemonBattleCalculator
  require 'BattleEngine'
  require 'AIEngine'

  before_action :breadcrumb

  def new
    @pokemon_battle = PokemonBattle.new
    add_breadcrumb "New Battle"
  end

  def index
    @battles = PokemonBattle.reorder("state DESC, id ASC").paginate(page: params[:page], per_page: 5)
  end

  def create
    # @pokemon_battle.battle_type = params[:battle_type]
    @pokemon_battle = PokemonBattle.new(battle_params)


    @poke_1 = Pokemon.find(@pokemon_battle.pokemon1_id)
    @poke_2 = Pokemon.find(@pokemon_battle.pokemon2_id)

    @pokemon_battle.pokemon1_max_health_point = @poke_1.max_health_point
    @pokemon_battle.pokemon2_max_health_point = @poke_2.max_health_point

    if @pokemon_battle.save
      flash[:success] = "Battle created"

      if @pokemon_battle.battle_type!="AI vs AI"
        redirect_to pokemon_battle_path(@pokemon_battle.id)
      else
        ai_battle(@pokemon_battle)
      end
    else
      render 'new'
    end
  end

  def show
    @pokemon_battle = PokemonBattle.find(params[:id])
    @logs= PokemonBattleLog.where(pokemon_battle_id: params[:id])
    add_breadcrumb "Battle #{@pokemon_battle.id}"
  end

  def ai_battle(pokemon_battle)
    poke_ai_1 = pokemon_battle.pokemon1
    poke_ai_2 = pokemon_battle.pokemon2

    loop do
      pokemon_battle = PokemonBattle.find(pokemon_battle.id)
 
      if pokemon_battle.current_turn%2==1
        valid_skill = poke_ai_1.pokemon_skills.where('current_pp>0')
      else
        valid_skill = poke_ai_2.pokemon_skills.where('current_pp>0')
      end

      if valid_skill.size>0 # attack when there is skill with current pp > 0
        selected_skill = valid_skill.sample.skill_id
        action = "Attack"
        battle = BattleEngine.new(battle_id: pokemon_battle.id, skill_id: selected_skill, action: action)

        if battle.valid_next_turn?
          battle.next_turn!
        end

      else #surrender
        action = "Surrender"
        if pokemon_battle.current_turn%2 == 1
          skill_count = poke_ai_1.pokemon_skills.count
          if skill_count == 0
            selected_skill = nil
          else
            selected_skill = poke_ai_1.pokemon_skills.sample.skill_id
          end
        else
          skill_count = poke_ai_2.pokemon_skills.count
          if skill_count == 0
            selected_skill = nil
          else
            selected_skill = poke_ai_2.pokemon_skills.sample.skill_id
          end
        end
        
        battle = BattleEngine.new(battle_id: pokemon_battle.id, skill_id: selected_skill, action: action)

        if battle.valid_next_turn?
          battle.next_turn!
        end
      end

      break if pokemon_battle.state == ::PokemonBattle::FINISHED
      
    end

    redirect_to pokemon_battle_path(pokemon_battle.id)
  end

  def update
    battle_id = params[:id]
    battle_type = PokemonBattle.find(params[:id]).battle_type
    skill_id = params[:battle][:skill_id] # skill id for human player
    action = params[:commit] # action for human player
    
    battle = BattleEngine.new(battle_id: battle_id, skill_id: skill_id, action: action)

    if battle_type == "Player vs AI"
      if battle.valid_next_turn?
        battle.next_turn!

        mode = AIEngine.new
        mode.vs_ai(battle_id)
      else
        flash[:danger] = "You can't attack anymore, just surrender please"
      end

      redirect_to pokemon_battle_path(params[:id])

    elsif battle_type == "Manual"
      if battle.valid_next_turn?
        battle.next_turn!
      else
        flash[:danger] = "You can't attack anymore, just surrender please"
      end
      redirect_to pokemon_battle_path(params[:id])
    end
  end

  private
  def battle_params
    params.require(:pokemon_battle).permit(:battle_type,:pokemon1_id, :pokemon2_id)
  end

  def breadcrumb
    add_breadcrumb "Pokemon Battles", pokemon_battles_path
  end
end
