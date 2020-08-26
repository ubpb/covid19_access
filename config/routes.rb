Rails.application.routes.draw do

  #root to: redirect("/einlass")

  # Redirect some "old" routes to "new" staff backend
  get "/einlass", to: redirect("/admin/checkin")
  get "/auslass", to: redirect("/admin/checkout")

  # Staff Backend
  namespace :admin, path: "/admin" do
    # Checkin
    get  "checkin", to: "checkin#index", as: "checkin_index"
    post "checkin", to: "checkin#create", as: "checkin"

    # Checkout
    get  "checkout", to: "checkout#index", as: "checkout_index"
    post "checkout", to: "checkout#create", as: "checkout"

    # Registrations
    get  "registrations/new/:ilsid", to: "registrations#new", as: "new_registration"
    post "registrations", to: "registrations#create", as: "registrations"

    # Reset
    get "reset", to: "reset#index", as: "reset_index"
    post "reset", to: "reset#create", as: "reset"

    # API for stats and last log
    get "api/stats", to: "application#stats", as: "stats"
    get "api/log", to: "application#log", as: "log"
  end

end
