class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  #画面上に表示させる作成日は時刻をフォーマットに従って表示すること
  #strftime は、日付データをフォーマットするメソッド
  validates_presence_of :body, :conversation_id, :user_id
  def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end
