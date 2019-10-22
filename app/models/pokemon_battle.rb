class PokemonBattle < ApplicationRecord
  extend Enumerize
  belongs_to :pokemon1, class_name: 'Pokemon'
  belongs_to :pokemon2, class_name: 'Pokemon'
  belongs_to :pokemon_winner, class_name: 'Pokemon'
  belongs_to :pokemon_loser, class_name: 'Pokemon'

  STATE=["Ongoing","Finished"]
  enumerize :state, in: STATE
end
