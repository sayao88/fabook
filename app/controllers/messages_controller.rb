class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    if @messages.last
      if @messages.last.user_id != current_user.id
       @messages.last.read = true
       @messages.last.save
      end
    end

    # 誰とのやりとりか
    @talk_person_name = '名無し'# 初期値てきなもの
    if @conversation.sender_id != current_user.id
      @talk_person = User.find(@conversation.sender_id)
    elsif @conversation.recipient_id != current_user.id
      @talk_person = User.find(@conversation.recipient_id)
    else
      #自分自身のメッセージページの場合
      @talk_person = User.find(@conversation.recipient_id)
    end
    @talk_person_name = @talk_person.name


    # 自分へのメッセージを表示したら既読を表示する
    @receive_messages = @messages.where.not(user_id:current_user)

    if @receive_messages
      @receive_messages.each do |rmessage|
        rmessage.read = true
        rmessage.save
      end
    end
    

    # フォーム用
    @message = @conversation.messages.build

  end

  def create
      @message = @conversation.messages.build(message_params)
      if @message.save
          redirect_to conversation_messages_path(@conversation)
      end
  end

  private
    def message_params
      params.require(:message).permit(:body, :user_id)
    end

end
