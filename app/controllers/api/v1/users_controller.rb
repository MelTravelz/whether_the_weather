class Api::V1::UsersController < ApplicationController
  before_action :check_nil_values, only: [:create]

  def create
    new_params = user_params
    new_params[:email] = new_params[:email].downcase
    new_user = User.new(email: new_params[:email], password: params[:password])  

    if new_user.save 
      new_user.update(api_key: SecureRandom.hex)
      # session[:id] = new_user.id
      render json: UsersSerializer.new(new_user), status: 201
    else
      render json: ErrorSerializer.new("Credentials are incorrect.").invalid_request, status: 404
    end
  end

  def login
    new_params = user_params
    new_params[:email] = new_params[:email].downcase
    returning_user = User.find_by(email: new_params[:email])

    if returning_user.authenticate(params[:password])
      # session[:id] = returning_user.id
      render json: UsersSerializer.new(returning_user), status: 200
    else
      render json: ErrorSerializer.new("Credentials are incorrect to login.").invalid_request, status: 404
    end
  end

  private
  def check_nil_values
    if params[:email].nil? || params[:password].nil? || params[:password_confirmation].nil? || params[:password] != params[:password_confirmation] || User.find_by(email: params[:email].downcase)
      render json: ErrorSerializer.new("Credentials are incorrect.").invalid_request, status: 404
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end