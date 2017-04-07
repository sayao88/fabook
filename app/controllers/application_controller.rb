class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # notification用記述（ログインしている場合のみ）
  before_action :current_notifications, if: :signed_in?

  def current_notifications
    @notifications_count = Notification.where(user_id: current_user.id).where(read: false).count
  end

  # configure_permitted_parametersという専用のストロングパラメータを設定するメソッドを使用して、
  # nameカラムが新規登録とアカウント更新の際に、パラメータに含まれるようにする。
  
  # before_actionで下で定義したメソッドを実行　# deviseのControllerの場合のみ起動
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  #変数PERMISSIBLE_ATTRIBUTESに配列[:name]を代入
  PERMISSIBLE_ATTRIBUTES_FIRST = %i(name)
  
  protected
  # protected クラス外から呼び出すことができる

    #deviseのストロングパラメーターにカラム追加するメソッドを定義
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES_FIRST)
      devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES_FIRST)
    end


  #画像アップロード用
  PERMISSIBLE_ATTRIBUTES = %i(name avatar avatar_cache)
  private
    #画像アップロード用
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
      devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
    end
end
