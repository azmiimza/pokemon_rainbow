Rails.application.routes.draw do

  get 'pokemons/new'
  get 'pokemons/index'
  get 'pokemons/show'
  get 'pokemons/edit'
  get 'skills/new'
  get 'skills/index'
  get 'skills/show'
  get 'skills/edit'
  get 'basic_layouts/home'

  resources :pokedexes
  resources :skills
  resources :pokemons do
    resources :pokemon_skills, only: [:create, :destroy]
  end

  root 'basic_layouts#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
