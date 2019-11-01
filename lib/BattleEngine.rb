class BattleEngine
  include PokemonBattleCalculator

  attr_accessor :attacker, :defender, :pokemon_battle, :skill, :action, :pp, :damage, :log

  def initialize(battle_id: nil, skill_id: nil, action: nil)
    @action = action
    @pokemon_battle = PokemonBattle.find(battle_id)

    if @pokemon_battle.current_turn%2==1
      @attacker = @pokemon_battle.pokemon1
      @defender = @pokemon_battle.pokemon2
    else
      @attacker = @pokemon_battle.pokemon2
      @defender = @pokemon_battle.pokemon1
    end
    
    @skill = Skill.find_by(id: skill_id)
    @pp = PokemonSkill.find_by(skill_id: skill_id, pokemon_id: @attacker.id)
  end

  def valid_next_turn?
    if (@pp.present? && @pp.current_pp > 0 && @action=="Attack") || @action == "Surrender"
      true
    else
      false
    end
  end

  def next_turn!
    if @action == "Attack"
      attack
    else
      surrender
    end
  end

  def save!     
    @attacker.save!
    @defender.save!
    @log.save!
    @pokemon_battle.save!
    @pp.save! if @pp.present?
  end

  def attack
    @damage = calculate_damage(@attacker, @defender, @skill)

    # reduce pp for specific @attacker skill
    pp_left = @pp.current_pp-1
    @pp.current_pp = pp_left

    # reduce hp of @defender
    hp_left = @defender.current_health_point-damage

    if hp_left <= 0
      @defender.current_health_point = 0
      @pokemon_battle.attributes = {state: PokemonBattle::FINISHED, pokemon_winner_id: @attacker.id, pokemon_loser_id: @defender.id}
      # add exp after player 1 wins battle
      total_exp = @attacker.current_experience + calculate_experience(@defender.level)
      @attacker.current_experience = total_exp

      while level_up?(@attacker.level, total_exp)
        increased_level = @attacker.level+1 
        extra_stats = calculate_level_up_extra_stats
        health = @attacker.max_health_point + extra_stats.health
        attack = @attacker.attack + extra_stats.attack
        defence = @attacker.defence + extra_stats.defence
        speed = @attacker.speed + extra_stats.speed
        @attacker.attributes = {level: increased_level, max_health_point: health, attack: attack, defence: defence , speed: speed}      
      end
    else
      @defender.current_health_point =  hp_left
    end

    turn = @pokemon_battle.current_turn
 
    @log = PokemonBattleLog.new(pokemon_battle_id: @pokemon_battle.id, turn: turn, skill_id: @skill.id, damage: @damage, attacker_id: @attacker.id, defender_id: @defender.id, attacker_current_health_point: @attacker.current_health_point, defender_current_health_point: @defender.current_health_point, action_type: @action)
    turn+=1
    @pokemon_battle.current_turn = turn
    save!
  end

  def surrender
    @pokemon_battle.attributes = {state: PokemonBattle::FINISHED, pokemon_winner_id: @defender.id, pokemon_loser_id: @attacker.id}
    total_exp = @defender.current_experience + calculate_experience(@attacker.level)
    @defender.current_experience =  total_exp

    while level_up?(@defender.level, total_exp)
      increased_level = @defender.level+1
      extra_stats = calculate_level_up_extra_stats
      health = @defender.max_health_point + extra_stats.health
      attack = @defender.attack + extra_stats.attack
      defence = @defender.defence + extra_stats.defence
      speed = @defender.speed + extra_stats.speed
      @defender.attributes = {level: increased_level, max_health_point: health, attack: attack, defence: defence , speed: speed}
    end

    turn = @pokemon_battle.current_turn
    @damage = 0

    if @skill == nil
      @log = PokemonBattleLog.new(pokemon_battle_id: @pokemon_battle.id, turn: turn, skill_id: nil, damage: @damage, attacker_id: @attacker.id, defender_id: @defender.id, attacker_current_health_point: @attacker.current_health_point, defender_current_health_point: @defender.current_health_point, action_type: @action)
    else
      @log = PokemonBattleLog.new(pokemon_battle_id: @pokemon_battle.id, turn: turn, skill_id: @skill.id, damage: @damage, attacker_id: @attacker.id, defender_id: @defender.id, attacker_current_health_point: @attacker.current_health_point, defender_current_health_point: @defender.current_health_point, action_type: @action)
    end
    save!
  end
end