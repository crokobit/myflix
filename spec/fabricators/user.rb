Fabricator(:user)  do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  admin false
  active true
end

Fabricator(:invalid_user, from: :user)  do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password ""
  admin false
  active true
end

