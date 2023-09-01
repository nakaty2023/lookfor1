names = ["yamada", "abe", "tanaka"]
names.each_with_index do |name, i|
  User.create(
    name: "#{name}",
    email: "test#{i + 1}@example.com",
    password: "password"
  )
end
