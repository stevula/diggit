class ApiUsersController < ApplicationController
  def index
    users = User.all

    render json: users
  end

  def show
  end

  def update
  end

  def destroy
  end
end
