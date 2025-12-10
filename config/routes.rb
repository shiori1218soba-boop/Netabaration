Rails.application.routes.draw do

  # === Public側（URL に /public を付けない） ===
  scope module: :public do
    # Public のトップ・アバウト
    root to: 'homes#top'
    get '/about' => 'homes#about'

    # マイページ
    get 'mypage' => 'users#mypage'

    # ユーザー編集
    resources :users, only: [:edit, :update]

    # 投稿機能
    resources :posts
  end

  # Public 用の認証（URL に public は付かない）
  devise_for :users, module: "public", controllers: {
    registrations: "public/users/registrations",
    sessions: "public/users/sessions"
  }


  # === Admin側（URL に /admin を付けたい） ===
  devise_for :admins, path: 'admin', controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    root 'homes#top'
  end
end
