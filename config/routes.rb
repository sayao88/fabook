Rails.application.routes.draw do

  get 'notifications/index'

    resources :conversations do
        resources :messages
    end

    resources :relationships, only: [:create, :destroy]

    # 管理画面用
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    # ログインまわりなど
    devise_for :users, controllers: {
        registrations: "users/registrations",
        omniauth_callbacks: "users/omniauth_callbacks"
    }

    resources :users, only: [:index,:show]

    # get 'top/index'# rails gで生成された1行　手動で別に下に書くため、コメントアウト

    # get 'contracts/index'

    # get 'blogs/index'#これの下との違いは？

    # リクエスト（HTTPメソッドがget、URLが/blogs)のものが来た場合、blogsコントローラーのindexアクションを実行
    # get 'blogs' => 'blogs#index'

    # resoucesメソッドを使用することで、CRUD（作成・読み取り・更新・削除）を実現するためのroutingが、
    # 適切なHTTPメソッド（get/post/patch/delete)と組み合わされた上で自動的に生成されます。
    resources :blogs do
        resources :comments
        collection do
            post:confirm
        end
    end
    # 最初から用意されているものはこの1行でOK　resources :contacts, only: [:index, :new, :create]
    resources :contacts, only: [:index, :new, :create] do
        collection do
            post:confirm
        end
    end

    resources :poems, only: [:index,:show]

    # ルート・ディレクトリでどのアクションを実行するかを設定することができます。
    # root 'コントローラー名#アクション名'
    root 'top#index'

    # メール送信確認用
    if Rails.env.development?
        mount LetterOpenerWeb::Engine, at: "/letter_opener"
    end
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    # root 'welcome#index'

    # Example of regular route:
    #     get 'products/:id' => 'catalog#view'

    # Example of named route that can be invoked with purchase_url(id: product.id)
    #     get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

    # Example resource route (maps HTTP verbs to controller actions automatically):
    #     resources :products

    # Example resource route with options:
    #     resources :products do
    #         member do
    #             get 'short'
    #             post 'toggle'
    #         end
    #
    #         collection do
    #             get 'sold'
    #         end
    #     end

    # Example resource route with sub-resources:
    #     resources :products do
    #         resources :comments, :sales
    #         resource :seller
    #     end

    # Example resource route with more complex sub-resources:
    #     resources :products do
    #         resources :comments
    #         resources :sales do
    #             get 'recent', on: :collection
    #         end
    #     end

    # Example resource route with concerns:
    #     concern :toggleable do
    #         post 'toggle'
    #     end
    #     resources :posts, concerns: :toggleable
    #     resources :photos, concerns: :toggleable

    # Example resource route within a namespace:
    #     namespace :admin do
    #         # Directs /admin/products/* to Admin::ProductsController
    #         # (app/controllers/admin/products_controller.rb)
    #         resources :products
    #     end
end
