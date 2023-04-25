class Api::V1::UsersController < ApplicationController
  before_action :check_credentials_create, only: [:create]
  before_action :check_credentials_login, only: [:login]
  before_action :check_user_exists_login, only: [:login]


  def create
    new_params = user_params
    new_params[:email] = new_params[:email].downcase
    new_user = User.new(email: new_params[:email], password: user_params[:password], api_key: SecureRandom.hex)  

    if new_user && new_user.save 
      # Refactor: add sessions
      # session[:id] = new_user.id
      render json: UsersSerializer.new(new_user), status: 201
    else
      render json: ErrorSerializer.new("Credentials are incorrect.").invalid_request, status: 404
    end
  end

  def login
    if @returning_user && @returning_user.authenticate(user_params[:password]) 
      # Refactor: add session:
      # session[:id] = returning_user.id
      render json: UsersSerializer.new(@returning_user), status: 200
    else
      render json: ErrorSerializer.new("Credentials are incorrect to login.").invalid_request, status: 404
    end
  end

  private
  def check_credentials_create
    if user_params[:email].nil? || user_params[:password].nil? || user_params[:password_confirmation].nil? || user_params[:password] != user_params[:password_confirmation] || User.find_by(email: user_params[:email].downcase)
      render json: ErrorSerializer.new("Credentials are incorrect.").invalid_request, status: 404
    end
  end

  def check_credentials_login
    if user_params[:email].nil? || user_params[:password].nil?
      render json: ErrorSerializer.new("Credentials cannot be missing.").invalid_request, status: 404
    end
  end

  def check_user_exists_login
      new_params = user_params
      new_params[:email] = new_params[:email].downcase
      @returning_user = User.find_by(email: new_params[:email])

    if @returning_user == nil 
      render json: ErrorSerializer.new("Credentials are incorrect to login.").invalid_request, status: 404
    end
  end

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end