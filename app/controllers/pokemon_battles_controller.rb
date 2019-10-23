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
    poke_1 = params[:battle][:player_one]
    poke_2 = params[:battle][:player_two]
    
    if action == "Surrender"
      if params[:battle][:player_one_surrender]
        pokemon_battle.update(state: PokemonBattle::FINISHED, pokemon_winner_id: poke_2, pokemon_loser_id: poke_1)
      elsif params[:battle][:player_two_surrender]
        pokemon_battle.update(state: PokemonBattle::FINISHED, pokemon_winner_id: poke_1, pokemon_loser_id: poke_2)
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
    poke_1 = pokemon_battle.pokemon1
    poke_2 = pokemon_battle.pokemon2

    skill = Skill.find(params[:battle][:skill_id])
    poke_1_pp = PokemonSkill.where(skill_id: skill.id, pokemon_id: poke_1.id).first
    poke_2_pp = PokemonSkill.where(skill_id: skill.id, pokemon_id: poke_2.id).first
    weakness = 1

    type_map = 
    [
      ["normal", "normal"], ["normal", "fighting"], ["normal", "flying"], ["normal", "poison"], ["normal", "ground"], ["normal", "rock"], ["normal", "bug"], ["normal", "ghost"], ["normal", "steel"], ["normal", "fire"], ["normal", "water"], ["normal", "grass"], ["normal", "electric"], ["normal", "psychic"], ["normal", "ice"], ["normal", "dragon"], ["normal", "dark"], ["normal", "fairy"], 
      ["fighting", "fighting"], ["fighting", "normal"],["fighting", "flying"], ["fighting", "poison"], ["fighting", "ground"], ["fighting", "rock"], ["fighting", "bug"], ["fighting", "ghost"], ["fighting", "steel"], ["fighting", "fire"], ["fighting", "water"], ["fighting", "grass"], ["fighting", "electric"], ["fighting", "psychic"], ["fighting", "ice"], ["fighting", "dragon"], ["fighting", "dark"], ["fighting", "fairy"], 
      ["flying", "flying"], ["flying", "fighting"], ["flying", "poison"], ["flying", "ground"], ["flying", "rock"], ["flying", "bug"], ["flying", "ghost"], ["flying", "steel"], ["flying", "fire"], ["flying", "water"], ["flying", "grass"], ["flying", "electric"], ["flying", "psychic"], ["flying", "ice"], ["flying", "dragon"], ["flying", "dark"], ["flying", "fairy"], 
      ["poison", "poison"], ["poison", "normal"], ["poison", "fighting"], ["poison", "flying"], ["poison", "ground"], ["poison", "rock"], ["poison", "bug"], ["poison", "ghost"], ["poison", "steel"], ["poison", "fire"], ["poison", "water"], ["poison", "grass"], ["poison", "electric"], ["poison", "psychic"], ["poison", "ice"], ["poison", "dragon"], ["poison", "dark"], ["poison", "fairy"], 
      ["ground", "ground"], ["ground", "normal"], ["ground", "fighting"], ["ground", "flying"], ["ground", "poison"], ["ground", "rock"], ["ground", "bug"], ["ground", "ghost"], ["ground", "steel"], ["ground", "fire"], ["ground", "water"], ["ground", "grass"], ["ground", "electric"], ["ground", "psychic"], ["ground", "ice"], ["ground", "dragon"], ["ground", "dark"], ["ground", "fairy"], 
      ["rock", "rock"], ["rock", "normal"], ["rock", "fighting"], ["rock", "flying"], ["rock", "poison"], ["rock", "ground"], ["rock", "bug"], ["rock", "ghost"], ["rock", "steel"], ["rock", "fire"], ["rock", "water"], ["rock", "grass"], ["rock", "electric"], ["rock", "psychic"], ["rock", "ice"], ["rock", "dragon"], ["rock", "dark"], ["rock", "fairy"], 
      ["bug", "bug"],["bug", "normal"], ["bug", "fighting"], ["bug", "flying"], ["bug", "poison"], ["bug", "ground"], ["bug", "rock"], ["bug", "ghost"], ["bug", "steel"], ["bug", "fire"], ["bug", "water"], ["bug", "grass"], ["bug", "electric"], ["bug", "psychic"], ["bug", "ice"], ["bug", "dragon"], ["bug", "dark"], ["bug", "fairy"], 
      ["ghost", "ghost"], ["ghost", "normal"], ["ghost", "fighting"], ["ghost", "flying"], ["ghost", "poison"], ["ghost", "ground"], ["ghost", "rock"], ["ghost", "bug"], ["ghost", "steel"], ["ghost", "fire"], ["ghost", "water"], ["ghost", "grass"], ["ghost", "electric"], ["ghost", "psychic"], ["ghost", "ice"], ["ghost", "dragon"], ["ghost", "dark"], ["ghost", "fairy"], 
      ["steel", "steel"], ["steel", "normal"], ["steel", "fighting"], ["steel", "flying"], ["steel", "poison"], ["steel", "ground"], ["steel", "rock"], ["steel", "bug"], ["steel", "ghost"], ["steel", "fire"], ["steel", "water"], ["steel", "grass"], ["steel", "electric"], ["steel", "psychic"], ["steel", "ice"], ["steel", "dragon"], ["steel", "dark"], ["steel", "fairy"], 
      ["fire", "fire"], ["fire", "normal"], ["fire", "fighting"], ["fire", "flying"], ["fire", "poison"], ["fire", "ground"], ["fire", "rock"], ["fire", "bug"], ["fire", "ghost"], ["fire", "steel"], ["fire", "water"], ["fire", "grass"], ["fire", "electric"], ["fire", "psychic"], ["fire", "ice"], ["fire", "dragon"], ["fire", "dark"], ["fire", "fairy"], 
      ["water", "water"], ["water", "normal"], ["water", "fighting"], ["water", "flying"], ["water", "poison"], ["water", "ground"], ["water", "rock"], ["water", "bug"], ["water", "ghost"], ["water", "steel"], ["water", "fire"], ["water", "grass"], ["water", "electric"], ["water", "psychic"], ["water", "ice"], ["water", "dragon"], ["water", "dark"], ["water", "fairy"], 
      ["grass", "grass"], ["grass", "normal"], ["grass", "fighting"], ["grass", "flying"], ["grass", "poison"], ["grass", "ground"], ["grass", "rock"], ["grass", "bug"], ["grass", "ghost"], ["grass", "steel"], ["grass", "fire"], ["grass", "water"], ["grass", "electric"], ["grass", "psychic"], ["grass", "ice"], ["grass", "dragon"], ["grass", "dark"], ["grass", "fairy"], 
      ["electric", "electric"], ["electric", "normal"], ["electric", "fighting"], ["electric", "flying"], ["electric", "poison"], ["electric", "ground"], ["electric", "rock"], ["electric", "bug"], ["electric", "ghost"], ["electric", "steel"], ["electric", "fire"], ["electric", "water"], ["electric", "grass"], ["electric", "psychic"], ["electric", "ice"], ["electric", "dragon"], ["electric", "dark"], ["electric", "fairy"], 
      ["psychic", "psychic"], ["psychic", "normal"], ["psychic", "fighting"], ["psychic", "flying"], ["psychic", "poison"], ["psychic", "ground"], ["psychic", "rock"], ["psychic", "bug"], ["psychic", "ghost"], ["psychic", "steel"], ["psychic", "fire"], ["psychic", "water"], ["psychic", "grass"], ["psychic", "electric"], ["psychic", "ice"], ["psychic", "dragon"], ["psychic", "dark"], ["psychic", "fairy"], 
      ["ice", "ice"], ["ice", "normal"], ["ice", "fighting"], ["ice", "flying"], ["ice", "poison"], ["ice", "ground"], ["ice", "rock"], ["ice", "bug"], ["ice", "ghost"], ["ice", "steel"], ["ice", "fire"], ["ice", "water"], ["ice", "grass"], ["ice", "electric"], ["ice", "psychic"], ["ice", "dragon"], ["ice", "dark"], ["ice", "fairy"], 
      ["dragon", "dragon"], ["dragon", "normal"], ["dragon", "fighting"], ["dragon", "flying"], ["dragon", "poison"], ["dragon", "ground"], ["dragon", "rock"], ["dragon", "bug"], ["dragon", "ghost"], ["dragon", "steel"], ["dragon", "fire"], ["dragon", "water"], ["dragon", "grass"], ["dragon", "electric"], ["dragon", "psychic"], ["dragon", "ice"], ["dragon", "dark"], ["dragon", "fairy"], 
      ["dark", "dark"], ["dark", "normal"], ["dark", "fighting"], ["dark", "flying"], ["dark", "poison"], ["dark", "ground"], ["dark", "rock"], ["dark", "bug"], ["dark", "ghost"], ["dark", "steel"], ["dark", "fire"], ["dark", "water"], ["dark", "grass"], ["dark", "electric"], ["dark", "psychic"], ["dark", "ice"], ["dark", "dragon"], ["dark", "fairy"], 
      ["fairy", "fairy"], ["fairy", "normal"], ["fairy", "fighting"], ["fairy", "flying"], ["fairy", "poison"], ["fairy", "ground"], ["fairy", "rock"], ["fairy", "bug"], ["fairy", "ghost"], ["fairy", "steel"], ["fairy", "fire"], ["fairy", "water"], ["fairy", "grass"], ["fairy", "electric"], ["fairy", "psychic"], ["fairy", "ice"], ["fairy", "dragon"], ["fairy", "dark"]
    ] 

    if poke_1.current_health_point == 0 && poke_2.current_health_point >0
      pokemon_battle.update(state: PokemonBattle::FINISHED, pokemon_winner_id: poke_2, pokemon_loser_id: poke_1)
      redirect_to pokemon_battles_path
    elsif poke_2.current_health_point == 0 && poke_1.current_health_point >0
      pokemon_battle.update(state: PokemonBattle::FINISHED, pokemon_winner_id: poke_1, pokemon_loser_id: poke_2)
      redirect_to pokemon_battles_path
    end
   
    if pokemon_battle.current_turn%2==1  # if player 1 turns
      if poke_1_pp.current_pp > 0
        damage = calculate_damage(poke_1.level, skill.power, poke_1.attack, poke_2.defence, weakness)
      
        # reduce pp for specific pokemon 1 skill
        pp_left = poke_1_pp.current_pp-1
        poke_1_pp.update(current_pp: pp_left)

        # reduce hp of pokemon 2
        hp_left = poke_2.current_health_point-damage
        poke_2.update(current_health_point: hp_left)
        
        turn+=1
      else
        flash[:danger] = "Skill PP already 0, choose another skill"
      end

    else  # if player 2 turns
      if poke_2_pp.current_pp > 0
        damage = calculate_damage(poke_2.level, skill.power, poke_2.attack, poke_1.defence, weakness)
        
        # reduce pp for specific pokemon 2 skill
        pp_left = poke_2_pp.current_pp-1
        poke_2_pp.update(current_pp: pp_left)

        # reduce hp of pokemon 1
        hp_left = poke_1.current_health_point-damage
        poke_1.update(current_health_point: hp_left)
        turn+=1
      else
        flash[:danger] = "Skill PP already 0, choose another skill"
      end
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
