class BlogsController < ApplicationController
  # ログインしているかをチェック,ログインしていない場合はブログにアクセスさせない
  before_action :authenticate_user!
  
  before_action :set_blog, only: [:show, :edit, :update ,:destroy]
  
  # index部分はメソッド名
  def index
    # すべてのブログを取得する処理をindexアクションに定義 Blog=モデル名
    @blogs = Blog.all
    # binding.pry # ブレークポイントを作成
    # raise
  end

  # showアククションを定義します。入力フォームと一覧を表示するためインスタンスを2つ生成します。
  def show
    @comment = @blog.comments.build
    @comments = @blog.comments
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end

  def new
    # インスタンス変数は@をつける (viewにわたされる。使用する場合はveiwに変数を書く)
    # Blog.でBlogモデルのインスタンスを生成
    # たぶん、初回のブログ記事作成以外は、余計なパラメータは渡さないためにblogs_params指定する
    # 確認画面の戻るボタンでアクセスしたときのための場合分け
    if params[:back]
      @blog = Blog.new(blogs_params)
    else
      @blog = Blog.new
    end
  end
  
  def create
    @blog = Blog.create(blogs_params)
    @blog.user_id = current_user.id # deviceのメソッドを使って値を取得して@blog.user_idとしてsaveする
    if @blog.save
      redirect_to blogs_path, notice:"ブログを作成しました！" #ここにリダイレクトされる
      NoticeMailer.sendmail_blog(@blog).deliver #メール送信
    else
      render action: 'new'
    end
  end
  
  def edit
   # @blog = Blog.find(params[:id]) はbeforefilterで実行
  end
  
  def update
    # @blog = Blog.find(params[:id]) はbeforefilterで実行
    @blog.update(blogs_params)
    if @blog.save
      redirect_to blogs_path, notice:"ブログを更新しました！"
    else
      render action: "edit"
    end
  end
  
  def destroy
    # @blog = Blog.find(params[:id]) はbeforefilterで実行
    @blog.destroy
    redirect_to blogs_path, notice:"ブログを削除しました！"
  end
  
  def confirm
    # Blog.でBlogモデルのインスタンスを生成
    @blog = Blog.new(blogs_params)
    # modelname.invalid?はバリデーションを実行し、boolean型の戻り値を受け取ります。
    render :new if @blog.invalid?
  end  
  
  private
    def blogs_params
      params.require(:blog).permit(:title, :content)
    end
    
    # メソッドはアクション（routing）で呼ばれるわけではないため、private句の中に定義
    def set_blog
      @blog = Blog.find(params[:id])
    end
  
end
