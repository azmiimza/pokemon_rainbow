module PokemonBattleCalculator
  def calculate_damage(level, power, attack, defence, weakness)
    stab = 1.5
    random = rand(85..100)
    # damage = ((((2*level/5+2)*attack*power/defence/50)+2)*stab*weakness*(random/100))
    damage = (((((2.0*level/5+2)*power*attack)/defence)/50+2)*stab*weakness*(random.to_f/100)).floor
  end

  def calculate_experience(level)
    gain = rand(20..150) * level
  end

  def level_up?(level, total_exp)
    limit = 2**level*100

    if total_exp>limit
      true
    end
  end

  def calculate_level_up_extra_stats
    health = rand(10..20)
    attack_point = rand(1..5)
    defence_point = rand(1..5)
    speed_point = rand(1..5)

    extra_stats = {"health"=>health, "attack"=> attack_point , "defence" => defence_point, "speed" => speed_point}
  end
end