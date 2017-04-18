module ApplicationHelper

  # カレントユーザーをフォローしていて、カレントユーザーがフォローしていないユーザー一覧を取得する
    # 1.カレントユーザーをフォローしているユーザーを取得
  def follow_current_user_list()
    current_user.followers
  end
    # 2.カレントユーザーがまだフォローしていないユーザーであるかどうかをチェック
  def followed_by_current_user?(user)
     user.followers.exists?(id:current_user.id)
  end

    # カレントユーザーがフォローしているユーザーを取得
  def follow_other_user_list()
    current_user.followed_users
  end

    # 2.フォロー先のユーザーがまだカレントユーザーをフォローしていないかどうかをチェック
  def followed_by_other_user?(user)
     user.followed_users.exists?(id:current_user.id)
  end

  # 自分以外のユーザーリスト
  def user_list()
    User.where.not(id:current_user.id)
  end

  # カレントユーザー充てのコメント一覧
  def current_user_topics
    @current_user_topics = current_user.topics.order(:created_at).reverse_order

  end


  # トピック一覧にコメントフォームを出す
  def comment_create(topic_id)
    @topic = Topic.find(topic_id)
    @topic.topic_comments.order(:created_at).build
  end

  # プロフィールイメージ
  def profile_img(user,class_name = "mod-img-profile-small")
    # アップロードした画像用
    return image_tag(user.avatar, alt: user.name, class: class_name) if user.avatar?

    # SNSから引き継いだ画像用
    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, alt: user.name, class: class_name)
  end
end

module ActionView
  module Helpers
    module FormHelper
      def error_messages!(object_name, options = {})
        resource = self.instance_variable_get("@#{object_name}")
        return '' if !resource || resource.errors.empty?

        messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

        html = <<-HTML
          <div class="alert alert-danger">
            <ul>#{messages}</ul>
          </div>
        HTML

        html.html_safe
      end

      def error_css(object_name, method, options = {})
        resource = self.instance_variable_get("@#{object_name}")
        return '' if resource.errors.empty?

        resource.errors.include?(method) ? 'has-error' : ''
      end
    end

    class FormBuilder
      def error_messages!(options = {})
        @template.error_messages!(@object_name, options.merge(object: @object))
      end

      def error_css(method, options = {})
        @template.error_css(@object_name, method, options.merge(object: @object))
      end
    end
  end
end