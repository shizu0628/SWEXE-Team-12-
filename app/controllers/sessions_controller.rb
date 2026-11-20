class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @users = User.all
  end

  def create
    user = User.find_by(id: params[:user_id]) || User.find_by(email: params[:email])

    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: "#{user.name} としてログインしました"
    else
      @users = User.all
      flash.now[:alert] = "ユーザーが見つかりません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to login_path, notice: "ログアウトしました"
  end
end