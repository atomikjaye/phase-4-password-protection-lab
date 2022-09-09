class UsersController < ApplicationController
  #before_action :authorize, only: [:show]

  def create
    newUser = User.create(user_params)
    if newUser.valid?
      session[:user_id] = newUser.id
      render json: newUser, status: :created
    else
      render json: { error: newUser.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(id: session[:user_id])
    if user
      render json: user
    else
      render json: { error: "not authorized" }, status: :unauthorized
    end
  end

  def destroy
    session.delete :user_id
    head :no_content
  end

  private
  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

end
