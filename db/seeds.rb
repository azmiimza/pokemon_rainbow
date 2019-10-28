# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

puts "Seed Pokedex & Pokemon"
csv_text = File.read(Rails.root.join('lib', 'seeds', 'list_pokedex.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  new = Pokedex.create!(name: row['name'], base_health_point: row['base_health_point'], base_attack: row['base_attack'], base_defence: row['base_defence'], base_speed: row['base_speed'], element_type: row['element_type'], image_url: row['image_url'])
  Pokemon.create!(pokedex_id: new.id, level: 1, current_experience: 0, name: row['name'],  max_health_point: row['base_health_point'], current_health_point: row['base_health_point'], attack: row['base_attack'], defence: row['base_defence'], speed: row['base_speed'])    
end
puts "Done"
puts "Seed Skill"
csv_text = File.read(Rails.root.join('lib', 'seeds', 'list_skill.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  new = Skill.create!(name: row['name'], power: row['power'], max_pp: row['max_pp'], element_type: row['element_type'])
end
puts "Done"