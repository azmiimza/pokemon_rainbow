class PokemonBattleLog < ApplicationRecord
  belongs_to :pokemon_battle
  belongs_to :skill, optional: true
  belongs_to :attacker, class_name: 'Pokemon'
  belongs_to :defender, class_name: 'Pokemon'

  validates :pokemon_battle, presence: true
  validates :turn, presence: true, numericality: {only_integer: true}
  validates :damage, presence: true, numericality: {only_integer: true}
  validates :attacker_id, presence: true, numericality: {only_integer: true}
  validates :defender_id, presence: true, numericality: {only_integer: true}
  validates :attacker_current_health_point, presence: true, numericality: {only_integer: true}
  validates :defender_current_health_point, presence: true, numericality: {only_integer: true}
  validates :action_type, presence: true, length: {maximum:45}
end
