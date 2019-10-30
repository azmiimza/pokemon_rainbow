require 'test_helper'

class PokedexTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.create(name: "poke", base_health_point: 20, base_attack:20, base_defence:30, base_speed:30, image_url:"aaaa", element_type:"fire")
  end

  test "valid pokedex" do
    assert @pokedex.valid?, "validation failure for pokedex without complete attributes"
  end

  test "invalid without name" do
    @pokedex.name = nil
    assert @pokedex.valid?, "validation failure for pokedex without name"
  end

  test "invalid duplicate name" do
    @pokedex2 = Pokedex.new(name: "poke", base_health_point: 20, base_attack:20, base_defence:30, base_speed:30, image_url:"aaaa", element_type:"fire")
    assert @pokedex2.valid?, "validation failure for duplicate pokedex name"
  end

  test "invalid name length" do
    @pokedex.name = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam at neque at orci fringilla tempus. Proin nec dapibus odio, eu."
    assert @pokedex.valid?, "validation failure for pokedex with name length more than 45"
  end

  test "invalid without base hp" do
    @pokedex.base_health_point = nil
    assert @pokedex.valid?, "validation failure for pokedex without base hp"
  end

  test "invalid without base attack" do
    @pokedex.base_attack = nil
    assert @pokedex.valid?, "validation failure for pokedex without base attack"
  end

  test "invalid without base defence" do
    @pokedex.base_defence = nil
    assert @pokedex.valid?, "validation failure for pokedex without base defence"
  end

  test "invalid without base speed" do
    @pokedex.base_speed = nil
    assert @pokedex.valid?, "validation failure for pokedex without base speed"
  end

  test "invalid without element type" do
    @pokedex.element_type = nil
    assert @pokedex.valid?, "validation failure for pokedex without element type"
  end

  test "invalid without image url" do
    @pokedex.image_url = nil
    assert @pokedex.valid?, "validation failure for pokedex without image url"
  end

  test "invalid base health point numericality" do
    @pokedex.base_health_point = -1
    assert @pokedex.valid?, "validation failure for pokedex with base hp less than 0"
  end

  test "invalid base attack numericality" do
    @pokedex.base_attack = -1
    assert @pokedex.valid?, "validation failure for pokedex with base attack less than 0"
  end

  test "invalid base defence numericality" do
    @pokedex.base_defence = -1
    assert @pokedex.valid?, "validation failure for pokedex with base defence less than 0"
  end

  test "invalid base speed numericality" do
    @pokedex.base_speed = -1
    assert @pokedex.valid?, "validation failure for pokedex with base speed less than 0"
  end

  test "invalid element type" do
    @pokedex.element_type = "invalid"
    assert @pokedex.valid?, "validation failure for pokedex with invalid element type"
  end
end
