class Api::V1::UsersController < ApplicationController
  def create
    new_params = user_params
    new_params[:email] = new_params[:email].downcase
    new_user = User.new(email: new_params[:email], password: params[:password])  

    if params[:password] == params[:password_confirmation] && new_user.save
      new_user.update(api_key: SecureRandom.hex)
      # session[:user_id] = new_user.id
      render json: UsersSerializer.new(new_user), status: 201
      #send to UsersSerializer
    else
      render json: ErrorSerializer.new("Credentials are incorrect.").invalid_request, status: 404
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end