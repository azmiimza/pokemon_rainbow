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
    pokemon_battle = PokemonBattle.find(params[:id])
    action = params[:commit]
    poke_1 = params[:battle][:player_one]
    poke_2 = params[:battle][:player_two]

    if action == "Surrender"
      if params[:battle][:player_one_surrender]
        pokemon_battle.update(state: PokemonBattle::FINISHED, pokemon_winner_id: poke_2, pokemon_loser_id: poke_1)
      elsif params[:battle][:player_two_surrender]
        pokemon_battle.update(state: PokemonBattle::FINISHED, pokemon_winner_id: poke_1, pokemon_loser_id: poke_2)
      end
      redirect_to pokemon_battle_path(params[:id])
    else
      attack
    end
  end

  def type_chart
    element_map ={
      "normal" => {
        "normal" => 1,
        "fighting" => 1,
        "flying" => 1,
        "poison" => 1,
        "ground" => 1,
        "rock" => 0.5,
        "bug" => 1,
        "ghost" => 0,
        "steel" => 0.5,
        "fire" => 1,
        "water" => 1,
        "grass" => 1,
        "electric" => 1,
        "psychic" => 1,
        "ice" => 1,
        "dragon" => 1,
        "dark" => 1,
        "fairy" => 1
      },
      "fighting" => {
        "normal" => 2,
        "fighting" => 1,
        "flying" =>  0.5,
        "poison" =>  0.5,
        "ground" => 1,
        "rock" => 2,
        "bug" =>  0.5,
        "ghost" => 0,
        "steel" => 2,
        "fire" => 1,
        "water" =>1 ,
        "grass" => 1,
        "electric" =>1 ,
        "psychic" =>  0.5,
        "ice" => 2,
        "dragon" => 1,
        "dark" => 2,
        "fairy" => 0.5 
      },
      "flying" => {
        "normal" => 1,
        "fighting" => 2,
        "flying" => 1,
        "poison" => 1,
        "ground" => 1,
        "rock" => 1,
        "bug" =>  0.5,
        "ghost" => 2,
        "steel" => 1,
        "fire" =>  0.5,
        "water" => 1,
        "grass" => 1,
        "electric" => 2,
        "psychic" =>  0.5,
        "ice" => 1,
        "dragon" => 1,
        "dark" => 1,
        "fairy" => 1
      },
      "poison" => {
        "normal" => 1,
        "fighting" => 1,
        "flying" => 1,
        "poison" => 0.5,
        "ground" => 0.5,
        "rock" => 0.5,
        "bug" =>  1,
        "ghost" => 0.5,
        "steel" => 0,
        "fire" =>  1,
        "water" => 1,
        "grass" => 2,
        "electric" => 1,
        "psychic" =>  1,
        "ice" => 1,
        "dragon" => 1,
        "dark" => 1,
        "fairy" => 2
      },
      "ground" => {
        "normal" => 1,
        "fighting" => 1,
        "flying" => 0,
        "poison" => 2,
        "ground" => 1,
        "rock" => 2,
        "bug" =>  0.5,
        "ghost" => 1,
        "steel" => 2,
        "fire" =>  2,
        "water" => 1,
        "grass" => 0.5,
        "electric" =>2 ,
        "psychic" =>  1,
        "ice" => 1,
        "dragon" => 1,
        "dark" => 1,
        "fairy" => 1
      },
      "rock" => {
        "normal" => 1,
        "fighting" => 0.5,
        "flying" => 2,
        "poison" => 1,
        "ground" => 0.5,
        "rock" => 1,
        "bug" =>  2,
        "ghost" => 1,
        "steel" => 0.5,
        "fire" =>  2,
        "water" => 1,
        "grass" => 1,
        "electric" => 1,
        "psychic" =>  1,
        "ice" => 2,
        "dragon" => 1,
        "dark" => 1,
        "fairy" => 1
      },
      "bug" => {
        "normal" => 1,
        "fighting" => 0.5,
        "flying" => 0.5,
        "poison" => 0.5,
        "ground" => 1,
        "rock" => 1,
        "bug" =>  1,
        "ghost" => 0.5,
        "steel" => 0.5,
        "fire" =>  0.5,
        "water" => 1,
        "grass" => 2,
        "electric" => 1,
        "psychic" =>  2,
        "ice" => 1,
        "dragon" => 1,
        "dark" => 0.5,
        "fairy" => 1
      },
      "ghost" => {
        "normal" => 0,
        "fighting" => 1,
        "flying" => 1,
        "poison" =>1 ,
        "ground" => 1,
        "rock" => 1,
        "bug" =>  1,
        "ghost" => 2,
        "steel" => 1,
        "fire" =>  1,
        "water" => 1,
        "grass" => 1,
        "electric" => 1,
        "psychic" =>  2,
        "ice" => 1,
        "dragon" => 1,
        "dark" => 0.5,
        "fairy" => 1
      },
      "steel" => {
        "normal" => 1,
        "fighting" =>1 ,
        "flying" => 1,
        "poison" => 1,
        "ground" => 1,
        "rock" => 2,
        "bug" =>  1,
        "ghost" => 1,
        "steel" => 0.5,
        "fire" =>  0.5,
        "water" => 0.5,
        "grass" => 1,
        "electric" => 0.5,
        "psychic" =>  1,
        "ice" => 2,
        "dragon" => 1,
        "dark" => 1,
        "fairy" => 2
      },
      "fire" => {
        "normal" => 1,
        "fighting" =>1 ,
        "flying" => 1,
        "poison" => 1,
        "ground" => 1,
        "rock" => 0.5,
        "bug" =>  2,
        "ghost" => 1,
        "steel" => 2,
        "fire" =>  0.5,
        "water" => 0.5,
        "grass" => 2,
        "electric" =>1 ,
        "psychic" => 1 ,
        "ice" => 2,
        "dragon" => 0.5,
        "dark" => 1,
        "fairy" => 1
      },
      "water" => {
        "normal" => 1,
        "fighting" => 1,
        "flying" => 1,
        "poison" => 1,
        "ground" => 2,
        "rock" => 2,
        "bug" =>  1,
        "ghost" => 1,
        "steel" => 1,
        "fire" =>  2,
        "water" => 0.5,
        "grass" => 0.5,
        "electric" => 1,
        "psychic" =>  1,
        "ice" => 1,
        "dragon" => 0.5,
        "dark" => 1,
        "fairy" =>1 
      },
      "grass" => {
        "normal" =>1 ,
        "fighting" =>1 ,
        "flying" => 0.5,
        "poison" => 0.5,
        "ground" => 2,
        "rock" => 2,
        "bug" =>  0.5,
        "ghost" => 1,
        "steel" => 0.5,
        "fire" =>  0.5,
        "water" => 2,
        "grass" => 0.5,
        "electric" => 1,
        "psychic" =>  1,
        "ice" => 1,
        "dragon" => 0.5,
        "dark" => 1,
        "fairy" => 1
      },
      "electric" => {
        "normal" => 1,
        "fighting" => 1,
        "flying" => 2,
        "poison" => 1,
        "ground" => 0,
        "rock" => 1,
        "bug" =>  1,
        "ghost" => 1,
        "steel" => 1,
        "fire" =>  1,
        "water" => 2,
        "grass" => 0.5,
        "electric" => 0.5,
        "psychic" =>  1,
        "ice" => 1,
        "dragon" => 0.5,
        "dark" => 1,
        "fairy" => 1
      },
      "psychic" => {
        "normal" => 1,
        "fighting" =>2 ,
        "flying" => 1,
        "poison" => 2,
        "ground" => 1,
        "rock" => 1,
        "bug" =>  1,
        "ghost" => 1,
        "steel" => 0.5,
        "fire" =>  1,
        "water" => 1,
        "grass" => 1,
        "electric" =>1 ,
        "psychic" =>  0.5,
        "ice" => 1,
        "dragon" =>1 ,
        "dark" => 0,
        "fairy" =>1 
      },
      "ice" => {
        "normal" =>1 ,
        "fighting" =>1 ,
        "flying" => 2,
        "poison" => 1,
        "ground" => 2,
        "rock" => 1,
        "bug" =>  1,
        "ghost" => 1,
        "steel" => 0.5,
        "fire" =>  0.5,
        "water" => 0.5,
        "grass" => 2,
        "electric" => 1,
        "psychic" =>  1,
        "ice" => 0.5,
        "dragon" => 2,
        "dark" => 1,
        "fairy" => 1
      },
      "dragon" => {
        "normal" => 1,
        "fighting" =>1 ,
        "flying" => 1,
        "poison" => 1,
        "ground" => 1,
        "rock" => 1,
        "bug" =>  1,
        "ghost" => 1,
        "steel" => 0.5,
        "fire" =>  1,
        "water" => 1,
        "grass" => 1,
        "electric" => 1,
        "psychic" =>  1,
        "ice" => 1,
        "dragon" => 2,
        "dark" => 1,
        "fairy" => 0
      },
      "dark" => {
        "normal" => 1,
        "fighting" =>0.5 ,
        "flying" => 1,
        "poison" => 1,
        "ground" => 1,
        "rock" => 1,
        "bug" =>  1,
        "ghost" => 2,
        "steel" => 1,
        "fire" =>  1,
        "water" => 1,
        "grass" => 1,
        "electric" => 1,
        "psychic" =>  2,
        "ice" => 1,
        "dragon" => 1,
        "dark" => 0.5,
        "fairy" =>0.5 
      },
      "fairy" => {
        "normal" => 1,
        "fighting" => 2,
        "flying" => 1,
        "poison" => 0.5,
        "ground" => 1,
        "rock" => 1,
        "bug" =>  1,
        "ghost" => 1,
        "steel" => 0.5,
        "fire" =>  0.5,
        "water" => 1,
        "grass" => 1,
        "electric" => 1,
        "psychic" =>  1,
        "ice" => 1,
        "dragon" => 2,
        "dark" => 2,
        "fairy" => 1
      }
    }
  end

  def attack
    pokemon_battle = PokemonBattle.find(params[:id])
    turn = pokemon_battle.current_turn
    poke_1 = pokemon_battle.pokemon1
    poke_2 = pokemon_battle.pokemon2

    skill = Skill.find(params[:battle][:skill_id])
    poke_1_pp = PokemonSkill.where(skill_id: skill.id, pokemon_id: poke_1.id).first
    poke_2_pp = PokemonSkill.where(skill_id: skill.id, pokemon_id: poke_2.id).first
    
    poke_1_type = poke_1.pokedex.element_type
    poke_2_type = poke_2.pokedex.element_type

    if pokemon_battle.current_turn%2==1  # if player 1 turns
      if poke_1_pp.current_pp > 0
        weakness = type_chart[skill.element_type][poke_2_type]
        damage = calculate_damage(poke_1.level, skill.power, poke_1.attack, poke_2.defence, weakness)

        # reduce pp for specific pokemon 1 skill
        pp_left = poke_1_pp.current_pp-1
        poke_1_pp.update(current_pp: pp_left)

        # reduce hp of pokemon 2
        hp_left = poke_2.current_health_point-damage
    
        if hp_left <= 0
          poke_2.update(current_health_point: 0)
          pokemon_battle.update(state: PokemonBattle::FINISHED, pokemon_winner_id: poke_1.id, pokemon_loser_id: poke_2.id)
        else
          poke_2.update(current_health_point: hp_left)
        end

        # add exp after attack
        total_exp = poke_1.current_experience + calculate_experience(poke_1.level)
        # total_exp = 5000
        poke_1.update(current_experience: total_exp)

        while level_up?(poke_1.level, total_exp)
          increased_level = poke_1.level+1 
          # poke_1.update(level: increased_level)
          extra_stats = calculate_level_up_extra_stats
          health = poke_1.max_health_point + extra_stats["health"]
          attack = poke_1.attack + extra_stats["attack"]
          defence = poke_1.defence + extra_stats["defence"]
          speed = poke_1.speed + extra_stats["speed"]
          poke_1.update(level: increased_level, max_health_point: health, attack: attack, defence: defence , speed: speed)          
        end
        # require 'pry'
        # binding.pry
        turn+=1
        redirect_to pokemon_battle_path(pokemon_battle.id) 
      else
        flash[:danger] = "Skill PP already 0, choose another skill or surrender"
        redirect_to pokemon_battle_path(pokemon_battle.id)
      end

    else  # if player 2 turns
      if poke_2_pp.current_pp > 0
        weakness = type_chart[skill.element_type][poke_1_type]
        damage = calculate_damage(poke_2.level, skill.power, poke_2.attack, poke_1.defence, weakness)

        # reduce pp for specific pokemon 2 skill
        pp_left = poke_2_pp.current_pp-1
        poke_2_pp.update(current_pp: pp_left)

        # reduce hp of pokemon 1
        hp_left = poke_1.current_health_point-damage

        if hp_left <= 0
          poke_1.update(current_health_point: 0)
          pokemon_battle.update(state: PokemonBattle::FINISHED, pokemon_winner_id: poke_2.id, pokemon_loser_id: poke_1.id)
        else
          poke_1.update(current_health_point: hp_left)
        end

        # add exp after attack
        total_exp = poke_2.current_experience + calculate_experience(poke_2.level)
        # total_exp = 3000
        poke_2.update(current_experience: total_exp)

        while level_up?(poke_2.level, total_exp)
          increased_level = poke_2.level+1
          extra_stats = calculate_level_up_extra_stats
          health = poke_2.max_health_point + extra_stats["health"]
          attack = poke_2.attack + extra_stats["attack"]
          defence = poke_2.defence + extra_stats["defence"]
          speed = poke_2.speed + extra_stats["speed"]
          poke_2.update(level: increased_level, max_health_point: health, attack: attack, defence: defence , speed: speed)
        # require 'pry'
        # binding.pry
        end

        turn+=1

        # require 'pry'
        # binding.pry
        redirect_to pokemon_battle_path(pokemon_battle.id) 
      else
        flash[:danger] = "Skill PP already 0, choose another skill or surrender"
        redirect_to pokemon_battle_path(pokemon_battle.id)
      end
    end
            
    pokemon_battle.update_attributes(current_turn: turn)
  end

  private
  def battle_params
    params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
  end
end
