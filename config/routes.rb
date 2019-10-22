Rails.application.routes.draw do
  get 'pokemon_battles/new'
  get 'pokemon_battles/index'
  get 'pokemon_battles/show'
  resources :pokedexes
  resources :skills
  resources :pokemons do
    resources :pokemon_skills, only: [:create, :destroy]
  end
  resources :pokemon_battles

  root 'basic_layouts#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
