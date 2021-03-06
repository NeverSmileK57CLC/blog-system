# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: "Bach Van Ngoc", email: "neversmile12b1@gmail.com",
            password: "123456",
            activated: true,
            activated_at: Time.zone.now)
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  User.create(name: name, email: email, password: password,
    activated: true, activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(1)
  num = Random.rand(4)
  content = Faker::Lorem.paragraph(num*4) + " This is content with #{title}"
  users.each { |user| user.entries.create!(title: title, content: content)}
end

# Follwing relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# 98.times do |n|
#   user1 = User.find(n+1)
#   for i in n+2..100 do
#     user2 = User.find(i)
#     user1.follow user2
#   end
# end
