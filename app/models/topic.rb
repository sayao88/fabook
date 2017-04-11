class Topic < ActiveRecord::Base
    belongs_to :user # userモデルに属する
    has_many :topic_comments, dependent: :destroy
    default_scope -> { order(created_at: :desc) }
end
