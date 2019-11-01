class PokedexesController < ApplicationController
  before_action :breadcrumb

  def new
    @pokedex = Pokedex.new
    add_breadcrumb "New Pokedex"
  end

  def index
    @pokedexes = Pokedex.reorder("id ASC").paginate(page: params[:page], per_page: 5)
  end

  def edit
    @pokedex = Pokedex.find(params[:id])
    # add_breadcrumb "Pokedexes", pokedexes_path
    add_breadcrumb "#{@pokedex.name}", pokedex_path(params[:id])
    add_breadcrumb "Edit #{@pokedex.name}"
  end

  def destroy
    Pokedex.find(params[:id]).destroy
    flash[:success] = "Pokedex deleted"
    redirect_to pokedexes_path
  end

  def update
    @pokedex = Pokedex.find(params[:id])
    if @pokedex.update_attributes(poke_params)
      flash[:success] = "Pokedex updated"
      redirect_to pokedex_path
    else
      render 'edit'
    end
  end

  def show
    @pokedex = Pokedex.find(params[:id])
    # add_breadcrumb "Pokedexes", pokedexes_path
    add_breadcrumb "#{@pokedex.name}"
  end

  def create
    @pokedex = Pokedex.new(poke_params)
    if @pokedex.save
      flash[:success] = "#{@pokedex.name} created"
      redirect_to pokedex_path(@pokedex.id)
    else
      render 'new'
    end
  end

  private
  def breadcrumb
    add_breadcrumb "Pokedexes", pokedexes_path
  end

  def poke_params
    params.require(:pokedex).permit(:name, :base_health_point, :base_attack, :base_defence, :base_speed, :element_type, :image_url)
  end
end
