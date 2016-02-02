Rails.application.routes.draw do
  scope '/internal' do
    get 'swagger' => "internal#swagger", constraints: { format: 'json' }
  end

  resources :payments, only: [] do
    collection do
      post :calculate
    end
  end
end
