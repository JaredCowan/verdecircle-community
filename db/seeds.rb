# Create some posts.
2.times { |i| Post.create(user_id: 3, subject: "Post Lorem #{i}", body: "this is some dummy post text.") }


2.times do |n|
  User.create(
    first_name: "Fakename#{n}",
    last_name:  Faker::Name.last_name,
    username:   Faker::Internet.user_name,
    email:      Faker::Internet.email,
    password:   BCrypt::Password.create("test", cost: 12)
  )

  u = User.find_by(first_name: "Fakename#{n}")

  u.posts.create(
    subject: Faker::Company.catch_phrase,
    body: Faker::Lorem.paragraph
  )
end

topic_names = %w(general-discussion customers vendors fulfillment accounting warehouse reports feature-request drop-ship-market company-market)%

topic_names.each do |tn|
  Topic.create(name: "#{tn}")
end
