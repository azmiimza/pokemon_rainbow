class Skill < ApplicationRecord
  extend Enumerize
  has_many :pokemon_skills, dependent: :destroy
  has_many :pokemons, through: :pokemon_skills

  ELEMENT_TYPE = ["normal","fire","fighting","water",
    "flying","grass","poison","electric","ground","psychic","rock","ice",
    "bug","dragon","ghost","dark","steel","fairy"].freeze
  validates :name, presence: true, length:{maximum:45}, uniqueness: true
  validates :power, presence: true, numericality: { greater_than_or_equal_to:0}
  validates :max_pp, presence: true, numericality: { greater_than_or_equal_to:0}

  enumerize :element_type, in: ELEMENT_TYPE
end
