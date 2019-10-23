module PokemonBattleCalculator
  def calculate_damage(level, power, attack, defence, weakness)
    stab = 1.5
    random = rand(85..100)
    # damage = ((((2*level/5+2)*attack*power/defence/50)+2)*stab*weakness*(random/100))
    damage = ((((2*level/5+2)*power*attack)/defence)/50+2)*stab*weakness*(random/100)
  end
end