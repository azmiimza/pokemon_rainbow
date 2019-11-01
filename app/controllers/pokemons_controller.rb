class PokemonsController < ApplicationController
  require 'HealPokemon'
  before_action :breadcrumb

  def new
    @pokemon = Pokemon.new
    add_breadcrumb "New Pokemons"
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
    add_breadcrumb "#{@pokemon.name}"
  end

  def heal_all
    poke = HealPokemon.new
    poke.heal_all

    flash[:success] = "All pokemon healed, except pokemon in ongoing battle"
    redirect_to pokemons_path
  end

  def heal
    poke = HealPokemon.new
    if poke.heal(params[:id])
      flash[:success] = "Pokemon healed"
      redirect_to pokemon_path
    else
      flash[:danger] = "Can't heal pokemon ongoing battle"
      redirect_to pokemon_path
    end
  end

  def edit
    @pokemon = Pokemon.find(params[:id])
    add_breadcrumb "#{@pokemon.name}", pokemon_path(params[:id])
    add_breadcrumb "Edit #{@pokemon.name}"
  end

  def destroy
    Pokemon.find(params[:id]).destroy
    flash[:success] = "Pokemon deleted"
    redirect_to pokemons_path
  end

  private
  def breadcrumb
    add_breadcrumb "Pokemons", pokemons_path
  end

  def poke_params
    params.require(:pokemon).permit(:pokedex_id, :name)
  end
end
