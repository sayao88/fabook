class CommentsController < ApplicationController
    before_action :set_comment , only:[:destroy]
    def create
        # ログインユーザーに紐付けてインスタンス生成するためbuildメソッドを使用します。
        @comment = current_user.comments.build(comment_params)
        @blog = @comment.blog
        @notification = @comment.notifications.build(user_id: @blog.user.id )#commentに紐付いた、notificationを作成します。その際通知と受け手となる、user_idも保存。

        # クライアント要求に応じてフォーマットを変更
        respond_to do |format|
            if @comment.save
                format.html { redirect_to blog_path(@blog), notice: 'コメントを投稿しました。' }
                format.json { render :show, status: :created, location: @comment }
                # JS形式でレスポンスを返します。
                format.js { render :index }
                unless @comment.blog.user_id == current_user.id
                  Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'comment_created', {
                    message: 'あなたの作成したブログにコメントが付きました'
                  })
                end
                Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'notification_created', {
                  unread_counts: Notification.where(user_id: @comment.blog.user.id, read: false).count
                })
            else
                format.html { render :new }
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @blog = @comment.blog
        @comment.destroy
        respond_to do |format|
            #redirect_to blog_path(@blog), notice: 'コメントを削除しました。'
            format.html { redirect_to blog_path(@blog), notice: 'コメントを削除しました。' }
            format.js { render :index }
            # binding.pry
        end
    end


    private
        # ストロングパラメーター
        def comment_params
          params.require(:comment).permit(:blog_id, :content)
        end

        # メソッドはアクション（routing）で呼ばれるわけではないため、private句の中に定義
        def set_comment
          @comment = Comment.find(params[:id])
        end

end
