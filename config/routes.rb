Rails.application.routes.draw do


  namespace :public do
    get 'posts/index'
    get 'posts/show'
    get 'posts/new'
  end
  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about'
  end

  # Public 用の認証
  devise_for :users, module: "public", controllers: {
    registrations: "public/users/registrations",
    sessions: "public/users/sessions"
  }

  # Admin 用の認証
  devise_for :admins, path: 'admin', controllers: {
    sessions: 'admin/sessions'
  }

  # Public namespace
  namespace :public do
    resources :posts
  end

  # Admin namespace
  namespace :admin do
    root 'homes#top'
  end
end