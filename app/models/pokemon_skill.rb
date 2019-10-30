class PokemonSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :pokemon

  validate :check_element
  validate :check_pp
  validate :check_size

  # validates :skill, length: {maximum:4}
  validates_uniqueness_of :skill_id, scope: :pokemon_id
  validates :current_pp, numericality: {greater_than_or_equal_to: 0}

  def check_element   
    pokemon_type = self.pokemon.pokedex.element_type
    skill_type = Skill.find(self.skill_id).element_type
    if pokemon_type!=skill_type
      errors.add(:base, "Pokemon element type doesn't match with Skill element type")
    end
  end

  def check_pp
    max_pp = self.skill.max_pp
    if self.current_pp>max_pp
      errors.add(:base, "Current PP must less than Max PP")
    end
  end

  def check_size
    if PokemonSkill.where(pokemon_id: self.pokemon_id).count>=4
      errors.add(:base, "Skill cant be mor than 4")
    end
  end
end
