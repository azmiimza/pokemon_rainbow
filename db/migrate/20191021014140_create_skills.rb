class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :power
      t.integer :max_pp
      t.string :element_type

      t.timestamps
    end
  end
end
