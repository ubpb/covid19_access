Rails.application.routes.draw do

  # Root path
  root to: "pages#homepage"

  # Redirect some "old" routes to "new" staff backend
  get "/einlass", to: redirect("/admin/checkin/new")
  get "/auslass", to: redirect("/admin/checkout/new")

  # Authentication
  post "/login",  to: "sessions#create", as: :session
  get  "/login",  to: "sessions#new", as: :new_session
  delete "/logout", to: "sessions#destroy", as: :logout

  # Stats
  #get "/stats", to: "statistics#index", as: :statistics
  get "/stats", to: redirect("/"), as: :statistics

  # Static kickers
  get "/datenschutz", to: redirect("https://www.ub.uni-paderborn.de/fileadmin/ub/Dokumente_Formulare/DSE_UB_008_Besucherregistrierung.pdf"), as: "datenschutz"
  get "/impressum", to: redirect("https://www.ub.uni-paderborn.de/ueber-uns/impressum/"), as: "impressum"

  # Self-Checkout
  get "self-checkout/new", to: "self_checkout#new", as: "new_self_checkout"
  get "self-checkout", to: "self_checkout#show", as: "self_checkout"
  post "self-checkout", to: "self_checkout#create"

  # User Backend
  namespace :account, path: "/account" do
    root to: redirect("/account/reservations")

    resources :reservations, only: [:index, :new, :create, :destroy] do
      get "select-date", on: :collection
    end
  end

  # Staff Backend
  namespace :admin, path: "/admin" do
    # Root path
    root to: redirect("/admin/checkin/new")

    # Checkin
    get "checkin/new", to: "checkin#new", as: "new_checkin"
    post "checkin", to: "checkin#create", as: "checkin"
    get "checkin/registration/new", to: "checkin#new_registration", as: "new_checkin_registration"
    post "checkin/registration", to: "checkin#create_registration", as: "checkin_registration"

    # Checkout
    get "checkout/new", to: "checkout#new", as: "new_checkout"
    post "checkout", to: "checkout#create", as: "checkout"
    get "checkout/registration/:id", to: "checkout#show", as: "checkout_registration"
    delete "checkout/registration/:id", to: "checkout#destroy", as: nil
    put "checkout/registration/:id/break", to: "checkout#break", as: "break_registration"

    # Registrations
    resources :registrations, only: [:index, :show, :edit, :update] do
      # Allocations
      resources :allocations, module: :registrations, only: [:index, :new, :create, :destroy] do
        member do
          get "print"
        end
      end

      # Reservations
      resources :reservations, module: :registrations, only: [:destroy] do
        member do
          post "allocate"
        end
      end
    end

    # Stats
    get "stats", to: "statistics#index", as: "statistics"

    # Resource management
    resources :resource_groups, path: "resource-groups"
    resources :resource_locations, path: "resource-locations"
    resources :resources

    # Reset
    get "reset", to: "reset#index", as: "reset_index"
    post "reset", to: "reset#create", as: "reset"
  end

end
