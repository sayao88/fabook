require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  test "sendmail_blog" do
    mail = NoticeMailer.sendmail_blog
    assert_equal "Sendmail blog", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
