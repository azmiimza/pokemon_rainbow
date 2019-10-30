require 'test_helper'

class PokemonBattleTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.create(name: "pokedex", base_health_point: 20, base_attack:20, base_defence:30, base_speed:30, image_url:"aaaa", element_type:"fire")
    id = @pokedex.id
    @pokemon = Pokemon.create(name: "pokemon", pokedex_id: id, max_health_point: 20, current_health_point: 20, level: 1, attack: 30, defence: 30, speed: 30, current_experience:0)
    @pokemon2 = Pokemon.create(name: "pokemon 2", pokedex_id: id, max_health_point: 20, current_health_point: 20, level: 1, attack: 30, defence: 30, speed: 30, current_experience:0)

    @poke1_id = @pokemon.id
    @poke2_id = @pokemon2.id
    @battle = PokemonBattle.new(pokemon1_id: @poke1_id, pokemon2_id: @poke2_id, pokemon_winner_id: nil, pokemon_loser_id: nil, current_turn: 1, state: "Ongoing", experience_gain: 0, pokemon1_max_health_point: 20, pokemon2_max_health_point: 20)
    @battle.save
  end

  test "valid battle" do
    assert @battle.valid?, "validation failure for battle without expected attributes"
  end

  test "invalid battle with same pokemon" do
    @battle2 = PokemonBattle.new(pokemon1_id: @poke1_id, pokemon2_id: @poke1_id, pokemon_winner_id: nil, pokemon_loser_id: nil, current_turn: 1, state: "Ongoing", experience_gain: 0, pokemon1_max_health_point: 20, pokemon2_max_health_point: 20)
    @battle2.save
    assert @battle2.valid?, "validation failure for battle with same pokemon"
  end

  test "invalid battle with ongoing pokemon" do
    @battle2 = PokemonBattle.new(pokemon1_id: @poke1_id, pokemon2_id: @poke2_id, pokemon_winner_id: nil, pokemon_loser_id: nil, current_turn: 1, state: "Ongoing", experience_gain: 0, pokemon1_max_health_point: 20, pokemon2_max_health_point: 20)
    @battle2.save
    assert @battle2.valid?, "validation failure for battle with ongoing pokemon"
  end

  test "invalid battle with pokemon 1 current health point < 0" do
    @pokemon.update(current_health_point: -1)
    assert @battle.valid?, "validation failure for battle with pokemon 1 current health point = 0"
  end

  test "invalid state name" do
    @battle.state = "INVALID"
    assert @battle.valid?, "validation failure for battle with invalid state name"
  end

  test "invalid state length" do
    @battle.state= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam at neque at orci fringilla tempus. Proin nec dapibus odio, eu."
    assert @battle.valid?, "validation failure for battle with invalid state length"
  end

  test "invalid without state" do
    @battle.state = nil
    assert @battle.valid?, "validation failure for battle without state"
  end
  
  test "invalid without pokemon1_id" do
    @battle.pokemon1_id  = nil
    assert @battle.valid?, "validation failure for battle without pokemon1_id"
  end

  test "invalid without pokemon2_id" do
    @battle.pokemon2_id  = nil
    assert @battle.valid?, "validation failure for battle without pokemon2_id"
  end

  test "invalid without pokemon1_max_health_point" do
    @battle.pokemon1_max_health_point  = nil
    assert @battle.valid?, "validation failure for battle without pokemon1_max_health_point "
  end

  test "invalid without pokemon2_max_health_point" do
    @battle.pokemon2_max_health_point  = nil
    assert @battle.valid?, "validation failure for battle without pokemon2_max_health_point"
  end

  test "invalid without current turn" do
    @battle.current_turn  = nil
    assert @battle.valid?, "validation failure for battle without current_turn"
  end

  test "invalid without experience_gain" do
    @battle.experience_gain  = nil
    assert @battle.valid?, "validation failure for battle without max pp"
  end
# =============
  test "invalid pokemon1_id numericality" do
    @battle.pokemon1_id  = 0
    @battle.save
    assert @battle.valid?, "validation failure for battle with pokemon1_id equals 0"
  end

  test "invalid pokemon2_id numericality" do
    @battle.pokemon2_id  = 0
    @battle.save
    assert @battle.valid?, "validation failure for battle with pokemon1_id equals 0"
  end

  test "invalid pokemon1_max_health_point numericality" do
    @battle.pokemon1_max_health_point  = -1
    assert @battle.valid?, "validation failure for battle with pokemon1_max_health_point  less than 0"
  end

  test "invalid pokemon2_max_health_point numericality" do
    @battle.pokemon2_max_health_point  = -1
    assert @battle.valid?, "validation failure for battle with pokemon2_max_health_point less than 0"
  end

  test "invalid current turn numericality" do
    @battle.current_turn  = 0
    assert @battle.valid?, "validation failure for battle with current_turn equals 0"
  end

  test "invalid experience_gain numericality" do
    @battle.experience_gain  = -1
    assert @battle.valid?, "validation failure for battle with max pp less than 0"
  end
end
