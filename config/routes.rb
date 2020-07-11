Rails.application.routes.draw do

  root to: redirect("/einlass")

  resources "entries", only: [:index, :create], path: "einlass"
  resources "exits", only: [:index, :create], path: "auslass"

  get  "/einlass/registrations/new/:ilsid", to: "registrations#new", as: "new_registration"
  post "/einlass/registrations", to: "registrations#create", as: "registrations"

  get "/api/stats", to: "application#stats", as: "stats"
  get "/api/log", to: "application#log", as: "log"

  namespace :admin, path: "/admin" do
    get "/reset", to: "reset#index", as: "reset_index"
    post "/reset", to: "reset#create", as: "reset"
  end

end
