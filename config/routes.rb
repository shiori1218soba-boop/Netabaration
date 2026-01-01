Rails.application.routes.draw do

  namespace :admin do
    get 'groups/index'
    get 'groups/show'
  end
  namespace :public do
    get 'groups/index'
    get 'groups/show'
  end
  # Public 用の認証（URL に public は付かない）
  devise_for :users, module: "public", controllers: {
    registrations: "public/users/registrations",
    sessions: "public/users/sessions"
  }

  # === Public側（URL に /public を付けない） ===
  scope module: :public do
    # Public のトップ・アバウト
    root to: 'homes#top'
    get '/about' => 'homes#about'

    # 検索機能
    get 'search', to: 'searches#search'

    get 'users/unsubscribe' => 'users#unsubscribe', as: :unsubscribe_user
    patch 'users/withdraw' => 'users#withdraw', as: :withdraw_user

    # マイページ
    get 'mypage' => 'users#mypage'
    # マイプロフィール編集
    get  "users/information/edit", to: "users#edit",   as: :edit_user_information
    patch "users/information",      to: "users#update", as: :user_information

    get   "users/unsubscribe", to: "users#unsubscribe"
    patch "users/withdraw",    to: "users#withdraw"
    # ユーザー編集
    resources :users, only: [:index, :show,]
    # グループ機能
    # 投稿機能
    resources :groups do
      resources :posts do
        resources :post_comments, only: [:create, :destroy]
        resource :favorites, only: [:create, :destroy]
      end
    end
  end



  # === Admin側（URL に /admin を付けたい） ===
  devise_for :admins, path: 'admin', controllers: {
    sessions: 'admin/sessions'
  }, skip: [:registrations]

  namespace :admin do
    root 'homes#top'
    # 検索機能
    get 'search', to: 'searches#search'
    resources :users, only: [:index, :show, :update]
    resources :groups, only: [:index, :show, :destroy] do
      member do
        patch :restore
      end
    end
    resources :posts, only: [:index, :show, :update] do
      resources :post_comments, only: [:index, :show] do
        member do
          patch :soft_delete
          patch :restore
        end
      end
    end
  end
end
