Rails.application.routes.draw do

  devise_for :admins
  devise_for :users
    
  root to: "homes#top"
  get "about", to: "homes#about"
  
  # ---- Public側 ----
  namespace :public do

  end

end
