class Public::EndUsersController < ApplicationController
  before_action :set_user                                     ## アクションの実行前に誰がログインしているのかといった情報を渡す
  before_action :ensure_guest_user, only: [:edit]
  
  def edit                                                    ## ユーザー編集ページの表示
  end
  
  def update                                                  ## ユーザー情報の更新
    @user.update(user_params)                                 #  ストロングパラメーターを受け取り更新する
    redirect_to root_path                                     #  編集後はトップページへ遷移する
  end
  
  def ensure_guest_user                                       ## ゲストユーザーで編集ページへ遷移しようとした場合、トップページへ遷移する
    @user = EndUser.find(params[:id])
    if @user.name == "guestuser"
      redirect_to root_path
    end
  end  
  
  private
  def set_user                                                ## deviseの機能からcurrent_end_userで個人を特定してインスタンス変数へ代入する
    @user = current_end_user
  end
  
  def user_params                                             ## ストロングパラメーター
    params.require(:end_user).permit(:name, :profile_image)   #  end_usersモデルのname,profile_imageカラムのみ扱う
  end
end
