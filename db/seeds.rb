users = ["yamada", "abe", "tanaka"]
users.each_with_index do |user, i|
  User.create(
    name: "#{user}",
    email: "test#{i + 1}@example.com",
    password: "password"
  )
end
