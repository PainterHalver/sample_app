User.create!(
  name: "Example User",
  email: "example@example.com",
  password: "111111",
  password_confirmation: "111111",
  admin: true,
)

99.times do |n|
  name = Faker::Name.name[...20]
  email = "example-#{n+1}@example.com"
  password = "111111"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
  )
end
