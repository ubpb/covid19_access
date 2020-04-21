Rails.application.routes.draw do

  root to: redirect("/einlass")

  get  "/einlass", to: "access#enter_index", as: "enter_index"
  post "/einlass", to: "access#enter", as: "enter"
  get  "/auslass", to: "access#exit_index", as: "exit_index"
  post "/auslass", to: "access#exit", as: "exit"

  get "/stats", to: "access#stats", as: "stats"
  get "/log", to: "access#log", as: "log"

  namespace :admin, path: "/admin" do
    get "/reset", to: "reset#index", as: "reset_index"
    post "/reset", to: "reset#create", as: "reset"
  end

end
