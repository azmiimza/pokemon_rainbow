  class Pokemon < ApplicationRecord
  extend Enumerize
  # after_initialize :set_defaults, if: :new_record?
  belongs_to :pokedex

  has_many :pokemon_skills
  has_many :skills, through: :pokemon_skills
  
  validates :name, presence: true, length:{maximum:45}, uniqueness: true
  validates :pokedex, presence: true
  validates :max_health_point, presence: true, numericality: { greater_than:0}
  validates :current_health_point, presence: true, numericality: { greater_than_or_equal_to:0, less_than_or_equal_to: :max_health_point}
  validates :level, presence: true, numericality: { greater_than:0}
  validates :attack, presence: true, numericality: { greater_than:0}
  validates :defence, presence: true, numericality: { greater_than:0}
  validates :speed, presence: true, numericality: { greater_than:0}
  validates :current_experience, presence: true, numericality: {greater_than_or_equal_to: 0}
 
  # def set_defaults
  #   self.level = 1
  #   self.current_experience = 0
  # end


end
