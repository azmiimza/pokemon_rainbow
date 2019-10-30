require 'test_helper'

class BattleTest < ActiveSupport::TestCase

  def setup
    @pokedex = Pokedex.create(name: "pokedex", base_health_point: 20, base_attack:20, base_defence:30, base_speed:30, image_url:"aaaa", element_type:"fire")
    @id = @pokedex.id
    @pokemon = Pokemon.create(name: "pokemon", pokedex_id: @id, max_health_point: 20, current_health_point: 20, level: 1, attack: 30, defence: 30, speed: 30, current_experience:0)
    @pokemon2 = Pokemon.create(name: "pokemon 2", pokedex_id: @id, max_health_point: 20, current_health_point: 20, level: 1, attack: 30, defence: 30, speed: 30, current_experience:0)
    @poke1_id = @pokemon.id
    @poke2_id = @pokemon2.id

    @skill = Skill.create(name: "skill 1", power: 10, max_pp: 30, element_type:"fire")
    @skill_id = @skill.id
    @current_pp = @skill.max_pp
    @poke1_skill = PokemonSkill.create(current_pp: @current_pp, skill_id: @skill_id, pokemon_id: @poke1_id )
    @poke2_skill = PokemonSkill.create(current_pp: @current_pp, skill_id: @skill_id, pokemon_id: @poke2_id )
    @battle = PokemonBattle.new(pokemon1_id: @poke1_id, pokemon2_id: @poke2_id, pokemon_winner_id: nil, pokemon_loser_id: nil, current_turn: 1, state: "Ongoing", experience_gain: 0, pokemon1_max_health_point: 20, pokemon2_max_health_point: 20)
    @battle.save
  end

  test "valid surrender" do
    action = "Surrender"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @poke1_skill.id, action: action)
    assert @battle_engine.valid_next_turn?
  end

  test "invalid action" do
    action = "Invalid"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @poke1_skill.id, action: action)
    assert_not @battle_engine.valid_next_turn?, "validation failure for battle engine next turn when action invalid"
  end

  test "invalid battle if skill current pp = 0" do
    action = "Attack"
    @poke1_skill.update(current_pp: 0)
    @battle.reload

    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    assert_not @battle_engine.valid_next_turn?, "validation passed for battle engine next turn when attack with pp = 0"
  end

  test "invalid attack if pokemon dont have the skill" do
    action = "Attack"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: 2, action: action)
    assert_not @battle_engine.valid_next_turn?, "validation passed for battle engine next turn when pokemon dont have the skill"
  end

  test "check current pp decreased after attack" do
    action = "Attack"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    current_pp = @battle.pokemon1.pokemon_skills.find_by(skill_id: @skill.id).current_pp

    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      @battle.reload
      assert_equal current_pp-1 , @battle.pokemon1.pokemon_skills.find_by(skill_id: @skill.id).current_pp , "validation failure increase turn"
    end
  end

  test "valid attack when pp > 0" do
    action = "Attack"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    assert @battle_engine.valid_next_turn?, "validation passed for battle engine next turn when attack with pp > 0"
  end

  test "battle finished when hp = 0" do
    @pokemon2.update(current_health_point: 1)
 
    action = "Attack"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)

    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert_equal @battle.state=::PokemonBattle::FINISHED, @battle.state, "validation passed match finished"
    end
  end

  test "set winner when pokemon 1 win battle" do
    @pokemon2.update(current_health_point: 1)
 
    action = "Attack"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)

    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!     
      assert_equal  @poke1_id, @battle_engine.pokemon_battle.pokemon_winner_id, "validation failure pokemon 1 win battle"
    end
  end

  test "set winner when pokemon 2 win battle" do
    @pokemon.update(current_health_point: 1)
    2.times  do
      action = "Attack"
      @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
  
      if @battle_engine.valid_next_turn?
        @battle_engine.next_turn!
      end
    end

    assert_equal  @poke2_id, @battle_engine.pokemon_battle.pokemon_winner_id, "validation failure pokemon 2 win battle"
  end

  test "increase turn" do
    action = "Attack"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    current_turn = @battle.current_turn

    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      @battle.reload
      assert_equal current_turn+=1 , @battle.current_turn , "validation failure increase turn"
    end
  end

  # SURRENDER

  test "level up of pokemon 2 when pokemon 1 surrender" do
    action = "Surrender"
    @pokemon2.update(current_experience: 199)
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    before_level_up = @battle_engine.defender.level
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.defender.level > before_level_up, "validation failure level up of pokemon 2 when pokemon 1 surrender"
    end
  end

  test "level up of pokemon 1 when pokemon 2 surrender" do 
    @pokemon.update(current_experience: 199)
    action = "Attack"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    before_level_up = @battle_engine.defender.level
    if @battle_engine.valid_next_turn? # turn 1
      @battle_engine.next_turn!
    end

    action = "Surrender"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    if @battle_engine.valid_next_turn? # turn 2
      @battle_engine.next_turn!
    end
    assert @battle_engine.defender.level > before_level_up, "validation failure level up of pokemon 1 when pokemon 2 surrender"
  end

  test "increase max hp of pokemon 2 when level up" do
    action = "Surrender"
    @pokemon2.update(current_experience: 199)

    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    health = @battle_engine.defender.max_health_point
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.defender.max_health_point > health, "validation failure increase max hp of pokemon 2 when level up"
    end
  end

  test "increase attack of pokemon 2  when level up" do
    action = "Surrender"
    @pokemon2.update(current_experience: 199)

    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    attack = @battle_engine.defender.attack
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.defender.attack > attack, "validation failure increase attack when level up"
    end
  end

  test "increase defence of pokemon 2  when level up" do
    action = "Surrender"
    @pokemon2.update(current_experience: 199)

    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    defence = @battle_engine.defender.defence
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.defender.defence > defence, "validation failure increase defence when level up"
    end
  end

  test "increase speed of pokemon 2  when level up" do
    action = "Surrender"
    @pokemon2.update(current_experience: 199)

    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    speed = @battle_engine.defender.speed
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.defender.speed > speed, "validation failure increase defence when level up"
    end
  end
  

  # ATTACK

  test "level up of pokemon 1" do
    action = "Attack"
    @pokemon.update(current_experience: 199)
    @pokemon2.update(current_health_point: 1)
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    before_level_up = @battle_engine.attacker.level
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.attacker.level > before_level_up, "validation failure level up of pokemon 1"
    end
  end

  test "increase max hp of pokemon 1 when level up" do
    action = "Attack"
    @pokemon.update(current_experience: 199)
    @pokemon2.update(current_health_point: 1)
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    health = @battle_engine.attacker.max_health_point
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.attacker.max_health_point > health, "validation failure increase max hp when level up"
    end
  end

  test "increase attack of pokemon 1  when level up" do
    action = "Attack"
    @pokemon.update(current_experience: 199)
    @pokemon2.update(current_health_point: 1)
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    attack = @battle_engine.attacker.attack
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.attacker.attack > attack, "validation failure increase attack when level up"
    end
  end

  test "increase defence of pokemon 1  when level up" do
    action = "Attack"
    @pokemon.update(current_experience: 199)
    @pokemon2.update(current_health_point: 1)
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    defence = @battle_engine.attacker.defence
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.attacker.defence > defence, "validation failure increase defence when level up"
    end
  end

  test "increase speed of pokemon 1  when level up" do
    action = "Attack"
    @pokemon.update(current_experience: 199)
    @pokemon2.update(current_health_point: 1)
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    speed = @battle_engine.attacker.speed
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.attacker.speed > speed, "validation failure increase defence when level up"
    end
  end
  
  test "decreased hp of pokemon 2 when attacked" do
    action = "Attack"
    @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
    before_attacked =  @battle_engine.pokemon_battle.pokemon2.current_health_point
    if @battle_engine.valid_next_turn?
      @battle_engine.next_turn!
      assert @battle_engine.pokemon_battle.pokemon2.current_health_point < before_attacked , "validation failure decreased hp when attacked"
    end
  end

  test "decreased hp of pokemon 1 when attacked" do
    2.times do
      action = "Attack"
      @battle_engine = BattleEngine.new(battle_id: @battle.id, skill_id: @skill.id, action: action)
      @before_attacked =  @battle_engine.pokemon_battle.pokemon1.current_health_point 
  
      if @battle_engine.valid_next_turn?
        @battle_engine.next_turn! 
      end
    end
    assert @battle_engine.pokemon_battle.pokemon1.current_health_point < @before_attacked , "validation failure decreased hp when attacked"
  end

end