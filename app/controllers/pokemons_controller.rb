class PokemonsController < ApplicationController
  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new(poke_params)
    @selected = Pokedex.find(@pokemon.pokedex_id)
    @pokemon.max_health_point = @selected.base_health_point
    @pokemon.current_health_point = @selected.base_health_point
    @pokemon.attack = @selected.base_attack
    @pokemon.defence = @selected.base_defence
    @pokemon.speed = @selected.base_speed
    @pokemon.level = 1
    @pokemon.current_experience = 0

    if @pokemon.save
      flash.now[:success] = "#{@pokemon.name} created"
      redirect_to pokemon_path(@pokemon.id)
    else
      render 'new'
    end
  end

  def update
    @pokemon = Pokemon.find(params[:id])
    action = params[:commit]

    if @pokemon.update_attributes(poke_params)
      flash[:success] = "Pokemon updated"
      redirect_to pokemon_path
    else
      render 'edit'
    end

  end

  def index
    @pokemons = Pokemon.reorder("id ASC").paginate(page: params[:page], per_page: 5)

  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @pokemon_skills = @pokemon.pokemon_skills
  end

  def heal_all
    finished = PokemonBattle.where(state: ::PokemonBattle::FINISHED).collect {|x|[x.pokemon1_id, x.pokemon2_id]}.flatten.uniq
    ongoing = PokemonBattle.where(state: ::PokemonBattle::ONGOING).collect {|x|[x.pokemon1_id, x.pokemon2_id]}.flatten.uniq
    
    players = finished-ongoing

    players.each do |id|
      poke = Pokemon.find(id)
      poke.update(current_health_point: poke.max_health_point)
      skills = PokemonSkill.where(pokemon_id: id)

      skills.all.each do |skill|
        max = poke.skills.find(skill.skill_id).max_pp
        skill.update(current_pp: max)
      end 
    end

    # Pokemon.all.each do |p|
    #   ongoing = PokemonBattle.where(state: ::PokemonBattle::ONGOING)
    #   players = ongoing.collect{|x|[x.pokemon1_id, x.pokemon2_id]}.flatten
  
    #   if players.include? p.id
    #     false
    #   else
    #     p.update(current_health_point: p.max_health_point)
    #     skills = PokemonSkill.where(pokemon_id: p.id)
  
    #     skills.all.each do |skill|
    #       max = p.skills.find(skill.skill_id).max_pp
    #       skill.update(current_pp: max)
    #     end 
    #   end   
    # end
    flash[:success] = "All pokemon healed, except pokemon in ongoing battle"
    redirect_to pokemons_path
  end

  def heal
    poke = Pokemon.find(params[:id])

    ongoing = PokemonBattle.where(state: ::PokemonBattle::ONGOING)
    players = ongoing.collect{|x|[x.pokemon1_id, x.pokemon2_id]}.flatten

    if players.include?(poke.id)
      flash[:danger] = "Can't heal pokemon ongoing battle"
      redirect_to pokemon_path
    else
      poke.update(current_health_point: poke.max_health_point)
      skills = PokemonSkill.where(pokemon_id: poke.id)

      skills.all.each do |skill|
        max = poke.skills.find(skill.skill_id).max_pp
        skill.update(current_pp: max)  
      end 
      flash[:success] = "Pokemon healed"
      redirect_to pokemon_path 
    end   
  end

  def edit
    @pokemon = Pokemon.find(params[:id])
  end

  def destroy
    Pokemon.find(params[:id]).destroy
    flash[:success] = "Pokemon deleted"
    redirect_to pokemons_path
  end

  private

  def poke_params

    params.require(:pokemon).permit(:pokedex_id, :name)
  end
end
