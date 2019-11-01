class AIEngine
  def initialize
  end

  def vs_ai(battle_id)
    poke_ai = PokemonBattle.find(battle_id).pokemon2

    valid_skill = poke_ai.pokemon_skills.where('current_pp>0')

    if valid_skill.size>0 # attack when there is skill with current pp > 0
      selected_skill = valid_skill.sample.skill_id
      action = "Attack"
      battle = BattleEngine.new(battle_id: battle_id, skill_id: selected_skill, action: action)

      if battle.valid_next_turn?
        battle.next_turn!
      end

    else #surrender
      skill_count = poke_ai.pokemon_skills.count

      action = "Surrender"
      # require 'pry'
      # binding.pry
      if skill_count == 0
        battle = BattleEngine.new(battle_id: battle_id, skill_id: nil, action: action)
      else
        selected_skill = poke_ai.pokemon_skills.sample.skill_id
        battle = BattleEngine.new(battle_id: battle_id, skill_id: selected_skill, action: action)
      end
      if battle.valid_next_turn?
        battle.next_turn!
      end
    end
  end

  # def ai_vs_ai(pokemon_battle)
  #   poke_ai_1 = pokemon_battle.pokemon1
  #   poke_ai_2 = pokemon_battle.pokemon2

  #   loop do
  #     pokemon_battle = PokemonBattle.find(pokemon_battle.id)
 
  #     if pokemon_battle.current_turn%2==1
  #       valid_skill = poke_ai_1.pokemon_skills.where('current_pp>0')
  #     else
  #       valid_skill = poke_ai_2.pokemon_skills.where('current_pp>0')
  #     end

  #     if valid_skill.size>0 # attack when there is skill with current pp > 0
  #       selected_skill = valid_skill.sample.skill_id
  #       action = "Attack"
  #       battle = BattleEngine.new(battle_id: pokemon_battle.id, skill_id: selected_skill, action: action)

  #       if battle.valid_next_turn?
  #         battle.next_turn!
  #       end

  #     else #surrender
  #       action = "Surrender"
  #       if pokemon_battle.current_turn%2 == 1
  #         selected_skill = poke_ai_1.pokemon_skills.sample.skill_id
  #       else
  #         selected_skill = poke_ai_2.pokemon_skills.sample.skill_id
  #       end
        
  #       battle = BattleEngine.new(battle_id: pokemon_battle.id, skill_id: selected_skill, action: action)

  #       if battle.valid_next_turn?
  #         battle.next_turn!
  #       end
  #     end

  #     break if pokemon_battle.state == ::PokemonBattle::FINISHED
      
  #   end

  # end

end