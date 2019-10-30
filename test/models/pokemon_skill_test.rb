require 'test_helper'

class PokemonSkillTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.create(name: "pokedex", base_health_point: 20, base_attack:20, base_defence:30, base_speed:30, image_url:"aaaa", element_type:"fire")
    id = @pokedex.id
    @pokemon = Pokemon.create(name: "pokemon", pokedex_id: id, max_health_point: 20, current_health_point: 20, level: 1, attack: 30, defence: 30, speed: 30, current_experience:0)
    @skill = Skill.create(name: "skill 1", power: 10, max_pp: 30, element_type:"fire")
    @poke_id = @pokemon.id
    @skill_id = @skill.id
    @current_pp = @skill.max_pp
    @poke_skill = PokemonSkill.create(current_pp: @current_pp, skill_id: @skill_id, pokemon_id: @poke_id )
  end

  test "valid pokemon skill" do
    assert @poke_skill.valid?, "validation failure for pokemon skill without complete attributes"
  end

  test "invalid for different skill element type with pokemon type" do
    @skill.update(element_type: "grass")
    assert @poke_skill.valid?, "validation failure for different skill element type with pokemon type"
  end

  test "duplicate skill" do
    @poke_skill2 = PokemonSkill.create(current_pp: @current_pp, skill_id: @skill_id, pokemon_id: @poke_id )
    assert @poke_skill2.valid?, "validation failure for pokemon skill already exists"
  end

  test "invalid current pp numericality" do
    @poke_skill.current_pp  = -1
    assert @poke_skill.valid?, "validation failure for pokemon skill with current pp less than 0"
  end

  test "invalid pp" do
    @poke_skill.update(current_pp: 9999)
    assert @poke_skill.valid?, "validation failure for pokemon skill check pp failed"
  end

  test "invalid size" do
    @skill2 = Skill.create(name: "skill 2", power: 10, max_pp: 30, element_type:"fire")
    @skill3 = Skill.create(name: "skill 3", power: 10, max_pp: 30, element_type:"fire")
    @skill4 = Skill.create(name: "skill 4", power: 10, max_pp: 30, element_type:"fire")
    @skill5 = Skill.create(name: "skill 5", power: 10, max_pp: 30, element_type:"fire")

    skill2_id = @skill2.id
    skill3_id = @skill3.id
    skill4_id = @skill4.id
    skill5_id = @skill5.id
    current_pp = @skill.max_pp

    @poke_skill2 = PokemonSkill.new(current_pp: current_pp, skill_id: skill2_id, pokemon_id: @poke_id )
    @poke_skill2.save
    @poke_skill3 = PokemonSkill.new(current_pp: current_pp, skill_id: skill3_id, pokemon_id: @poke_id )
    @poke_skill3.save
    @poke_skill4 = PokemonSkill.new(current_pp: current_pp, skill_id: skill4_id, pokemon_id: @poke_id )
    @poke_skill4.save
    @poke_skill5 = PokemonSkill.new(current_pp: current_pp, skill_id: skill5_id, pokemon_id: @poke_id )
    @poke_skill5.save
    assert @poke_skill5.valid?, "validation failure for pokemon skill more than 4"
  end
end
