Rails.application.routes.draw do
  get 'basic_layouts/home'

  root 'basic_layouts#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
