# frozen_string_literal: true

Rails.application.routes.draw do
  post "user_token" => "user_token#create"
  resources :registrations
  resources :tournament_staffs
  resources :enrollments
  resources :tournaments
  resources :rosters
  resources :teams
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
