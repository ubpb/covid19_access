Rails.application.routes.draw do

  root to: redirect("/einlass")

  get  "/einlass", to: "registrations#enter_index", as: "enter_index"
  post "/einlass", to: "registrations#enter", as: "enter"
  get  "/auslass", to: "registrations#exit_index", as: "exit_index"
  post "/auslass", to: "registrations#exit", as: "exit"

  get "/api/stats", to: "registrations#stats", as: "stats"
  get "/api/log", to: "registrations#log", as: "log"

  namespace :admin, path: "/admin" do
    get "/reset", to: "reset#index", as: "reset_index"
    post "/reset", to: "reset#create", as: "reset"
  end

end
