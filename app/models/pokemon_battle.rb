class PokemonBattle < ApplicationRecord
  extend Enumerize
  belongs_to :pokemon1, class_name: 'Pokemon'
  belongs_to :pokemon2, class_name: 'Pokemon'
  belongs_to :pokemon_winner, class_name: 'Pokemon', optional: true
  belongs_to :pokemon_loser, class_name: 'Pokemon', optional: true

  has_many :pokemon_battle_logs, dependent: :destroy

  # State Constant
  ONGOING = 'Ongoing'.freeze
  FINISHED = 'Finished'.freeze
  STATE=[ONGOING, FINISHED]
  enumerize :state, in: STATE

  after_initialize :set_default_attr, if: :new_record?
  
  validate :check_player
  validate :check_current_health_point, if: :new_record?
  validate :check_state, if: :new_record?
  
  validates :battle_type, presence: true
  validates :pokemon1, presence: true
  validates :pokemon2, presence: true
  validates :current_turn, numericality: {greater_than: 0}
  validates :state, presence: true, length: {maximum:45}
  validates :experience_gain, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :pokemon1_max_health_point, presence: true, numericality: { greater_than_or_equal_to:0}
  validates :pokemon2_max_health_point, presence: true, numericality: { greater_than_or_equal_to:0}

  private

  def set_default_attr
    self.pokemon_winner_id ||= nil
    self.pokemon_loser_id ||= nil
    self.state ||= ONGOING
    self.current_turn ||= 1
    self.experience_gain ||= 0
  end

  def check_state
    ongoing = PokemonBattle.where(state: ::PokemonBattle::ONGOING)
    players = ongoing.collect{|x|[x.pokemon1_id, x.pokemon2_id]}.flatten.uniq

    if players.include?(pokemon1_id)
      errors.add(:base, "Player 1 ongoing")
    elsif players.include?(pokemon2_id)
      errors.add(:base, "Player 2 ongoing")
    end
  end
  
  def check_player
    p1 = pokemon1_id
    p2 = pokemon2_id

    if p1 == p2
      errors.add(:base, "Player 1 and Player 2 must be different")
    end
  end

  def check_current_health_point
    p1 = pokemon1.current_health_point
    p2 = pokemon2.current_health_point
    
    if p1<=0
       errors.add(:base, "Player 1 has zero health point")
    elsif p2<=0
      errors.add(:base, "Player 2 has zero health point")
    end
  end
end
