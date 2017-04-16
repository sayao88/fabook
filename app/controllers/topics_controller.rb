class TopicsController < ApplicationController
  # ログインしているかをチェック,ログインしていない場合はトピックにアクセスさせない
  # before_action :authenticate_user!
  
  before_action :set_topic, only: [:show, :edit, :update ,:destroy]
  
  def index
    # すべてのトピックを取得する処理をindexアクションに定義 Topic=モデル名
    @topics = Topic.order(:created_at).reverse_order

  end

  # showアクションを定義します。入力フォームと一覧を表示するためインスタンスを2つ生成します。
  def show
    @comment = @topic.topic_comments.build
    @comments = @topic.topic_comments
    #binding.pry # ブレークポイントを作成
    #Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end

  def new
    #ログインしてる人のみ作成できる
    authenticate_user!
    if params[:back]
      @topic = Topic.new(topics_params)
    else
      @topic = Topic.new
    end
  end
  
  def create
    @topic = Topic.create(topics_params)
    @topic.user_id = current_user.id
    if @topic.save
      redirect_to root_path, notice:"トピックを作成しました！" #ここにリダイレクトされる
      NoticeMailer.sendmail_blog(@topic).deliver #メール送信
    else
      render action: 'new'
    end
  end
  
  def edit
   # @topic = Topic.find(params[:id]) はbeforefilterで実行
  end
  
  def update
    # @topic = Topic.find(params[:id]) はbeforefilterで実行
    @topic.update(topics_params)
    if @topic.save
      redirect_to root_path, notice:"トピックを更新しました！"
    else
      render action: "edit"
    end
  end
  
  def destroy
    # @topic = Topic.find(params[:id]) はbeforefilterで実行
    @topic.destroy
    redirect_to topics_path, notice:"トピックを削除しました！"
  end
  
  def confirm
    # Topic.でTopicモデルのインスタンスを生成
    @topic = Topic.new(topics_params)
    # modelname.invalid?はバリデーションを実行し、boolean型の戻り値を受け取ります。
    render :new if @topic.invalid?
  end  
  
  private
    def topics_params
      params.require(:topic).permit(:title, :content)
    end
    
    # メソッドはアクション（routing）で呼ばれるわけではないため、private句の中に定義
    def set_topic
      @topic = Topic.find(params[:id])
    end
  
end
