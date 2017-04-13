class TopicCommentsController < ApplicationController
    def create
        # ログインユーザーに紐付けてインスタンス生成するためbuildメソッドを使用します。
        @comment = current_user.topic_comments.build(comment_params)
        @topic = @comment.topic
        #@notification = @comment.notifications.build(user_id: @topic.user.id )#commentに紐付いた、notificationを作成します。その際通知と受け手となる、user_idも保存。

        # クライアント要求に応じてフォーマットを変更
        respond_to do |format|
            if @comment.save
                format.html { redirect_to root_path, notice: 'コメントを投稿しました。' }
                format.json { render :index, status: :created, location: @comment }
                # JS形式でレスポンスを返します。
                format.js { render :index }
                # unless @comment.topic.user_id == current_user.id
                #   Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'comment_created', {
                #     message: 'あなたの作成したブログにコメントが付きました'
                #   })
                # end
                # Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'notification_created', {
                #   unread_counts: Notification.where(user_id: @comment.topic.user.id, read: false).count
                # })
            else
                format.html { render :index , notice: 'コメントを投稿できませんでした。時間を置いて再度お試しください。'}
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
    end


    def edit
        @comment = TopicComment.find(params[:id])
        @topic = @comment.topic
    end

    def update
        @comment = TopicComment.find(params[:id])
        @topic = @comment.topic
        @comment.update
        respond_to do |format|
            #redirect_to topic_path(@topic), notice: 'コメントを削除しました。'
            format.html { redirect_to root_path, notice: 'コメントを削除しました。' }
            format.js { render :index }
            # binding.pry
        end
    end

    def destroy
        @comment = TopicComment.find(params[:id])
        @topic = @comment.topic
        @comment.destroy
        respond_to do |format|
            #redirect_to topic_path(@topic), notice: 'コメントを削除しました。'
            format.html { redirect_to root_path, notice: 'コメントを削除しました。' }
            format.js { render :index }
            # binding.pry
        end
    end


    private
        # ストロングパラメーター
        def comment_params
          params.require(:topic_comment).permit(:topic_id, :content)
        end

end
