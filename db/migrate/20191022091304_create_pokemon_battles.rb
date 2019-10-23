class CreatePokemonBattles < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_battles do |t|
      t.integer :pokemon1_id
      t.integer :pokemon2_id
      t.integer :pokemon_winner_id
      t.integer :pokemon_loser_id
      t.integer :current_turn, default: 1
      t.string :state, default: "Ongoing"
      t.integer :experience_gain, default: 0
      t.integer :pokemon1_max_health_point
      t.integer :pokemon2_max_health_point

      t.timestamps
    end
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon1_id
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon2_id
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon_winner_id
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon_loser_id
  end
end
