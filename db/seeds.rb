# coding: utf-8

User.create!(name: "sample user",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "管理",
             employee_number: "111",
             uid: "aaa",
             admin: true)
             
60.times do |n|
  name = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  affiliation = "フリーランス部"
  employee_number = "1#{n+1}"
  uid = "abc"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               affiliation: affiliation,
               employee_number: employee_number,
               uid: uid)
end