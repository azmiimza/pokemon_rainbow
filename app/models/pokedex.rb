class Pokedex < ApplicationRecord
  has_many :pokemons
  extend Enumerize
  # NORMAL = 'normal'.freeze
  ELEMENT_TYPE = ["normal","fighting","flying","poison","ground","rock","bug",
    "ghost","steel","fire","water",
    "grass","electric","psychic","ice",
    "dragon","dark","fairy"].freeze
  validates :name, presence: true, length:{maximum:45}, uniqueness: true
  validates :base_health_point, presence: true, numericality: { greater_than_or_equal_to:0}
  validates :base_attack, presence: true, numericality: { greater_than_or_equal_to:0}
  validates :base_defence, presence: true, numericality: { greater_than_or_equal_to:0}
  validates :base_speed, presence: true, numericality: { greater_than_or_equal_to:0}
  validates :image_url, presence: true

  enumerize :element_type, in: ELEMENT_TYPE
end
