Auth::Application.routes.draw do
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  get "dashboards" => "dashboards#index", :as => "dashboards"
  get "setup" => "admin#setup", :as => "setup"
  match "dashboards/list" => "dashboards#list"
  root :to => "users#new"
  resources :users
  resources :sessions
  resources :dashboards
end
