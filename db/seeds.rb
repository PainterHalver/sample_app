User.create!(
  name: "Example User",
  email: "example@example.com",
  password: "111111",
  password_confirmation: "111111",
  admin: true,
  activated: true,
  activated_at: Time.zone.now,
)

33.times do |n|
  name = Faker::Name.name[...20]
  email = "example-#{n+1}@example.com"
  password = "111111"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now,
  )
end

users = User.order(:created_at).take(6)
33.times do
  content = Faker::Lorem.sentence word_count: 5
  users.each { |user| user.microposts.create! content: content }
end
