class PokemonSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :pokemon
end
