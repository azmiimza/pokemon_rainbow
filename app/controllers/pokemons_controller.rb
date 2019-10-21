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
    if @pokemon.update_attributes(poke_params)
      flash[:success] = "Pokemon updated"
      redirect_to pokemon_path
    else
      render 'edit'
    end
  end

  def index
    @pokemons = Pokemon.paginate(page: params[:page], per_page: 5)
  end

  def show
    @pokemon = Pokemon.find(params[:id])
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
