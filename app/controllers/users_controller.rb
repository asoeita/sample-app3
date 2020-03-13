class UsersController < ApplicationController

  def show
    @user = User.find(params[:id]) #showアクションから外側からも使える
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "welcome to the sample app!" #次の次のリクエストが飛ぶまで続く
      redirect_to @user #デフォルトでid情報を渡す
      #GETリクエストを送る
    else
    render 'new'
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
