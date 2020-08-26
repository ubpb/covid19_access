Rails.application.routes.draw do

  root to: redirect("/einlass")

  # Redirect some "old" routes to "new" staff backend
  get "/einlass", to: redirect("/admin/einlass")
  get "/auslass", to: redirect("/admin/auslass")

  # Staff Backend
  namespace :admin, path: "/admin" do
    resources "entries", only: [:index, :create], path: "einlass"
    resources "exits", only: [:index, :create], path: "auslass"

    get "/reset", to: "reset#index", as: "reset_index"
    post "/reset", to: "reset#create", as: "reset"

    get  "/einlass/registrations/new/:ilsid", to: "registrations#new", as: "new_registration"
    post "/einlass/registrations", to: "registrations#create", as: "registrations"

    get "/api/stats", to: "application#stats", as: "stats"
    get "/api/log", to: "application#log", as: "log"
  end

end
