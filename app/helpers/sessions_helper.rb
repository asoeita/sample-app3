module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end


#ユーザーを永続的に復元できるようになった
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id #user_idを暗号化してcookiesへ代入
    cookies.permanent[:remember_taken] = user.remember
  end

  def current_user?(user)
     user == current_user
  end

# 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if (user_id = session[:user_id]) #ローカル変数に代入 セッションidを代入しそれを評価
     @current_user ||= User.find_by(id: user_id)

   elsif (user_id = cookies.signed[:user_id]) #署名付きIDを複合化して代入
     user = User.find_by(id: user_id)
     if user && user.authenticated?(cookies[:remember_token])
       log_in user
       @current_user = user
     end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

# 永続的セッションを破棄する
  def forget(user)
   user.forget
   cookies.delete(:user_id)
   cookies.delete(:remember_token)
  end

 # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
   def redirect_back_or(default)
     redirect_to(session[:forwarding_url] || default)
     session.delete(:forwarding_url)
   end

   # アクセスしようとしたURLを覚えておく
   def store_location
     session[:forwarding_url] = request.original_url if request.get? #HEEPリクエストがGETの時だけ実行
   end
end
