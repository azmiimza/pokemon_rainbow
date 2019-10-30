require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  def setup
    @skill = Skill.create(name: "skill 1", power: 10, max_pp: 30, element_type:"fire")
  end

  test "valid skill" do
    assert @skill.valid?, "validation failure for skill without complete attributes"
  end

  test "invalid without name" do
    @skill.name = nil
    assert @skill.valid?, "validation failure for skill without name"
  end

  test "invalid duplicate name" do
    @skill2 = Skill.create(name: "skill 1", power: 10, max_pp: 30, element_type:"fire")
    assert @skill2.valid?, "validation failure for duplicate skill name"
  end

  test "invalid name length" do
    @skill.name = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam at neque at orci fringilla tempus. Proin nec dapibus odio, eu."
    assert @skill.valid?, "validation failure for skill with name length more than 45"
  end

  test "invalid without power" do
    @skill.power = nil
    assert @skill.valid?, "validation failure for skill without power"
  end

  test "invalid without max pp" do
    @skill.max_pp = nil
    assert @skill.valid?, "validation failure for skill without max pp"
  end

  test "invalid without element" do
    @skill.element_type = nil
    assert @skill.valid?, "validation failure for skill without element"
  end

  test "invalid power numericality" do
    @skill.power = -1
    assert @skill.valid?, "validation failure for skill with power less than 0"
  end

  test "invalid max ppnumericality" do
    @skill.max_pp  = -1
    assert @skill.valid?, "validation failure for skill with max pp less than 0"
  end

  test "invalid element type" do
    @skill.element_type = "invalid"
    assert @skill.valid?, "validation failure for skill with invalid element type"
  end
end
