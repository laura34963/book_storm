Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :store, only: [:update] do
        collection do
          get 'popular_rank'
          get 'search'
          get 'search_open'
          get 'search_hour'
          get 'search_book_count'
        end
      end

      resources :book do
        collection do
          post 'purchase'
          get 'search'
          get 'search_price'
        end
      end
      
      resources :user, only: [:create, :update] do
        post 'login'
      end

      namespace :transaction do
        get 'user_count_by_cost'
        get 'sales_situation'
      end
    end
  end
end
