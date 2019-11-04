class HealPokemon


  def initialize
  end

  def heal_all
    # finished = PokemonBattle.where(state: ::PokemonBattle::FINISHED).collect {|x|[x.pokemon1_id, x.pokemon2_id]}.flatten.uniq
    ongoing = PokemonBattle.where(state: ::PokemonBattle::ONGOING).collect {|x|[x.pokemon1_id, x.pokemon2_id]}.flatten.uniq
    players_to_heal = Pokemon.all.ids-ongoing

    players_to_heal.each do |id|
      poke = Pokemon.find(id)
      poke.current_health_point = poke.max_health_point
      poke.save!
      pokemon_skills = PokemonSkill.where(pokemon_id: id)

      pokemon_skills.all.each do |pokemon_skill|
        max = pokemon_skill.skill.max_pp
        pokemon_skill.current_pp = max
        pokemon_skill.save!  
      end 
    end
  end

  def heal(pokemon_id)
    poke = Pokemon.find(pokemon_id)

    ongoing = PokemonBattle.where(state: ::PokemonBattle::ONGOING)
    players = ongoing.collect{|x|[x.pokemon1_id, x.pokemon2_id]}.flatten

    if players.include?(poke.id)
      false
    else
      poke.current_health_point = poke.max_health_point
      poke.save!
      pokemon_skills = PokemonSkill.where(pokemon_id: poke.id)

      pokemon_skills.all.each do |pokemon_skill|
        max = pokemon_skill.skill.max_pp
        pokemon_skill.current_pp = max
        pokemon_skill.save!  
      end 
      true
    end   
  end
end