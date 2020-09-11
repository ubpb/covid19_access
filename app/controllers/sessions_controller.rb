class SessionsController < ApplicationController

  def create
    return redirect_to(root_path) if params[:cancel].present?

    username = params.dig("login", "username")
    password = params.dig("login", "password")

    if username.present? && password.present?
      aleph_user_data = AlephClient.new.authenticate(username, password)

      if aleph_user_data && user = create_or_update_user(aleph_user_data)
        reset_session # reset existing session for security reasons
        session[:current_user_id] = user.id

        flash[:success] = t(".success")
        redirect_to(account_root_path)
      else
        flash[:error] = t(".error")
        redirect_to(new_session_path)
      end
    else
      redirect_to(new_session_path)
    end
  end

  def destroy
    reset_session
    flash[:success] = t(".success")
    redirect_to(root_path)
  end

private

  def create_or_update_user(aleph_user_data)
    User.transaction do
      user = User.where(uid:  aleph_user_data[:id]).first_or_initialize

      # Always update the data with data from ILS
      user.first_name = aleph_user_data[:first_name]
      user.last_name  = aleph_user_data[:last_name]
      user.email      = aleph_user_data[:email]

      user.save ? user : false
    end
  end

end
