class CreatePokemonBattleLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_battle_logs do |t|
      t.references :pokemon_battle, null: false, foreign_key: true
      t.integer :turn
      t.references :skill, null: false, foreign_key: true
      t.integer :damage
      t.integer :attacker_id
      t.integer :defender_id
      t.integer :attacker_current_health_point
      t.integer :defender_current_health_point
      t.string :action_type

      t.timestamps
    end

    add_foreign_key :pokemon_battle_logs, :pokemons, column: :attacker_id
    add_foreign_key :pokemon_battle_logs, :pokemons, column: :defender_id
  end
end
