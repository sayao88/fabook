module ApplicationHelper

  # カレントユーザーがフォローしているユーザー一覧を取得する
  def friend_list()
    #User.all
    #current_user.followers.where(id:2)
    Relationship.where(follower_id:current_user.id)
  end

  # カレントユーザーをフォローしていて、カレントユーザーがフォローしていないユーザー一覧を取得する
  def follower_user_list()
     Relationship.where.not(follower_id:current_user.id)#.where(followed_id:current_user.id)
  end

  # フォローされていない、していないユーザーリスト
  def other_user_list()
    User.all
  end

  # カレントユーザー充てのコメント一覧
  def current_user_topics
    @current_user_topics = current_user.topics.order(:created_at).reverse_order

  end


  # トピック一覧にコメントを出す
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