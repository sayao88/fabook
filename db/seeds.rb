# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 10.times do |n|

# end


#Faker::Config.locale = :ja

n=10+1
count_n = n + 10

while n <= count_n
  topic_title = Faker::Lorem.sentence
  topic_content = Faker::Lorem.paragraph

  Topic.create!(
      title:topic_title,
      content:topic_content,
      user_id:n
  )

  name = Faker::LordOfTheRings.character
  email = Faker::Internet.email
  password = "password"
  User.create!(
    name:name,
    email: email,
    password: password,
    password_confirmation: password,
    uid:n
  )
  n = n+1

end

  random = Random.new

  10.times do |no|
    topiccomment_content = Faker::Friends.quote
    TopicComment.create!(
      user_id:random.rand(11..20),
      topic_id:random.rand(11..20),
      content: topiccomment_content
    )
  end