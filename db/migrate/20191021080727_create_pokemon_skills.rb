class CreatePokemonSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_skills do |t|
      t.integer :current_pp
      t.references :skill, null: false, foreign_key: true
      t.references :pokemon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
