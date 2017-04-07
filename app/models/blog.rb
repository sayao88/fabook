class Blog < ActiveRecord::Base
    validates :title, presence:true
    belongs_to :user # userモデルに属する
    # CommentモデルのAssociationを設定
    has_many :comments, dependent: :destroy
end
