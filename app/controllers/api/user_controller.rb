class Api::UserController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    skip_before_action :authorize_request, only: :create
  
    def create
      user = User.create!(user_params)
      auth_token = AuthenticateUser.new(user.email, user.password).call
      response = { message: Message.account_created, auth_token: auth_token }
      json_response(response, :created)
    end
  
    private
  
    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:name, :email, :phone_number, :password, :password_confirmation)
    end
  end
  