Rails.application.routes.draw do

  # Root path
  root to: "pages#homepage"

  # Redirect some "old" routes to "new" staff backend
  get "/einlass", to: redirect("/admin/checkin")
  get "/auslass", to: redirect("/admin/checkout")

  # Authentication
  post "/login",  to: "sessions#create", as: :session
  get  "/login",  to: "sessions#new", as: :new_session
  get  "/logout", to: "sessions#destroy", as: :logout

  # Stats
  get "/stats", to: "statistics#index", as: :statistics

  # Static kickers
  get "/datenschutz", to: redirect("https://www.ub.uni-paderborn.de/fileadmin/ub/Dokumente_Formulare/DSE_UB_001_COVID19_Access_v1.pdf"), as: "datenschutz"
  get "/impressum", to: redirect("https://www.ub.uni-paderborn.de/ueber-uns/impressum/"), as: "impressum"

  # Staff Backend
  namespace :admin, path: "/admin" do
    # Root path
    root to: redirect("/admin/checkin")

    # Checkin
    get  "checkin", to: "checkin#index", as: "checkin_index"
    post "checkin", to: "checkin#create", as: "checkin"

    # Checkout
    get  "checkout", to: "checkout#index", as: "checkout_index"
    post "checkout", to: "checkout#create", as: "checkout"

    # Registrations
    resources :registrations do
      resources :allocations, module: :registrations, only: [:index, :new, :create, :destroy] do
        collection do
          get "print"
        end
      end
    end

    # Reset
    get "reset", to: "reset#index", as: "reset_index"
    post "reset", to: "reset#create", as: "reset"

    # API for stats and last log
    get "api/stats", to: "application#stats", as: "stats"
    get "api/log", to: "application#log", as: "log"
  end

end
