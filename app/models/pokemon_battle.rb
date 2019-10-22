class PokemonBattle < ApplicationRecord
  extend Enumerize
  belongs_to :pokemon1, class_name: 'Pokemon'
  belongs_to :pokemon2, class_name: 'Pokemon'
  belongs_to :pokemon_winner, class_name: 'Pokemon'
  belongs_to :pokemon_loser, class_name: 'Pokemon'

  STATE=["Ongoing","Finished"]
  enumerize :state, in: STATE

  validate :check_player
  validate :check_current_health_point
  validate :check_state

  private

  def check_state
    p1 = pokemon1.id
    p2 = pokemon2.id

    if p1 && state=="Ongoing"
       errors.add(:base, "Player 1 still ongoing in battle")
    elsif p2 && state=="Ongoing"
      errors.add(:base, "Player 2 still ongoing in battle")
    end
  end
  
  def check_player
    p1 = pokemon1.id
    p2 = pokemon2.id

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
