require 'test_helper'

class PokemonTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.create(name: "pokedex", base_health_point: 20, base_attack:20, base_defence:30, base_speed:30, image_url:"aaaa", element_type:"fire")
    id = @pokedex.id
    @pokemon = Pokemon.create(name: "pokemon", pokedex_id: id, max_health_point: 20, current_health_point: 20, level: 1, attack: 30, defence: 30, speed: 30, current_experience:0)
  end

  test "valid pokemon" do
    assert @pokemon.valid?, "validation failure for pokemon without complete attributes"
  end

  test "invalid duplicate name" do
    id = @pokedex.id
    @pokemon2 = Pokemon.create(name: "pokemon", pokedex_id: id, max_health_point: 20, current_health_point: 20, level: 1, attack: 30, defence: 30, speed: 30, current_experience:0)
    assert @pokemon2.valid?, "validation failure for duplicate pokemon name"
  end

  test "invalid without name" do
    @pokemon.name = nil
    assert @pokemon.valid?, "validation failure for pokemon without name"
  end

  test "invalid name length" do
    @pokemon.name = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam at neque at orci fringilla tempus. Proin nec dapibus odio, eu."
    assert @pokemon.valid?, "validation failure for pokemon with name length more than 45"
  end

  test "invalid without max hp" do
    @pokemon.max_health_point = nil
    assert @pokemon.valid?, "validation failure for pokemon without max hp"
  end

  test "invalid without current hp" do
    @pokemon.current_health_point = nil
    assert @pokemon.valid?, "validation failure for pokemon without current hp"
  end

  test "invalid without attack" do
    @pokemon.attack = nil
    assert @pokemon.valid?, "validation failure for pokemon without attack"
  end

  test "invalid without defence" do
    @pokemon.defence = nil
    assert @pokemon.valid?, "validation failure for pokemon without defence"
  end

  test "invalid without speed" do
    @pokemon.speed = nil
    assert @pokemon.valid?, "validation failure for pokemon without speed"
  end

  test "invalid without current exp" do
    @pokemon.current_experience = nil
    assert @pokemon.valid?, "validation failure for pokemon without current exp"
  end

  test "invalid max health point numericality" do
    @pokemon.max_health_point = -1
    assert @pokemon.valid?, "validation failure for pokemon with max hp less than 0"
  end

  test "invalid current health point numericality" do
    @pokemon.current_health_point = -1
    assert @pokemon.valid?, "validation failure for pokemon with current hp less than 0"
  end

  test "invalid attack numericality" do
    @pokemon.attack = -1
    assert @pokemon.valid?, "validation failure for pokemon with attack less than 0"
  end

  test "invalid defence numericality" do
    @pokemon.defence = -1
    assert @pokemon.valid?, "validation failure for pokemon with defence less than 0"
  end

  test "invalid speed numericality" do
    @pokemon.speed = -1
    assert @pokemon.valid?, "validation failure for pokemon with speed less than 0"
  end

  test "invalid current exp numericality" do
    @pokemon.current_experience = -1
    assert @pokemon.valid?, "validation failure for pokemon with current exp less than 0"
  end

  test "invalid current health point more than max health point" do
    @pokemon.current_health_point = 1000
    assert @pokemon.valid?, "validation failure for pokemon with current hp more than max hp"
  end
end
