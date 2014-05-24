Fabricator(:invite_user) do
  recipient_name { Faker::Name.name }
  recipient_message { Faker::Lorem.paragraph }
  recipient_email { Faker::Internet.email }
end
